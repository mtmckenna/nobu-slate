#import <XCTest/XCTest.h>
#import <KIF/KIF.h>
#import "KIFUITestActor+NoBuSlate.h"

@interface AcceptanceTests : KIFTestCase

@end

@implementation AcceptanceTests

- (void)testProductionName
{
    [tester clearTextFromAndThenEnterText:@"Handcuff Hands" intoViewWithAccessibilityLabel:@"Production Name"];
    [tester tapViewWithAccessibilityLabel:@"done"];

    [tester clearTextFromAndThenEnterText:@"Handcuff Hands 2: It Didn't Count" intoViewWithAccessibilityLabel:@"Production Name"];
    [tester tapViewWithAccessibilityLabel:@"done"];
}

- (void)testSceneNumberSwipe
{
    [tester clearTextFromAndThenEnterText:@"5" intoViewWithAccessibilityLabel:@"Scene"];
    [tester tapViewWithAccessibilityLabel:@"done"];

    [tester waitForTimeInterval:1.0];

    [tester swipeViewWithAccessibilityLabel:@"5" inDirection:KIFSwipeDirectionUp];;
    [tester swipeViewWithAccessibilityLabel:@"6" inDirection:KIFSwipeDirectionDown];
    [tester swipeViewWithAccessibilityLabel:@"5" inDirection:KIFSwipeDirectionDown];
}

@end