//
//  AJBPuzzleHelpViewController.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 11/11/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJBPuzzleHelpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UITextView *informationTextView;
@property (nonatomic, retain) NSString *titleOfView;
@property (nonatomic, retain) NSString *informationForView;
-(void)setTitle:(NSString *)newTitle andInformation:(NSString *)newInformation;
@end
