//
//  AJBHomeViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 30/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBHomeViewController.h"

@implementation AJBHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    //Hide navigation bar to show full background image
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Build a dictionary as this view is essentially the root view controller
    
    //Declare AJBDictionary
    self.dictionary=[[AJBDictionary alloc]init];
    
    //Read in word list file as string
    NSStringEncoding encoding = NSUTF8StringEncoding;
    NSError * error=nil;
    NSString *fileAsString=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Wordlist" ofType:@"txt"] encoding:encoding error:&error];
    
    //Split the word list by newline
    NSArray *listOfWords = [fileAsString componentsSeparatedByString:@"\n"];
    
    //Iterate through words and add them to the dictionary
    for(int iterator=0;iterator<listOfWords.count;iterator++){
        //Get the word
        NSString * currentWord = [listOfWords objectAtIndex:iterator];
        
        //Increment iterator and get anagram
        iterator++;
        NSString * currentAnagram = [listOfWords objectAtIndex:iterator];
        
        //Add the word to the dictionary with the precomputed anagram as base words
        [self.dictionary addWord:currentWord withDefinition:@"" andAnagram:currentAnagram asBaseWord:YES];
    }
    
    
    //Fetch the managed object context to access core data
    self.managedObjectContext = [(AJBAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    //Fetch the AJBStoredWord objects from Core Data
    NSEntityDescription *wordEntityDescription = [NSEntityDescription entityForName:@"AJBDiskStoredWord" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *wordFetchRequest = [[NSFetchRequest alloc] init];
    [wordFetchRequest setEntity:wordEntityDescription];
    NSArray *newCustomWordsArray = [self.managedObjectContext executeFetchRequest:wordFetchRequest error:&error];
    
    //Iterate through these objects and add them to the dictionary
    for(AJBDiskStoredWord * iterator in newCustomWordsArray){
        [self.dictionary addWord:iterator.word withDefinition:iterator.definition andAnagram:iterator.anagram asBaseWord:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender{
    //Find the name of the segue and use that to identify the destination view controller class
    //then set it's dictionary to the class's dictionary
    if([segue.identifier isEqualToString:@"homeToPuzzleSolverMenuSegue"]){
        AJBPuzzleSolversViewController *puzzleSolversViewController = segue.destinationViewController;
        puzzleSolversViewController.dictionary=self.dictionary;
    }
    else if([segue.identifier isEqualToString:@"homeToCustomDictionarySegue"]){
        AJBCustomDictionaryViewController *customDictionaryViewController = segue.destinationViewController;
        customDictionaryViewController.dictionary=self.dictionary;
    }
}

@end
