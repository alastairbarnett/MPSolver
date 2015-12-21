//
// This program is submitted as part of the assessment for IT1001.
// This is all my own work. I have referenced any work used from
// other sources and have not plagiarised the work of others.
// (signed) Alastair Barnett
//
/*
Resources:

Colored Puzzle background image
http://freephotoshoppatterns.com/2010/11/puzzle-background/

All wooden button and plank images
http://designbyfirgs.com/blog/2010/09/wooden-web-button-pack/
 
Red cell and glossy red button image
http://www.clker.com/

Puzzle with grey background image
http://www.crestock.com/

Paper background image
http://www.publicdomainpictures.net/view-image.php?image=26025&picture=white-paper-texture&large=1

Sun background image
http://www.publicdomainpictures.net

Puzzle Image Icon (Icons included but not working)
http://www.clker.com/
 
Song "Walk The Dinosaur" by George Clinton & The Goombas
 
Wordlist
http://wordlist.sourceforge.net/12dicts-readme.html

The project was originally named PuzzleSolverApp, which is why the that appears at the top of the source files.
*/
//
//  AJBAppDelegate.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 15/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBAppDelegate.h"

@implementation AJBAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

// ************************************************************************************


#pragma mark -
#pragma mark application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
}


// Saves the managed object context
- (void)saveContext {
    
    // Create a variable to hold any errors
    NSError *error = nil;
    
    // Get a reference to the managed object context
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    // Make sure we have got a managed object context to save
    if (managedObjectContext != nil) {
        
        // Attempt a save
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            abort();
            
        }
        
    }
    
}


#pragma mark -
#pragma mark Core Data stack


// -------------------------------------------------------------------------------------------------------------------
// * Returns the managed object context for the application. If the context doesn't already exist, it is created and *
// * bound to the persistent store coordinator for the application. *
// -------------------------------------------------------------------------------------------------------------------

- (NSManagedObjectContext *)managedObjectContext {
    
    // If the MOC already exists then return it
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    // Otherwise, if we get to here, we need to create it
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    // Return the MOC
    return _managedObjectContext;
    
}


// ------------------------------------------------------------------------------------------------------------------------------------------
//  * Returns the managed object model for the application. If the model doesn't already exist, it is created from the application's model. *
// ------------------------------------------------------------------------------------------------------------------------------------------

- (NSManagedObjectModel *)managedObjectModel {
    
    // If the MOM already exists then return it
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    // Otherwise, if we get to here, we need to create it
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PuzzleSolverApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // Return the MOM
    return _managedObjectModel;
    
}


// ---------------------------------------------------------------------------------------------------------------------------------
// * Returns the persistent store coordinator for the application. If the coordinator doesn't already exist, it is created and the *
// * application's store added to it. *
// ---------------------------------------------------------------------------------------------------------------------------------

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    // If the PSC already exists then return it
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Otherwise, if we get to here, we need to create it
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PuzzleSolverApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        abort();
        
    }
    
    // Return the PSC
    return _persistentStoreCoordinator;
    
}

// Returns the URL to the application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
}

@end