//
//  AJBHomeViewController.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 30/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleSolvers.h"
#import "AJBPuzzleSolversViewController.h"
#import "AJBCustomDictionaryViewController.h"
#import "AJBDiskStoredWord.h"

@interface AJBHomeViewController : UIViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong)AJBDictionary *dictionary;
@end
