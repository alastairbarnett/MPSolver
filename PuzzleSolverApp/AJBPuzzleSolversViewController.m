//
//  AJBPuzzleSolversViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 30/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBPuzzleSolversViewController.h"

@implementation AJBPuzzleSolversViewController
@synthesize dictionary;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Set background
    self.tableView.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"plainPaperBackgroundImage.png"]];
    
    //Show the navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender{
    
    //Create the view controller object based on segue identifier
    if([segue.identifier isEqualToString:@"puzzleSolversToAnagramSolver"]){
        AJBAnagramSolverViewController *anagramSolverViewController = segue.destinationViewController;
        anagramSolverViewController.dictionary=self.dictionary;
    }
    else if([segue.identifier isEqualToString:@"puzzleSolversToBoggleSolver"]){
        AJBBoggleSolverViewController *boggleSolverViewController = segue.destinationViewController;
        boggleSolverViewController.dictionary=self.dictionary;
    }
    else if([segue.identifier isEqualToString:@"puzzleSolversToCrosswordSolver"]){
        AJBCrosswordSolverViewController *crosswordSolverViewController = segue.destinationViewController;
        crosswordSolverViewController.dictionary=self.dictionary;
    }
    else if([segue.identifier isEqualToString:@"puzzleSolversToHangmanSolver"]){
        AJBHangmanSolverViewController *hangmanSolverViewController = segue.destinationViewController;
        hangmanSolverViewController.dictionary=self.dictionary;
    }
    else if([segue.identifier isEqualToString:@"puzzleSolversToScrabbleSolver"]){
        AJBScrabbleSolverViewController *scrabbleSolverViewController = segue.destinationViewController;
        scrabbleSolverViewController.dictionary=self.dictionary;
    }
}
@end
