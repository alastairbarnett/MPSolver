//
//  AJBPuzzleSolversViewController.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 30/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleSolvers.h"
#import "AJBAnagramSolverViewController.h"
#import "AJBBoggleSolverViewController.h"
#import "AJBCrosswordSolverViewController.h"
#import "AJBHangmanSolverViewController.h"
#import "AJBScrabbleSolverViewController.h"

@interface AJBPuzzleSolversViewController : UITableViewController
@property(nonatomic,strong)AJBDictionary * dictionary;
@end
