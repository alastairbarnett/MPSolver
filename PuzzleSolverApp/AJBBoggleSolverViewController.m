//
//  AJBBoggleSolverViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 22/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBBoggleSolverViewController.h"


@interface AJBBoggleSolverViewController ()

@end

@implementation AJBBoggleSolverViewController
@synthesize solveButton;
@synthesize clearButton;

//Definitions regarding text field cell measurments
#define CELL_WIDTH 30
#define CELL_HEIGHT 30
#define MARGIN_WIDTH 10
#define MARGIN_HEIGHT 10


//X and Y of first box
#define START_X ((320-92)-(CELL_WIDTH*4+MARGIN_WIDTH*3))/2 //Centers the boxes horozontally
#define START_Y 15


-(void)viewWillAppear:(BOOL)animated{
    //Remove loading view if it exists
    [self stopSpinner];
    
    
    //If this in not the first time the view has loaded, return (cells already exist)
    if([self.viewHasLoaded isEqualToNumber:@TRUE])return;
    
    //State that view has loaded
    self.viewHasLoaded=@TRUE;
    
    
    //Create an array to hold the text fields
    NSMutableArray *textFieldArray=[[NSMutableArray alloc]init];
    
    //Iterate through X axis and Y axis of field grid
    for(int iteratorY=0;iteratorY<BOGGLE_SIZE;iteratorY++)
        for(int iteratorX=0;iteratorX<BOGGLE_SIZE;iteratorX++){
            
            //Initialize current text field
            UITextField *newTextField=[[UITextField alloc] init];
            
            //Set image of cell, font and text color
            newTextField.background=[UIImage imageNamed:@"bigRedCellImage.png"];
            newTextField.textColor=[UIColor colorWithRed:248.0f/256.0f green:252.0f/256.0f blue:3.0f/256.0f alpha:1.0f];
            newTextField.font=[UIFont fontWithName:@"Futura-Medium" size:17.0f];
            
            //Make box at it's appropriate location for it's location in the text field grid
            newTextField.frame = CGRectMake(START_X+iteratorX*(CELL_WIDTH+MARGIN_WIDTH), START_Y+iteratorY*(CELL_HEIGHT+MARGIN_HEIGHT), CELL_WIDTH, CELL_HEIGHT);
            
            //Configure text field
            newTextField.textAlignment = UITextAlignmentCenter;
            newTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            newTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
            newTextField.autocorrectionType=UITextAutocorrectionTypeNo;
            
            //@"\x1a" is the text for an empty cell
            newTextField.text=@"\x1a";
            
            //Add actions for events
            [newTextField addTarget:self action:@selector(textFieldEdited:) forControlEvents:UIControlEventEditingChanged];
            [newTextField addTarget:self action:@selector(segueShouldOccur:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            //Add to view
            [self.view addSubview:newTextField];
            
            //Add to array
            [textFieldArray addObject:newTextField];
        }
    //Assign new array of cells to inputTextFieldArray
    self.inputTextFieldArray=textFieldArray;
    
    //Make first cell first responder
    [[self.inputTextFieldArray objectAtIndex:0] becomeFirstResponder];
}

- (void)textFieldEdited:(UITextField*)sender{
    //If the length of the string is not empty (has 'empty' character and another character), trim the text
    if(sender.text.length>=2){
        const char *stringAsCharArray=[[sender.text lowercaseString] UTF8String];
        char mutableStringAsCharArray[MAX_STRING_SIZE];
        int iterator;
        for(iterator=0;stringAsCharArray[iterator]!=0;iterator++)mutableStringAsCharArray[iterator]=stringAsCharArray[iterator];
        mutableStringAsCharArray[iterator]=0;
        
        //Get last character in the string
        NSString *nSStringOfCharacter=[NSString stringWithFormat:@"%c",stringAsCharArray[iterator-1]];
        
        //Filter the string, if that changes it then delete the letter because it is non alphabetic
        //case is irrelevent because the string used for comparisons was converted to lowercase
        if(![filterNSStringToLowercaseCharacters(nSStringOfCharacter) isEqualToString:nSStringOfCharacter]){
            mutableStringAsCharArray[iterator-1]=0;
            sender.text=[NSString stringWithUTF8String:mutableStringAsCharArray];
            return;
        }
    }
    
    //Find the index in the inputTextFieldArray of the sender text field
    int indexOfSender=0;
    for(int iterator=0;iterator<BOGGLE_SIZE*BOGGLE_SIZE;iterator++){
        if([self.inputTextFieldArray objectAtIndex:iterator]==sender){
            indexOfSender=iterator;
            break;
        }
    }
    
    //If string is completely empty and this is not the first cell, go the the previous cell (if any) and set the original cell to @"\x1a" (empty)
    if([sender.text isEqualToString:@""] && indexOfSender!=0){
        [[self.inputTextFieldArray objectAtIndex:indexOfSender-1]becomeFirstResponder];
        sender.text=@"\x1a";
    }
    
    //If sender is the first cell and is completely empty, reset it to @"\x1a" (empty)
    else if([sender.text isEqualToString:@""] && indexOfSender==0){
        sender.text=@"\x1a";
    }
    
    //If cell is full and the next cell exists, move to it
    else if (sender.text.length==2 && indexOfSender!=BOGGLE_SIZE*BOGGLE_SIZE-1){
        [[self.inputTextFieldArray objectAtIndex:indexOfSender+1]becomeFirstResponder];
    }
    
    //If the cell is not empty
    if (sender.text.length>=2){
        const char *stringAsCharArray=[sender.text UTF8String];
        
        //Get length of the string
        int iterator;
        for(iterator=0;stringAsCharArray[iterator]!=0;iterator++)continue;
        
        //Only keep the last character 
        NSString* newString=[NSString stringWithFormat:@"\x1a%c",stringAsCharArray[iterator-1]];
        if(![newString isEqualToString:sender.text])sender.text=newString;
        
        //If the sender is not the last, go to the next box
        if(indexOfSender!=BOGGLE_SIZE*BOGGLE_SIZE-1)
            [[self.inputTextFieldArray objectAtIndex:indexOfSender+1]becomeFirstResponder];
    }
}


//Clear the view by assigning all cells with the default value and then making the first cell become the first responder
- (IBAction)clearButtonPressed:(id)sender{
    for(UITextField * currentField in self.inputTextFieldArray){
        currentField.text=@"\x1a";
    }
    [[self.inputTextFieldArray objectAtIndex:0] becomeFirstResponder];
}

//Check if a segue can occur (i.e. if all cells are full)
-(IBAction)segueShouldOccur:(id)sender{
    //Assume segue can occur
    BOOL letSegueOccur=TRUE;
    
    //Iterate through text boxes and test if there are any which are empty
    for(int iterator=0;iterator<BOGGLE_SIZE*BOGGLE_SIZE;iterator++){
        NSString *currentCellText=[[self.inputTextFieldArray objectAtIndex:iterator] text];
        //If trimmed string is empty, the cell is empty
        if([filterNSStringToLowercaseCharacters(currentCellText) isEqualToString:@""]){
            //Do not do the segue
            letSegueOccur=FALSE;
            break;
        }
    }
    
    //Do segue if test is passed, else display alert box 
    if(letSegueOccur){
        //Do segue
        [self performSegueWithIdentifier:@"solveBoggleSegue" sender:sender];
    }
    else{
        //Display an alert view to inform the user that there are empty cells that must be filled
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All Cells Must Be Filled"
                                                        message:@"One or more of the cells are not filled in. It is required that all cells are filled in."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        //If the action was triggered from a text field then set currentFirstResponder
        //this is done so that when the alert view is closed the text field that was being edited is returned to
        if([sender isMemberOfClass:NSClassFromString(@"UITextField")]){
            UITextField *senderTextField=sender;
            self.currentFirstResponder=senderTextField;
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //Return to the cell that was being edited
    [self.currentFirstResponder becomeFirstResponder];
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

-(IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //If segue to solutions, generate answers, sort them and pass them as a detail item
    if([segue.identifier isEqualToString:@"solveBoggleSegue"]){
        
        //Start spinner in new thread, must be done otherwise the view does not refresh
        [self performSelectorInBackground:@selector(startSpinner) withObject:nil];
        
        //Fetch dictionary
        AJBDictionary *dictionary=self.dictionary;
        
        //Iterate through all of the boxes and extract a string from the letters
        NSString *boggleBoard=@"";
        for(int iterator=0;iterator<BOGGLE_SIZE*BOGGLE_SIZE;iterator++){
            const char * currentFieldCharacterArray=[[[self.inputTextFieldArray objectAtIndex:iterator] text] UTF8String];
            int iteratorTwo;
            for(iteratorTwo=0;currentFieldCharacterArray[iteratorTwo+1]!=0;iteratorTwo++)continue;
            NSString * currentCharacter=[NSString stringWithFormat:@"%c", currentFieldCharacterArray[iteratorTwo]];
            boggleBoard=[NSString stringWithFormat:@"%@%@",boggleBoard,currentCharacter];
        }
        
        //Filter the string to lowercase
        NSString *newBoggleBoard=filterNSStringToLowercaseCharacters(boggleBoard);
        
        //Initialize new boggle board
        AJBBoggle *currentBoggle=[[AJBBoggle alloc]initWithBoard:newBoggleBoard andDictionary:dictionary];
        
        //Declare view controller pointer
        AJBSolutionsViewController *solutionsViewController = segue.destinationViewController;
        
        
        //Find and sort solutions
        NSArray *sortedArray;
        sortedArray = [[currentBoggle searchForWords] sortedArrayUsingComparator:^NSComparisonResult(AJBWord* firstWord, AJBWord* secondWord){
            return [[NSNumber numberWithInteger:secondWord.word.length] compare:[NSNumber numberWithInteger:firstWord.word.length]];
        }];
        
        //Send sorted solutions as detail item to destination view controller
        [solutionsViewController setDetailItem:[[NSMutableArray alloc]initWithArray:sortedArray]];
    }
    
    //If segue to help, pass title and information to destination view controller
    else if([segue.identifier isEqualToString:@"boggleHelpSegue"]){
        AJBPuzzleHelpViewController *helpViewController=segue.destinationViewController;
        [helpViewController setTitle:@"Boggle Solver Help" andInformation:@"Type the letters of the boggle puzzle that you want to find words for into the grid.\n\nThe boxes are case insensitive and will only accept alphabetic characters, all symbols and digits will be ignored.\n\nAll boxes must be filled before attempting to solve the puzzle.\n\nTo generate solutions to the puzzle press the return key or tap the \"Solve\" button. To clear the view, tap the \"Clear\" button."];
    }
}

@end
