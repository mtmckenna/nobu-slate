//
//  NoBuSlateTests.m
//  NoBuSlateTests
//
//  Created by Matthew McKenna on 5/27/12.
//  Copyright (c) 2012 Matthew McKenna. All rights reserved.
//

#import "NoBuSlateTests.h"
#import "SlateState.h"
#import "AppDelegate.h"
#import "ViewController.h"


// TODO: integration tests:
// * switching between boxes while keyboard is up
// * moving boxes up

@implementation NoBuSlateTests

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

- (void)testSceneIntegerIncrement
{
    NSString *initSceneNumber = @"1";
    
    NSString *updatedSceneNumber = [viewController sceneString:initSceneNumber
                                          incrementedByInteger:1];
        
    if (![updatedSceneNumber isEqualToString:@"2"])
    {
        STFail(@"Scene should have updated from 1 to 2");
    }
}

- (void)testSceneLetterIncrement
{
    NSString *initSceneNumber = @"1A";
    
    NSString *updatedSceneNumber = [viewController sceneString:initSceneNumber
                                          incrementedByInteger:1];
    
    if (![updatedSceneNumber isEqualToString:@"1B"])
    {
        STFail(@"Scene should have updated from 1A to 1B");
    }
}

- (void)testSceneIntegerDecrement
{
    NSString *initSceneNumber = @"2";
    
    NSString *updatedSceneNumber = [viewController sceneString:initSceneNumber
                                          incrementedByInteger:-1];
    
    if (![updatedSceneNumber isEqualToString:@"1"])
    {
        STFail(@"Scene should have updated from 2 to 1");
    }
}

- (void)testSceneLetterDecrement
{
    NSString *initSceneNumber = @"1B";
    
    NSString *updatedSceneNumber = [viewController sceneString:initSceneNumber
                                          incrementedByInteger:-1];
    
    NSLog(@"updated: %@", updatedSceneNumber);
    if (![updatedSceneNumber isEqualToString:@"1A"])
    {
        STFail(@"Scene should have updated from 1B to 1A");
    }
} 

@end
