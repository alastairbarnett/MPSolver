//
//  AJBCustomDictionaryViewController.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 30/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJBAppDelegate.h"
#import "AJBDiskStoredWord.h"
#import "AJBCustomDictionaryDetailViewController.h"
#import "PuzzleSolvers.h"

@interface AJBCustomDictionaryViewController : UITableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic, strong) NSMutableArray *customWordArray;
@property (nonatomic, strong) AJBDictionary *dictionary;
@property (nonatomic, strong) NSString * wordPriorToEditing;
@end
