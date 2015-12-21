//
//  AJBBoggleSolverViewController.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 22/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AJBSolutionsViewController.h"
#import "AJBPuzzleHelpViewController.h"
#import "PuzzleSolvers.h"
#import "AJBBoggle.h"
#import "AJBAppDelegate.h"

@interface AJBBoggleSolverViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *solveButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (nonatomic,strong)NSMutableArray* inputTextFieldArray;
@property (nonatomic,strong)NSNumber * viewHasLoaded;
@property (nonatomic,strong)AJBDictionary * dictionary;
@property (nonatomic, strong) UIActivityIndicatorView *loadingSpinner;
@property(nonatomic, strong) UIView *dimView;
@property(nonatomic, strong) UIImageView *lightView;
@property(nonatomic, strong) UITextField * currentFirstResponder;
@end
