@class SlateState;

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController <UITextFieldDelegate, NSFetchedResultsControllerDelegate>
{    
    IBOutlet UITextField *productionNameField;
    IBOutlet UITextField *sceneStringField;
    IBOutlet UITextField *takeNumberField;
    IBOutlet UIView *productionNameView;
    IBOutlet UIView *sceneStringView;
    IBOutlet UIView *takeNumberView;
    IBOutlet UIView *dateNumberView;
    IBOutlet UIView *audioFileNameView;
    IBOutlet UIView *channelsView;
    IBOutlet UITextField *audioFileNameField;
    IBOutlet UITextField *audioLeftChannelField;
    IBOutlet UITextField *audioRightChannelField;
    IBOutlet UITextField *currentDateField;
    IBOutlet UITextField *currentTimeField;
    
    IBOutlet UILabel *sceneLabel;
    IBOutlet UILabel *takeLabel;
    IBOutlet UILabel *dateTimeLabel;
    IBOutlet UILabel *audioFileLabel;
    IBOutlet UILabel *channelsLabel;
    IBOutlet UILabel *lChannelLabel;
    IBOutlet UILabel *rChannelLabel;
    
    UIButton *doneButton;
}

@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, strong) NSTimer *clockTimer;

@property (nonatomic, strong) UIColor *pulseColor;
@property (nonatomic, strong) UIColor *goColor;

@property (nonatomic) int countdownDurationInSeconds;
@property (nonatomic, strong) NSMutableArray *fieldArray;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) SlateState *slateState;

- (void)toggleCountdown;
- (void)setColorsWithBackgroundColor:(UIColor *)bgColor 
                             textColor:(UIColor *)textColor
                   textBackgroundColor:(UIColor *)textBgColor;

- (void)restoreColors;
- (void)updateDateAndTime;

- (void)startCountdown;
- (void)resetCountdown;

- (IBAction)handleSideSwipe:(id)sender;
- (IBAction)handleUpSwipe:(id)sender;
- (IBAction)handleDownSwipe:(id)sender;

- (NSString *)sceneString:(NSString *)aString incrementedByInteger:(int)increment;

@end
