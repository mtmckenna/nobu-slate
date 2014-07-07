#import "KIFUITestActor+NoBuSlate.h"

@implementation KIFUITestActor (NoBuSlate)

- (void)reset
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        BOOL successfulReset = YES;

        KIFTestCondition(successfulReset, error, @"Failed to reset some part of the application.");

        return KIFTestStepResultSuccess;
    }];
}

@end
