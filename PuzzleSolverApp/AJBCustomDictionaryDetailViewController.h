//
//  AJBCustomDictionaryDetailViewController.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 6/11/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AJBAppDelegate.h"
#import "AJBDiskStoredWord.h"
#import "AJBWord.h"
#import "PuzzleSolvers.h"

@interface AJBCustomDictionaryDetailViewController : UIViewController
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextField *wordTextField;
@property (weak, nonatomic) IBOutlet UITextField *definitionTextField;
@property (nonatomic,strong) AJBDiskStoredWord * word;
@property (nonatomic, strong) AJBDictionary *dictionary;
@end
