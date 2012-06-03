//
//  ViewController.h
//  NoBuSlate
//
//  Created by Matthew McKenna on 5/27/12.
//  Copyright (c) 2012 Matthew McKenna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <UITextFieldDelegate, AVAudioPlayerDelegate>
{    
    IBOutlet UITextField *productionNameField;
    IBOutlet UITextField *sceneNumberField;
    IBOutlet UITextField *takeNumberField;
    IBOutlet UIView *productionNameView;
    IBOutlet UIView *sceneNumberView;
    IBOutlet UIView *takeNumberView;
    IBOutlet UIView *dateNumberView;
    IBOutlet UIView *audioFileNameView;
    IBOutlet UIView *channelsView;
    IBOutlet UITextField *audioFileNameField;
    IBOutlet UITextField *audioLeftChannelField;
    IBOutlet UITextField *audioRightChannelField;
    IBOutlet UITextField *currentDateField;
    IBOutlet UITextField *currentTimeField;
    IBOutlet UIScrollView *scrollContainer;
    
    IBOutlet UILabel *sceneLabel;
    IBOutlet UILabel *takeLabel;
    IBOutlet UILabel *dateTimeLabel;
    IBOutlet UILabel *audioFileLabel;
    IBOutlet UILabel *channelsLabel;
    IBOutlet UILabel *lChannelLabel;
    IBOutlet UILabel *rChannelLabel;

    NSTimer *clockTimer;
    NSTimer *countdownTimer;
    
    UIColor *stoppedColor;
    UIColor *countdownColor;
    UIColor *runningColor;
    NSMutableArray *fieldArray;
    
    NSString *productionName;
    NSString *audioFileName;
    NSString *audioLeftChannel;
    NSString *audioRightChannel;
    int sceneNumber;
    int takeNumber;
    int countdownDurationInSeconds;
}

@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, strong) UIColor *stoppedColor;
@property (nonatomic, strong) UIColor *countdownColor;
@property (nonatomic, strong) UIColor *runningColor;
@property (nonatomic) int countdownDurationInSeconds;
@property (nonatomic, strong) NSMutableArray *fieldArray;

@property (nonatomic, strong) NSString *productionName;
@property (nonatomic, strong) NSString *audioFileName;
@property (nonatomic, strong) NSString *audioLeftChannel;
@property (nonatomic, strong) NSString *audioRightChannel;
@property (nonatomic) int sceneNumber;
@property (nonatomic) int takeNumber;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

- (void)toggleCountdown;
- (void)setColorsWithBackgroundColor:(UIColor *)bgColor 
                             textColor:(UIColor *)textColor
                   textBackgroundColor:(UIColor *)textBgColor;

- (void)restoreColors;
- (void)updateDateAndTime;
- (void)prepareAudioFiles;

- (void)startCountdown;
- (void)resetCountdown;

- (IBAction)handleSideSwipe:(id)sender;
- (IBAction)handleUpSwipe:(id)sender;
- (IBAction)handleDownSwipe:(id)sender;

@end
