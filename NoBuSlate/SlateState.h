#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SlateState : NSManagedObject

@property (nonatomic, retain) NSString * audioFileName;
@property (nonatomic, retain) NSString * audioLeftChannel;
@property (nonatomic, retain) NSString * audioRightChannel;
@property (nonatomic, retain) NSString * productionName;
@property (nonatomic, retain) NSString * sceneString;
@property (nonatomic, retain) NSNumber * takeNumber;

@end