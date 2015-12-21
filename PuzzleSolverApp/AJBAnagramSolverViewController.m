//
//  AJBAnagramSolverViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 17/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBAnagramSolverViewController.h"

@interface AJBAnagramSolverViewController ()

@end

@implementation AJBAnagramSolverViewController
@synthesize anagramSolverTextBox;
@synthesize anagramSolverButton;

-(IBAction)textFieldEdited:(UITextField*)sender{
    
    //Trim the text field of everything but letters and make them lowercase (only call if required to avoid recursion loop)
    if(![filterNSStringToLowercaseCharacters(sender.text) isEqualToString:sender.text])sender.text=filterNSStringToLowercaseCharacters(sender.text);
    
    //Counter-Troll 1.6
    //I'm gonna camp
    if(sender.text.length>=MAX_STRING_SIZE){
        //Oh Boy...
        const char *textAsCharArray=[sender.text UTF8String]+sender.text.length-MAX_STRING_SIZE+1;
        //The're taking the bomb to B
        //*Gunshots*
        sender.text=[NSString stringWithCString:textAsCharArray encoding:NSUTF8StringEncoding];
    }
    //Counter-Trolls Win
}

-(void)viewWillAppear:(BOOL)animated{
    //If loading screen was apparent before, remove it
    [self stopSpinner];
    
    //Start with curser in text field
    [anagramSolverTextBox becomeFirstResponder];
}

-(void)startSpinner{
    //Create view
    
    //Create transparent black layer to give dim effect
    self.dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.dimView.backgroundColor = [UIColor blackColor];
    self.dimView.alpha = 0.5f;
    self.dimView.userInteractionEnabled = NO;
    [self.view addSubview:self.dimView];
    
    //Create a circular view in the centre of the screen with puzzle background 
    self.lightView = [[UIImageView alloc] initWithFrame:CGRectMake((320-80)/2, ((416/2)-80)/2, 80, 80)];
    [self.lightView.layer setCornerRadius:40.0f];
    [self.lightView.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.lightView.layer setBorderWidth:1.5f];
    [self.lightView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.lightView.layer setShadowOpacity:0.8];
    [self.lightView.layer setShadowRadius:3.0];
    [self.lightView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    self.lightView.backgroundColor=[UIColor clearColor];
    self.lightView.image = [UIImage imageNamed:@"circularPuzzleImage.png"];
    self.lightView.userInteractionEnabled = NO;
    [self.view addSubview:self.lightView];
    
    //Create activity indicator view as spinning
    self.loadingSpinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingSpinner.frame=CGRectMake(20, 20, 40, 40);
    self.loadingSpinner.color = [UIColor blackColor];
    [self.loadingSpinner setHidden:FALSE];
    [self.loadingSpinner startAnimating];
    [self.lightView addSubview:self.loadingSpinner];
    [self.lightView bringSubviewToFront:self.loadingSpinner];
}


-(void)stopSpinner{
    //Stop spinner
    [self.loadingSpinner stopAnimating];
    
    //Remove views from Superview
    [self.loadingSpinner removeFromSuperview];
    [self.dimView removeFromSuperview];
    [self.lightView removeFromSuperview];
}

//Generate results if enter is pressed
- (IBAction)returnKeyWasPressed:(id)sender {
    [self performSegueWithIdentifier:@"solveAnagramSegue" sender:sender];
}


-(IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //If solving puzzle, initialize puzzle solver class, solve puzzle, sort results and pass results
    //Else, If help view is being called, initiate the title and information
    if([segue.identifier isEqualToString:@"solveAnagramSegue"]){
        
        //Start spinner in new thread, must be done otherwise the view does not refresh
        [self performSelectorInBackground:@selector(startSpinner) withObject:nil];
        
        AJBDictionary *dictionary=self.dictionary;
        AJBSolutionsViewController *solutionsViewController = segue.destinationViewController;
        
        //Find the anagrams of the word (if any)
        AJBAnagram * currentAnagram=[[AJBAnagram alloc]initWithWord:filterNSStringToLowercaseCharacters(self.anagramSolverTextBox.text) andDictionary:dictionary];
        
        //Generate and sort the results list
        NSArray *sortedArray;
        sortedArray = [[currentAnagram findAnagrams] sortedArrayUsingComparator:^NSComparisonResult(AJBWord* firstWord, AJBWord* secondWord){
            return [firstWord.word compare:secondWord.word];
        }];
        
        //Set results as detail item
        [solutionsViewController setDetailItem:[[NSMutableArray alloc]initWithArray:sortedArray]];
    }
    else if([segue.identifier isEqualToString:@"anagramHelpSegue"]){
    
        //Initialize title and information about the anagram solver
        AJBPuzzleHelpViewController *helpViewController=segue.destinationViewController;
        [helpViewController setTitle:@"Anagram Solver Help" andInformation:@"Type the anagram into the text field and press return or \"Find Anagrams\" to find anagrams."];
    }
}

@end
