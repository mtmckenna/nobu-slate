//
//  ViewController.m
//  NoBuSlate
//
//  Created by Matthew McKenna on 5/27/12.
//  Copyright (c) 2012 Matthew McKenna. All rights reserved.
//

#import "ViewController.h"
#import "NSTimer+Blocks.h"
#import "SlateState.h"

@implementation ViewController

@synthesize countdownTimer;
@synthesize clockTimer;
@synthesize pulseColor;
@synthesize goColor;
@synthesize countdownDurationInSeconds;
@synthesize fieldArray;

@synthesize managedObjectContext;
@synthesize slateState;

long MIN = 60;

AVAudioPlayer *audioPlayerPulse;
AVAudioPlayer *audioPlayerFinished;
UITextField *activeTextField;

BOOL didAttemptStateInitialization = NO;
static NSArray *sceneAlphabet = nil;
static int letterCount;

#pragma mark - Countdown methods

- (void)toggleCountdown
{
    if (self.countdownTimer)
    {
        [self resetCountdown];
    }
    else
    {
        [self startCountdown];
    }
}

- (void)startCountdown
{   
    int __block currentCountdown = self.countdownDurationInSeconds;
    
    void (^myBlock)() = ^() {        
        currentCountdown = currentCountdown - 1;
        
        if ([audioPlayerPulse isPlaying])
        {
            [audioPlayerPulse stop];
        }
        
        // Reached end of countdown
        if (currentCountdown <= 0)
        {
            [self setColorsWithBackgroundColor:[UIColor blackColor] 
                                     textColor:[UIColor blackColor]
                           textBackgroundColor:self.pulseColor];
            
            [audioPlayerFinished play];
        }
        else 
        {
            [self setColorsWithBackgroundColor:[UIColor blackColor] 
                                     textColor:[UIColor whiteColor]
                           textBackgroundColor:self.goColor];
            [audioPlayerPulse play]; 
        }        
    };
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                                            block:myBlock 
                                                          repeats:YES];
    
    [self setColorsWithBackgroundColor:[UIColor blackColor] 
                             textColor:[UIColor whiteColor]
                   textBackgroundColor:self.goColor];
    [audioPlayerPulse play];
    
}

- (void)resetCountdown
{
    [countdownTimer invalidate];
    countdownTimer = nil;
}

#pragma mark - Audio methods

- (void)prepareAudioFiles
{
    // TODO: handle error
    
    // Countdown up ping sounds
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"countdown-pulse" ofType: @"wav"];        
    NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:soundFilePath];   
    audioPlayerPulse = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    
    // "Go" ping sound
    soundFilePath = [[NSBundle mainBundle] pathForResource: @"countdown-finished" ofType: @"wav"];
    fileUrl = [[NSURL alloc] initFileURLWithPath:soundFilePath];   
    audioPlayerFinished = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    
    audioPlayerFinished.delegate = self;
    audioPlayerPulse.delegate = self;
    
    [audioPlayerFinished prepareToPlay];
    [audioPlayerPulse prepareToPlay];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%@ has error: %@", player, error);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (player == audioPlayerFinished)
    {
        [self resetCountdown];
    }
         
    [self restoreColors];    
}

#pragma mark - Color methods

- (void)setColorsWithBackgroundColor:(UIColor *)bgColor 
                           textColor:(UIColor *)textColor
                 textBackgroundColor:(UIColor *)textBgColor
{
    [self.view setBackgroundColor:bgColor];
    
    for (id field in fieldArray)
    {
        if (![field isMemberOfClass:[UIView class]])
        {
            [(UITextField *)field setTextColor:textColor];
        }
        
        [field setBackgroundColor:textBgColor];
    }
}

- (void)restoreColors
{
    [self.view setBackgroundColor:[UIColor whiteColor]];

    for (UITextField *field in fieldArray)
    {
        if (![field isMemberOfClass:[UIView class]])
        {
            [field setTextColor:[UIColor whiteColor]];
        }
        
        [field setBackgroundColor:[UIColor blackColor]];
    }
}

#pragma mark - Update views

- (void)updateDateAndTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *dateString = [dateFormat stringFromDate:now];
    NSString *timeString = [timeFormat stringFromDate:now];
    
    currentDateField.text = dateString;
    currentTimeField.text = timeString;
}

- (void)updateProductionName
{
    productionNameField.text = self.slateState.productionName;
    [self saveContext];
}

- (void)updateSceneString
{
    sceneStringField.text = [NSString stringWithFormat:@"%@", 
                             self.slateState.sceneString];
    [self saveContext];
}

- (void)updateTakeNumber
{
    takeNumberField.text = [NSString stringWithFormat:@"%@", 
                            self.slateState.takeNumber];
    [self saveContext];
}

- (void)updateAudioFileName
{
    audioFileNameField.text = self.slateState.audioFileName;
    [self saveContext];
}

- (void)updateAudioLeftChannel
{
    audioLeftChannelField.text = self.slateState.audioLeftChannel;
    [self saveContext];
}

- (void)updateAudioRightChannel
{
    audioRightChannelField.text = self.slateState.audioRightChannel;
    [self saveContext];
}

#pragma mark - Handle core data

- (void)populateModels
{    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"SlateState" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;

    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    // TODO: Better error handling
    if ([objects count] == 0 && didAttemptStateInitialization)
    {
        NSLog(@"Error: populateModels unable to create Core Data entity.");
        return;
    }
    
    if ([objects count] == 0) 
    {
        self.slateState = [NSEntityDescription insertNewObjectForEntityForName:@"SlateState" 
                                                                    inManagedObjectContext:self.managedObjectContext];
        [self populateModels];
        
    } 
    else 
    {
        self.slateState = [objects objectAtIndex:0];
    }
}

#pragma mark - Detect Scene Pattern
// Case 1 - the scene number ends in a number
// Case 2 - the scene number ends in a letter
- (NSString *)sceneString:(NSString *)aString incrementedByInteger:(int)increment
{
    char lastCharacter = [aString characterAtIndex:[aString length] - 1];
    BOOL isDigit = isdigit(lastCharacter);
    
    NSString *newString = aString;
    
    // If the last char is a digit, increment the value of the number by increment...
    if (isDigit)
    {
        NSError *error = NULL;
        NSRegularExpression *sceneNumberRegEx = 
        [[NSRegularExpression alloc] initWithPattern:@"(\\d+)[a-zA-Z]?$" 
                                             options:NSRegularExpressionSearch 
                                               error:&error];
        
        NSArray *matches = [sceneNumberRegEx matchesInString:aString
                                                     options:0
                                                       range:NSMakeRange(0, [aString length])];
        
        if ([matches count] > 0)
        {
            NSRange range =[(NSTextCheckingResult *)[matches objectAtIndex:0] rangeAtIndex:1];
            int newNumberValue = [[aString substringWithRange:range] intValue] + increment;
            if (newNumberValue < 1)
            {
                newNumberValue = 0;
            }
            
            newString = [NSString stringWithFormat:@"%@%d", 
                         [aString substringToIndex:range.location],
                         newNumberValue];
        }
    }
    // Else use the next letter in the alphabet
    else
    {
        NSString *lastCharacterString = [aString substringFromIndex:[aString length] - 1];
        int currentIndex = [sceneAlphabet indexOfObject:lastCharacterString];
        
        // Number of complete trips across the alphabet
        int letterCycles = (int)(currentIndex + increment)/letterCount;
        
        // Formula to get next letter index taking looping around the array into
        // account
        int letterIndex = currentIndex + increment - letterCycles * letterCount;
        
        if (letterIndex < 0) letterIndex = letterCount + letterIndex;
        
        NSString *scenePrefix = [aString substringToIndex:[aString length] - 1];
        
        lastCharacterString = [sceneAlphabet objectAtIndex:letterIndex];
        
        newString = [NSString stringWithFormat:@"%@%@", 
                     scenePrefix,
                     lastCharacterString];
    }
    
    return newString;
}

#pragma mark - UIControl delegate methods

- (void)saveContext
{
    NSError *error = nil;
    if (self.managedObjectContext != nil) {
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == productionNameField)
    {
        self.slateState.productionName = productionNameField.text;
    }
    else if (textField == sceneStringField)
    {
        self.slateState.sceneString = sceneStringField.text;
    }
    else if (textField == takeNumberField)
    {
        self.slateState.takeNumber = 
        [NSNumber numberWithInt:[takeNumberField.text intValue]];
    }
    else if (textField == audioFileNameField)
    {
        self.slateState.audioFileName = audioFileNameField.text;
    }
    else if (textField == audioLeftChannelField)
    {
        self.slateState.audioLeftChannel = audioLeftChannelField.text;
    }
    else if (textField == audioRightChannelField)
    {
        self.slateState.audioRightChannel = audioRightChannelField.text;
    }
    
    [self saveContext];
    [textField resignFirstResponder];
    activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent: (UIEvent *)event 
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}

- (void)didFinishEditingField
{
    [self textFieldDidEndEditing:activeTextField];
}

- (void)configureNumberPadAccessoryView
{
    UIToolbar* numberToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 
                                                                           0, 
                                                                           self.view.bounds.size.width, 
                                                                           50)];
    
//    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didFinishEditingField)],
                           nil];
    [numberToolbar sizeToFit];
    audioFileNameField.inputAccessoryView = numberToolbar;
    takeNumberField.inputAccessoryView = numberToolbar;
}

#pragma mark - Handle gestures

- (IBAction)handleUpSwipe:(id)sender
{
    UIView *touchedView = [(UISwipeGestureRecognizer *)sender view];

    if (touchedView == sceneStringView)
    {
        NSString *newSceneString = [self sceneString:self.slateState.sceneString 
                                incrementedByInteger:1];
        
        self.slateState.sceneString = newSceneString;
        [self updateSceneString];
    }
    else if (touchedView == takeNumberView)
    {
        int value = [self.slateState.takeNumber intValue] + 1;
        self.slateState.takeNumber = [NSNumber numberWithInt:value];        
        [self updateTakeNumber];
    }
    else if (touchedView == audioFileNameView)
    {
        // TODO: add ability to parse field with file extension
        int fileNumber = [self.slateState.audioFileName intValue] + 1;
        self.slateState.audioFileName = [NSString stringWithFormat:@"%03d", fileNumber];
        [self updateAudioFileName];
    }
}

- (IBAction)handleDownSwipe:(id)sender
{
    UIView *touchedView = [(UISwipeGestureRecognizer *)sender view];
    
    if (touchedView == sceneStringView)
    {
        NSString *newSceneString = [self sceneString:self.slateState.sceneString 
                                incrementedByInteger:-1];
        
        self.slateState.sceneString = newSceneString;
        [self updateSceneString];
    }
    else if (touchedView == takeNumberView)
    {
        int value = [self.slateState.takeNumber intValue] - 1;
        
        if (value < 1) value = 1;
        
        self.slateState.takeNumber = [NSNumber numberWithInt:value];
        [self updateTakeNumber];
    }
    else if (touchedView == audioFileNameView)
    {
        int fileNumber = [self.slateState.audioFileName intValue] - 1;
        self.slateState.audioFileName = [NSString stringWithFormat:@"%03d", fileNumber];
        [self updateAudioFileName];
    }
}

- (IBAction)handleSideSwipe:(id)sender
{
    [self toggleCountdown];
}

- (IBAction)handleTap:(id)sender
{
    // Hide keyboard. This is mainly here because the number pad doesn't have
    // a done button.
    if (activeTextField)
    {
        [self textFieldDidEndEditing:activeTextField];
    }
}

#pragma mark - Keyboard methods

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
    // TODO: Handle portrait mode
    // Keyboard height
    float offset = kbSize.width;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, offset, 0.0);
    NSLog(@"offset: %f", offset);
    scrollContainer.contentInset = contentInsets;
    scrollContainer.scrollIndicatorInsets = contentInsets;
    
    // The screen rect that ISN'T covered by the keyboard.
    CGRect aRect = self.view.bounds;
    aRect.size.height -= offset;
    NSLog(@"uncovered screen: %f", aRect.size.height);
    
    CGRect activeFieldBounds = [activeTextField convertRect:activeTextField.bounds toView:scrollContainer];
    CGPoint bottomOfBoxPoint = activeFieldBounds.origin;
    bottomOfBoxPoint.y += activeFieldBounds.size.height;
    
    NSLog(@"bottomOfBoxPoint: x: %f, y: %f", bottomOfBoxPoint.x, bottomOfBoxPoint.y);
    NSLog(@"aRect origin: x: %f, y: %f", aRect.origin.x, aRect.origin.y);
    NSLog(@"aRect size: width: %f, height: %f", aRect.size.width, aRect.size.height);

    
    // Want to know if the BOTTOM of the text field is covered up by the keyboard.
    //bottomOfBoxPoint.y += activeFieldBounds.size.height;
    
//    if (!CGRectContainsPoint(aRect, bottomOfBoxPoint) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, bottomOfBoxPoint.y - aRect.size.height);
//        [scrollContainer setContentOffset:scrollPoint animated:YES];
//    }

    if (!CGRectContainsPoint(aRect, bottomOfBoxPoint) ) {
        CGPoint scrollPoint = CGPointMake(0.0, bottomOfBoxPoint.y - activeFieldBounds.size.height);
        [scrollContainer setContentOffset:scrollPoint animated:YES];
    }
    
//    CGRect availableScreenFrame = self.view.frame;
//    availableScreenFrame.size.height -= offset;
//    activeTextField.frame = availableScreenFrame;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollContainer.contentInset = contentInsets;
    scrollContainer.scrollIndicatorInsets = contentInsets;
}
- (IBAction)dismissKeyboard:(id)sender
{
    [activeTextField resignFirstResponder];
}

#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Skip I and O since they can be confused for a number
    sceneAlphabet =[NSArray arrayWithObjects:
                    @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", 
                    @"K", @"L", @"M", @"N", @"P", @"Q", @"R", @"S", @"T", 
                    @"U", @"V", @"W", @"X", @"Y", @"Z",
                    nil];
    
    letterCount = [sceneAlphabet count];
    
    [self prepareAudioFiles];
    [self updateDateAndTime];
    
    productionNameField.delegate = self;
    sceneStringField.delegate = self;
    takeNumberField.delegate = self;
    audioFileNameField.delegate = self;
    audioLeftChannelField.delegate = self;
    audioRightChannelField.delegate = self;
    audioLeftChannelField.delegate = self;
    audioRightChannelField.delegate = self;
    self.countdownDurationInSeconds = 1;
    sceneStringField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    audioFileNameField.keyboardType = UIKeyboardTypeNumberPad;
    takeNumberField.keyboardType = UIKeyboardTypeNumberPad;
    [self configureNumberPadAccessoryView];
        
    // Keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // This timer updates the date/time field
    self.clockTimer = [NSTimer scheduledTimerWithTimeInterval:MIN 
                                                       target:self 
                                                     selector:@selector(updateDateAndTime) 
                                                     userInfo:nil 
                                                      repeats:YES];
    
    pulseColor = [UIColor colorWithRed:0 green:0.501961 blue:0 alpha:1];
    goColor = [UIColor colorWithRed:0.501961 green:0 blue:.0 alpha:1];
    
    [self populateModels];

    [self updateAudioFileName];
    [self updateAudioLeftChannel];
    [self updateAudioRightChannel];
    [self updateProductionName];
    [self updateTakeNumber];
    [self updateSceneString];
    
    // TODO: Maybe there's a better way to do this...
    self.fieldArray = [NSMutableArray array];
    [self.fieldArray addObject:productionNameField];
    [self.fieldArray addObject:sceneStringField];
    [self.fieldArray addObject:takeNumberField];
    [self.fieldArray addObject:sceneStringView];
    [self.fieldArray addObject:takeNumberView];
    [self.fieldArray addObject:dateNumberView];
    [self.fieldArray addObject:audioFileNameView];
    [self.fieldArray addObject:channelsView];
    [self.fieldArray addObject:audioFileNameField];
    [self.fieldArray addObject:audioLeftChannelField];
    [self.fieldArray addObject:audioRightChannelField];
    [self.fieldArray addObject:currentDateField];
    [self.fieldArray addObject:currentTimeField];
    [self.fieldArray addObject:sceneLabel];
    [self.fieldArray addObject:takeLabel];
    [self.fieldArray addObject:dateTimeLabel];
    [self.fieldArray addObject:audioFileLabel];
    [self.fieldArray addObject:channelsLabel];
    [self.fieldArray addObject:lChannelLabel];
    [self.fieldArray addObject:rChannelLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    if (clockTimer)
    {
        [clockTimer invalidate];
        clockTimer = nil;
    }

    if (countdownTimer)
    {
        [countdownTimer invalidate];
        countdownTimer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardDidHideNotification 
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
