//
//  AJBScrabbleSolverViewController.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 29/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AJBSolutionsViewController.h"
#import "AJBPuzzleHelpViewController.h"
#import "PuzzleSolvers.h"
#import "AJBScrabble.h"
#import "AJBAppDelegate.h"

@interface AJBScrabbleSolverViewController : UIViewController
@property(nonatomic,strong) NSMutableArray * wordInputTextFieldArray;
@property(nonatomic,strong) NSMutableArray * handInputTextFieldArray;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property(nonatomic,strong) NSNumber * viewHasLoaded;
@property(nonatomic,strong)AJBDictionary * dictionary;
@property (nonatomic, strong) UIActivityIndicatorView *loadingSpinner;
@property(nonatomic, strong) UIView *dimView;
@property(nonatomic, strong) UIImageView *lightView;

@end
