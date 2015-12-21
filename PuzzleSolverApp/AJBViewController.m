//
//  AJBViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 15/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBViewController.h"

@interface AJBViewController ()

@end

@implementation AJBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(IBAction)settingsButtonPressed:(id)sender{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
