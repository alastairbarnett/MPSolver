//
//  AJBPuzzleHelpViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 11/11/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBPuzzleHelpViewController.h"

@implementation AJBPuzzleHelpViewController

//Initialize with title and information
-(void)setTitle:(NSString *)newTitle andInformation:(NSString *)newInformation{
    self.informationForView=newInformation;
    self.titleOfView=newTitle;
}

//Set text of labels
-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationBar.title=self.titleOfView;
    self.informationTextView.text=self.informationForView;
}

- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setInformationTextView:nil];
    [super viewDidUnload];
}
@end
