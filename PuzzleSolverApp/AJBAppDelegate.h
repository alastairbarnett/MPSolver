//
//  AJBAppDelegate.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 15/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleSolvers.h"

//App Delegate Class

@interface AJBAppDelegate : UIResponder <UIApplicationDelegate>
//Declare Windows
@property (strong, nonatomic) UIWindow *window;

//Declare Core Data Properties
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
