//
//  AJBAnagramSolverViewController.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 17/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AJBSolutionsViewController.h"
#import "AJBPuzzleHelpViewController.h"
#import "PuzzleSolvers.h"
#import "AJBAnagram.h"
#import "AJBAppDelegate.h"

@interface AJBAnagramSolverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *anagramSolverTextBox;
@property (weak, nonatomic) IBOutlet UIButton *anagramSolverButton;
@property(nonatomic,strong)AJBDictionary * dictionary;
@property (nonatomic, strong) UIActivityIndicatorView *loadingSpinner;
@property(nonatomic, strong) UIView *dimView;
@property(nonatomic, strong) UIImageView *lightView;
@end
