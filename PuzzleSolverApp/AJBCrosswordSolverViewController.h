//
//  AJBCrosswordSolverViewController.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 23/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AJBSolutionsViewController.h"
#import "AJBPuzzleHelpViewController.h"
#import "PuzzleSolvers.h"
#import "AJBCrossword.h"
#import "AJBAppDelegate.h"

@interface AJBCrosswordSolverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *solveButton;
@property(nonatomic,strong) NSMutableArray * inputTextFieldArray;
@property(nonatomic,strong) NSNumber * viewHasLoaded;
@property(nonatomic,strong)AJBDictionary * dictionary;
@property (nonatomic, strong) UIActivityIndicatorView *loadingSpinner;
@property(nonatomic, strong) UIView *dimView;
@property(nonatomic, strong) UIImageView *lightView;
@property(nonatomic, strong) NSNumber * easterEggAlreadyEnabled;
@property(nonatomic, strong) NSNumber * easterEggCurrentFrame;
@property(nonatomic, strong) NSTimer * easterEggAnimationTimer;
@property(nonatomic, strong) NSTimer * easterEggSoundTimer;
@end
