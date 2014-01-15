//
//  THAppDelegate.h
//  THSegmentedControl
//
//  Created by Taylor Halliday on 1/15/14.
//  Copyright (c) 2014 5Celsus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
