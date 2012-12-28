//
//  NoBuSlateApplicationTests.m
//  NoBuSlateApplicationTests
//
//  Created by Matthew McKenna on 12/25/12.
//
//

#import "NoBuSlateApplicationTests.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation NoBuSlateApplicationTests

- (void)setUp
{
    [super setUp];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    viewController = (ViewController *)appDelegate.window.rootViewController;
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testOutletsAreNotNil
{    
    STAssertNotNil([viewController valueForKey:@"productionNameField"], @"Production UITextField shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"sceneStringField"], @"Scene number UITextField shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"takeNumberField"], @"Take number UITextField shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"productionNameView"], @"Production name view shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"sceneStringView"], @"Scene number view shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"takeNumberView"], @"Take number view shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"dateNumberView"], @"Date/time view shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"audioFileNameView"], @"Audio file name view shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"channelsView"], @"Channel view shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"audioFileNameField"], @"Audio file name UITextField shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"audioLeftChannelField"], @"Audio left channel UITextField shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"audioRightChannelField"], @"Audio right channel UITextField shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"currentDateField"], @"Current date UITextField shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"currentTimeField"], @"Current time UITextField shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"sceneLabel"], @"Scene label shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"takeLabel"], @"Take label shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"dateTimeLabel"], @"Date/time label shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"audioFileLabel"], @"Audio file label shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"channelsLabel"], @"Channels label label shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"lChannelLabel"], @"Left channel label shouldn't be nil.");
    STAssertNotNil([viewController valueForKey:@"rChannelLabel"], @"Right channel label shouldn't be nil.");
}

@end
