#import <XCTest/XCTest.h>

#import "SlateState.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface NoBuSlateTests : XCTestCase
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) ViewController *viewController;
@end


@implementation NoBuSlateTests

- (void)setUp
{
    [super setUp];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.viewController = (ViewController *)self.appDelegate.window.rootViewController;
}

- (void)tearDown
{    
    [super tearDown];
}

- (void)testSceneIntegerIncrement
{
    NSString *initSceneNumber = @"1";
    
    NSString *updatedSceneNumber = [self.viewController sceneString:initSceneNumber
                                          incrementedByInteger:1];
        
    if (![updatedSceneNumber isEqualToString:@"2"])
    {
        XCTFail(@"Scene should have updated from 1 to 2");
    }
}

- (void)testSceneLetterIncrement
{
    NSString *initSceneNumber = @"1A";
    
    NSString *updatedSceneNumber = [self.viewController sceneString:initSceneNumber
                                          incrementedByInteger:1];
    
    if (![updatedSceneNumber isEqualToString:@"1B"])
    {
        XCTFail(@"Scene should have updated from 1A to 1B");
    }
}

- (void)testSceneIntegerDecrement
{
    NSString *initSceneNumber = @"2";
    
    NSString *updatedSceneNumber = [self.viewController sceneString:initSceneNumber
                                          incrementedByInteger:-1];
    
    if (![updatedSceneNumber isEqualToString:@"1"])
    {
        XCTFail(@"Scene should have updated from 2 to 1");
    }
}

- (void)testSceneLetterDecrement
{
    NSString *initSceneNumber = @"1B";
    
    NSString *updatedSceneNumber = [self.viewController sceneString:initSceneNumber
                                          incrementedByInteger:-1];
    
    NSLog(@"updated: %@", updatedSceneNumber);
    if (![updatedSceneNumber isEqualToString:@"1A"])
    {
        XCTFail(@"Scene should have updated from 1B to 1A");
    }
}


- (void)testOutletsAreNotNil
{
    XCTAssertNotNil([self.viewController valueForKey:@"productionNameField"], @"Production UITextField shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"sceneStringField"], @"Scene number UITextField shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"takeNumberField"], @"Take number UITextField shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"productionNameView"], @"Production name view shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"sceneStringView"], @"Scene number view shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"takeNumberView"], @"Take number view shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"dateNumberView"], @"Date/time view shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"audioFileNameView"], @"Audio file name view shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"channelsView"], @"Channel view shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"audioFileNameField"], @"Audio file name UITextField shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"audioLeftChannelField"], @"Audio left channel UITextField shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"audioRightChannelField"], @"Audio right channel UITextField shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"currentDateField"], @"Current date UITextField shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"currentTimeField"], @"Current time UITextField shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"sceneLabel"], @"Scene label shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"takeLabel"], @"Take label shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"dateTimeLabel"], @"Date/time label shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"audioFileLabel"], @"Audio file label shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"channelsLabel"], @"Channels label label shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"lChannelLabel"], @"Left channel label shouldn't be nil.");
    XCTAssertNotNil([self.viewController valueForKey:@"rChannelLabel"], @"Right channel label shouldn't be nil.");
}

@end
