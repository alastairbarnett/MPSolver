//
//  AJBCustomDictionaryDetailViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 6/11/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBCustomDictionaryDetailViewController.h"

@implementation AJBCustomDictionaryDetailViewController


//Initialize the view controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.wordTextField becomeFirstResponder];
    self.managedObjectContext = [(AJBAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.wordTextField.text=self.word.word;
    self.definitionTextField.text=self.word.definition;

}

//Text field has been edited
-(IBAction)dataWasChanged:(UITextField *)sender{
    
    //Trim string (do not edit unless required to avoid recursion loop)
    if(![filterNSStringToLowercaseCharacters(sender.text) isEqualToString:sender.text] && sender==self.wordTextField)sender.text=filterNSStringToLowercaseCharacters(sender.text);
    
    //Counter-Troll 1.6
    //I'm gonna camp
    if(self.wordTextField.text.length>=MAX_STRING_SIZE){
        //Oh Boy...
        const char *textAsCharArray=[self.wordTextField.text UTF8String]+self.wordTextField.text.length-MAX_STRING_SIZE+1;
        //The're taking the bomb to B
        //*Gunshots*
        self.wordTextField.text=[NSString stringWithCString:textAsCharArray encoding:NSUTF8StringEncoding];
    }
    //Counter-Trolls Win
    
    //Create a new word object to compute the anagram of the word
    AJBWord * newWordObject=[[AJBWord alloc]initWithWord:self.wordTextField.text andDefinition:self.definitionTextField.text];
    
    //Save the new word as an AJBDiskSavedWord 
    self.word.word=newWordObject.word;
    self.word.definition=newWordObject.definition;
    self.word.anagram=newWordObject.anagram;
    
    //Save Core Data
    NSError *error=nil;
    [self.managedObjectContext save:&error];
    
}

//Handle the user pressing return for intuitive effect

//If pressed while editing word, let definition text box become first responder
- (IBAction)returnKeyWasPressedForWord:(id)sender{
    [self.definitionTextField becomeFirstResponder];
}

//If definition is being edited, return to table view
- (IBAction)returnKeyWasPressedForDefinition:(id)sender {
    //Table view is on layer one of storyboard
    UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:previousViewController animated:YES];
}

- (void)viewDidUnload {
    [self setWordTextField:nil];
    [self setDefinitionTextField:nil];
    [super viewDidUnload];
}
@end
