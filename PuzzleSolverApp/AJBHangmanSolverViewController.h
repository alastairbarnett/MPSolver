//
//  AJBHangmanSolverViewController.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 24/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AJBSolutionsViewController.h"
#import "AJBPuzzleHelpViewController.h"
#import "PuzzleSolvers.h"
#import "AJBHangman.h"
#import "AJBAppDelegate.h"

@interface AJBHangmanSolverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *guessLabel;
@property (weak, nonatomic) IBOutlet UITextField *guessedLettersField;
@property (weak, nonatomic) IBOutlet UIButton *findGuessButton;
@property(nonatomic,strong) NSMutableArray * inputTextFieldArray;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property(nonatomic,strong) NSNumber * viewHasLoaded;
@property(nonatomic,strong)AJBDictionary * dictionary;
@property (nonatomic, strong) UIActivityIndicatorView *loadingSpinner;
@property(nonatomic, strong) UIView *dimView;
@property(nonatomic, strong) UIImageView *lightView;
@end
