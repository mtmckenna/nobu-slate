//
//  AppDelegate.h
//  NoBuSlate
//
//  Created by Matthew McKenna on 5/27/12.
//  Copyright (c) 2012 Matthew McKenna. All rights reserved.
//

@class ViewController;
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
