//
//  AJBScrabbleSolverViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 29/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBScrabbleSolverViewController.h"

@implementation AJBScrabbleSolverViewController
@synthesize clearButton;
@synthesize dimView;
@synthesize lightView;
@synthesize loadingSpinner;

//In this class, variables and definitions refering to 'word' such as WORD_MARGIN_WIDTH are related to
//the set of text fields that the format of the word on the board

//All those refering to 'hand' such as HAND_MARGIN_WIDTH are related to the letters in the hand of the user

//Definitions regarding text field cell measurments

//Width and height of the cell
#define CELL_WIDTH 30
#define CELL_HEIGHT 30

//Define margin sizes
#define WORD_MARGIN_WIDTH 5
#define WORD_MARGIN_HEIGHT 10
#define HAND_MARGIN_WIDTH 10
#define HAND_MARGIN_HEIGHT 10

//Define the size of the word text field array
#define WORD_HEIGHT 2
#define WORD_WIDTH 8

//X and Y of first box
#define WORD_START_X ((320)-(CELL_WIDTH*WORD_WIDTH+WORD_MARGIN_WIDTH*(WORD_WIDTH-1)))/2 //Centers the boxes horozontally
#define WORD_START_Y 15

//Define the size of the word text field grid
#define HAND_HEIGHT 1
#define HAND_WIDTH 7

//X and Y of first box
#define HAND_START_X ((320)-(CELL_WIDTH*HAND_WIDTH+HAND_MARGIN_WIDTH*(HAND_WIDTH-1)))/2 //Centers the boxes horozontally
#define HAND_START_Y 160


-(void)viewWillAppear:(BOOL)animated{
    //Remove loading view if it exists
    [self stopSpinner];
    
    //If this in not the first time the view has loaded, return (cells already exist)
    if([self.viewHasLoaded isEqualToNumber:@TRUE])return;
    
    //State that the view has loaded
    self.viewHasLoaded=@TRUE;
    
    //Create an array to hold the text fields
    NSMutableArray *textFieldArray=[[NSMutableArray alloc]init];
    
    //Iterate through X axis and Y axis of field grid
    for(int iteratorY=0;iteratorY<WORD_HEIGHT;iteratorY++)
        for(int iteratorX=0;iteratorX<WORD_WIDTH;iteratorX++){
            //Initialize current text field
            UITextField *newTextField=[[UITextField alloc] init];
            
            //Set text field apperence
            newTextField.borderStyle = UITextBorderStyleNone;
            newTextField.backgroundColor=[UIColor clearColor];
            newTextField.font=[UIFont fontWithName:@"Futura-Medium" size:15.0f];
            
            //Make box at it's appropriate location for it's location in the text field grid
            newTextField.frame = CGRectMake(WORD_START_X+iteratorX*(CELL_WIDTH+WORD_MARGIN_WIDTH), WORD_START_Y+iteratorY*(CELL_HEIGHT+WORD_MARGIN_HEIGHT), CELL_WIDTH, CELL_HEIGHT);
            
            //@"\x1a" is the text for an empty cell
            newTextField.text=@"\x1a";
            
            //Configure text field
            newTextField.textAlignment = UITextAlignmentCenter;
            newTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            newTextField.keyboardType=UIKeyboardTypeAlphabet;
            newTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
            newTextField.autocorrectionType=UITextAutocorrectionTypeNo;
            newTextField.userInteractionEnabled=FALSE;
            
            //Add actions for events
            [newTextField addTarget:self action:@selector(wordTextFieldEdited:) forControlEvents:UIControlEventEditingChanged];
            [newTextField addTarget:self action:@selector(returnKeyWasPressedForWord:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            //Add to view
            [self.view addSubview:newTextField];
            
            //Add to array
            [textFieldArray addObject:newTextField];
        }
    
    //Assign new array of cells to wordTextFieldArray
    self.wordInputTextFieldArray=textFieldArray;
    
    //Re-allocate array
    textFieldArray=[[NSMutableArray alloc]init];
    
    //Initialize hand cells like word cells
    for(int iteratorY=0;iteratorY<HAND_HEIGHT;iteratorY++)
        for(int iteratorX=0;iteratorX<HAND_WIDTH;iteratorX++){
            //Initialize current text field
            UITextField *newTextField=[[UITextField alloc] init];
            
            //Set text field apperence
            newTextField.borderStyle = UITextBorderStyleNone;
            newTextField.backgroundColor=[UIColor clearColor];
            newTextField.font=[UIFont fontWithName:@"Futura-Medium" size:15.0f];
            
            //Make box at it's appropriate location for it's location in the text field grid
            newTextField.frame = CGRectMake(HAND_START_X+iteratorX*(CELL_WIDTH+HAND_MARGIN_WIDTH), HAND_START_Y+iteratorY*(CELL_HEIGHT+HAND_MARGIN_HEIGHT), CELL_WIDTH, CELL_HEIGHT);
            
            //@"\x1a" is the text for an empty cell
            newTextField.text=@"\x1a";
            
            //Configure text field
            newTextField.textAlignment = UITextAlignmentCenter;
            newTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            newTextField.keyboardType=UIKeyboardTypeAlphabet;
            newTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
            newTextField.autocorrectionType=UITextAutocorrectionTypeNo;
            newTextField.userInteractionEnabled=FALSE;
            
            //Add actions for events
            [newTextField addTarget:self action:@selector(handTextFieldEdited:) forControlEvents:UIControlEventEditingChanged];
            [newTextField addTarget:self action:@selector(returnKeyWasPressedForHand:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            //Add to view
            [self.view addSubview:newTextField];
            
            //Add to array
            [textFieldArray addObject:newTextField];
        }
    //Assign new array of cells to handInputTextFieldArray
    self.handInputTextFieldArray=textFieldArray;
    
    //Only show the first word text field
    [[self.wordInputTextFieldArray objectAtIndex:0] setBackgroundColor:[UIColor colorWithRed:255.0f/256.0f green:241.0f/256.0f blue:189.0f/256.0f alpha:1.0f]];
    
    [[self.wordInputTextFieldArray objectAtIndex:0] setBorderStyle:UITextBorderStyleRoundedRect];
    [[self.wordInputTextFieldArray objectAtIndex:0] setUserInteractionEnabled:TRUE];
    
    //Only show the first hand text field
    [[self.handInputTextFieldArray objectAtIndex:0] setBackgroundColor:[UIColor colorWithRed:255.0f/256.0f green:241.0f/256.0f blue:189.0f/256.0f alpha:1.0f]];
    [[self.handInputTextFieldArray objectAtIndex:0] setBorderStyle:UITextBorderStyleRoundedRect];
    [[self.handInputTextFieldArray objectAtIndex:0] setUserInteractionEnabled:TRUE];
    
    //Make the first word text field the first responder
    [[self.wordInputTextFieldArray objectAtIndex:0] becomeFirstResponder];
    
}

- (void)wordTextFieldEdited:(UITextField*)sender{
    
    //Stops recursion loop, return if cell is filled with '?' as no editing is required
    if([sender.text isEqualToString:@"\x1a?"])return;
    
    
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
        //Also, accept spaces
        if(![filterNSStringToLowercaseCharacters(nSStringOfCharacter) isEqualToString:nSStringOfCharacter] && ![nSStringOfCharacter isEqualToString:@" "]){
            mutableStringAsCharArray[iterator-1]=0;
            sender.text=[NSString stringWithUTF8String:mutableStringAsCharArray];
            return;
        }
    }
    
    int indexOfSender=0,indexOfNewSender=0;
    
    //Find the index of the sender in wordTextFieldArray
    for(int iterator=0;iterator<WORD_WIDTH*WORD_HEIGHT;iterator++){
        if([self.wordInputTextFieldArray objectAtIndex:iterator]==sender){
            indexOfSender=iterator;
            //indexOfNewSender is the position of the curser after
            //assign it with the current position and edit it
            //as new first responder is set at the end
            indexOfNewSender=indexOfSender;
            break;
        }
    }
    
    //If current cell is empty move to the cell to the left if any
    if([sender.text isEqualToString:@""] && indexOfSender!=0){
        indexOfNewSender=indexOfSender-1;
        sender.text=@"\x1a";
    }
    
    //Set cell to empty if not empty and no cell to left cell exists
    else if([sender.text isEqualToString:@""] && indexOfSender==0){
        sender.text=@"\x1a";
    }
    
    //Move to the cell to the right if it exists and e
    else if (sender.text.length==2 && indexOfSender!=WORD_WIDTH*WORD_HEIGHT-1){
        indexOfNewSender=indexOfSender+1;
    }
    
    //If the cell is not empty
    if (sender.text.length>=2){
        const char *stringAsCharArray=[sender.text UTF8String];
        
        //Get length of string
        int iterator;
        for(iterator=0;stringAsCharArray[iterator]!=0;iterator++)continue;
        
        //Only keep the last character, convert to '?' if ' '
        if(stringAsCharArray[iterator-1]==' ')sender.text=[NSString stringWithFormat:@"\x1a?"];
        
        else{
            NSString* newString=[NSString stringWithFormat:@"\x1a%c",stringAsCharArray[iterator-1]];
            if(![newString isEqualToString:sender.text])sender.text=newString;
        }
        //If the sender is not the last, go to the next box
        if(indexOfSender!=WORD_WIDTH*WORD_HEIGHT-1){
            indexOfNewSender=indexOfSender+1;
        }
    }
    
    //Find the last cell that is not 'empty'
    int lastFullCell=-1;
    for(int iterator=0;iterator<WORD_WIDTH*WORD_HEIGHT;iterator++){
        if(
           !(
             [[[self.wordInputTextFieldArray objectAtIndex:iterator] text] isEqualToString:@""] ||
             [[[self.wordInputTextFieldArray objectAtIndex:iterator] text] isEqualToString:@"\x1a"]
             )
           ){
            lastFullCell=iterator;
        }
    }
    
    //Show all cells before the last full cell and hide all others
    for(int iterator=0;iterator<WORD_WIDTH*WORD_HEIGHT;iterator++){
        //Fetch the field at the current index
        UITextField *field=[self.wordInputTextFieldArray objectAtIndex:iterator];
        
        //Show all cells up to the last filled cell and show the nex cell if that is where the new first responder will be
        if(iterator<=MAX(indexOfNewSender, lastFullCell)){
            field.backgroundColor=[UIColor colorWithRed:255.0f/256.0f green:241.0f/256.0f blue:189.0f/256.0f alpha:1.0f];
            field.borderStyle=UITextBorderStyleRoundedRect;
            field.userInteractionEnabled=TRUE;
        }
        else{
            field.backgroundColor= [UIColor clearColor];
            field.borderStyle=UITextBorderStyleNone;
            field.userInteractionEnabled=FALSE;
        }
    }
    
    //Set new first responder
    [[self.wordInputTextFieldArray objectAtIndex:indexOfNewSender] becomeFirstResponder];
}

- (void)handTextFieldEdited:(UITextField*)sender{
    //Stops recursion loop, return if cell is filled with '?' as no editing is required
    if([sender.text isEqualToString:@"\x1a"])return;
    
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
    
    int indexOfSender=0,indexOfNewSender=0;
    
    //Find the index of the sender in wordTextFieldArray
    for(int iterator=0;iterator<HAND_WIDTH*HAND_HEIGHT;iterator++){
        if([self.handInputTextFieldArray objectAtIndex:iterator]==sender){
            indexOfSender=iterator;
            //indexOfNewSender is the position of the curser after
            //assign it with the current position and edit it
            //as new first responder is set at the end
            indexOfNewSender=indexOfSender;
            break;
        }
    }
    
    //If current cell is empty move to the cell to the left if any
    if([sender.text isEqualToString:@""] && indexOfSender!=0){
        indexOfNewSender=indexOfSender-1;
        sender.text=@"\x1a";
    }
    
    //Set cell to empty if not empty and no cell to left cell exists
    else if([sender.text isEqualToString:@""] && indexOfSender==0){
        sender.text=@"\x1a";
    }
    
    //Move to the cell to the right if it exists and e
    else if (sender.text.length==2 && indexOfSender!=HAND_WIDTH*HAND_HEIGHT-1){
        indexOfNewSender=indexOfSender+1;
    }
    
    //If the cell is not empty
    if (sender.text.length>=2){
        const char *stringAsCharArray=[sender.text UTF8String];
        
        //Get length of string
        int iterator;
        for(iterator=0;stringAsCharArray[iterator]!=0;iterator++)continue;
        
        //Convert ' ' to 'empty'
        if(stringAsCharArray[iterator-1]==' ')sender.text=[NSString stringWithFormat:@"\x1a"];
        //Else leave only last character
        else{
            NSString* newString=[NSString stringWithFormat:@"\x1a%c",stringAsCharArray[iterator-1]];
            if(![newString isEqualToString:sender.text])sender.text=newString;
        }
    }
    
    //Find the last cell that is not 'empty'
    int lastFullCell=-1;
    for(int iterator=0;iterator<HAND_WIDTH*HAND_HEIGHT;iterator++){
        if(
           !(
             [[[self.handInputTextFieldArray objectAtIndex:iterator] text] isEqualToString:@""] ||
             [[[self.handInputTextFieldArray objectAtIndex:iterator] text] isEqualToString:@"\x1a"]
             )
           ){
            lastFullCell=iterator;
        }
    }
    
    //Show all cells before the last full cell and hide all others
    for(int iterator=0;iterator<HAND_WIDTH*HAND_HEIGHT;iterator++){
        //Fetch the field at the current index
        UITextField *field=[self.handInputTextFieldArray objectAtIndex:iterator];
        
        //Show all cells up to the last filled cell and show the nex cell if that is where the new first responder will be
        if(iterator<=MAX(indexOfNewSender, lastFullCell)){
            field.backgroundColor=[UIColor colorWithRed:255.0f/256.0f green:241.0f/256.0f blue:189.0f/256.0f alpha:1.0f];
            field.borderStyle=UITextBorderStyleRoundedRect;
            field.userInteractionEnabled=TRUE;
        }
        else{
            field.backgroundColor= [UIColor clearColor];
            field.borderStyle=UITextBorderStyleNone;
            field.userInteractionEnabled=FALSE;
        }
    }
    
    //Set new first responder
    [[self.handInputTextFieldArray objectAtIndex:indexOfNewSender] becomeFirstResponder];
}


//Essentially resests the view
- (IBAction)clearButtonPressed:(id)sender{
    
    //Iterate through wordInputTextFieldArray
    for(UITextField * currentField in self.wordInputTextFieldArray){
        //Make cell invisible and empty
        currentField.backgroundColor= [UIColor clearColor];
        currentField.borderStyle=UITextBorderStyleNone;
        currentField.userInteractionEnabled=FALSE;
        currentField.text=@"\x1a";
    }
    
    //Iterate through handInputTextFieldArray
    for(UITextField * currentField in self.handInputTextFieldArray){
        //Make cell invisible and empty
        currentField.backgroundColor= [UIColor clearColor];
        currentField.borderStyle=UITextBorderStyleNone;
        currentField.userInteractionEnabled=FALSE;
        currentField.text=@"\x1a";
    }
    
    //Show first cell of word
    [[self.wordInputTextFieldArray objectAtIndex:0] setBackgroundColor:[UIColor colorWithRed:255.0f/256.0f green:241.0f/256.0f blue:189.0f/256.0f alpha:1.0f]];
    [[self.wordInputTextFieldArray objectAtIndex:0] setBorderStyle:UITextBorderStyleRoundedRect];
    [[self.wordInputTextFieldArray objectAtIndex:0] setUserInteractionEnabled:TRUE];
    
    //Show first cell of hand
    [[self.handInputTextFieldArray objectAtIndex:0] setBackgroundColor:[UIColor colorWithRed:255.0f/256.0f green:241.0f/256.0f blue:189.0f/256.0f alpha:1.0f]];
    [[self.handInputTextFieldArray objectAtIndex:0] setBorderStyle:UITextBorderStyleRoundedRect];
    [[self.handInputTextFieldArray objectAtIndex:0] setUserInteractionEnabled:TRUE];
    
    //Make first cell of the word grid responder
    [[self.wordInputTextFieldArray objectAtIndex:0] becomeFirstResponder];
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


//Return key pressed while editing word
- (IBAction)returnKeyWasPressedForWord:(id)sender {
    //Go to the first cell of the hand grid
    [[self.handInputTextFieldArray objectAtIndex:0] becomeFirstResponder];
}

//Return key pressed while editing hand
- (IBAction)returnKeyWasPressedForHand:(id)sender {
    //Solve the puzzle
    [self performSegueWithIdentifier:@"solveScrabbleSegue" sender:sender];
}

-(IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //If segue to solutions, generate answers, sort them and pass them as a detail item
    if([segue.identifier isEqualToString:@"solveScrabbleSegue"]){
        
        //Start spinner in new thread, must be done otherwise the view does not refresh
        [self performSelectorInBackground:@selector(startSpinner) withObject:nil];
        
        //Fetch dictionary
        AJBDictionary *dictionary=self.dictionary;
        
        //Iterate through all of the word boxes and extract a string from the letters
        NSString *scrabble=@"";
        for(int iterator=0;iterator<WORD_WIDTH*WORD_HEIGHT;iterator++){
            const char * currentFieldCharacterArray=[[[self.wordInputTextFieldArray objectAtIndex:iterator] text] UTF8String];
            int iteratorTwo;
            for(iteratorTwo=0;currentFieldCharacterArray[iteratorTwo+1]!=0;iteratorTwo++)continue;
            NSString * currentCharacter=[NSString stringWithFormat:@"%c", currentFieldCharacterArray[iteratorTwo]];
            if([currentCharacter isEqualToString:@""] || [currentCharacter isEqualToString:@"\x1a"])
                scrabble=[NSString stringWithFormat:@"%@.",scrabble];
            else
                scrabble=[NSString stringWithFormat:@"%@%@",scrabble,currentCharacter];
        }
        //Ensure that empty spaces at the end of the string are removed
        const char *scrabbleAsString=[scrabble UTF8String];
        char scrabbleAsCharArray[MAX_STRING_SIZE];
        int stringLength=[scrabble length];
        for(int iterator=0;scrabbleAsString[iterator]!=0;iterator++)scrabbleAsCharArray[iterator]=scrabbleAsString[iterator];
        scrabbleAsCharArray[stringLength]=0;
        int lastLetter=-1;
        
        //Locate the last letter of the string
        for(int iterator=0;scrabbleAsCharArray[iterator]!=0;iterator++){
            if(scrabbleAsCharArray[iterator]!='.')lastLetter=iterator;
        }
        
        //Make the string end after that
        scrabbleAsCharArray[lastLetter+1]=0;
        
        //Convert '?' to '.' for puzzle solver format
        for(int iterator=0;scrabbleAsCharArray[iterator]!=0;iterator++)if(scrabbleAsCharArray[iterator]=='?')scrabbleAsCharArray[iterator]='.';
        scrabble=[NSString stringWithFormat:@"%s", scrabbleAsCharArray];
        
        
        //Merge the hand into a single string
        NSString *hand=@"";
        for(int iterator=0;iterator<HAND_WIDTH*HAND_HEIGHT;iterator++){
            const char * currentFieldCharacterArray=[[[self.handInputTextFieldArray objectAtIndex:iterator] text] UTF8String];
            int iteratorTwo;
            for(iteratorTwo=0;currentFieldCharacterArray[iteratorTwo+1]!=0;iteratorTwo++)continue;
            NSString * currentCharacter=[NSString stringWithFormat:@"%c", currentFieldCharacterArray[iteratorTwo]];
            if(!([currentCharacter isEqualToString:@""] || [currentCharacter isEqualToString:@"\x1a"]))
                hand=[NSString stringWithFormat:@"%@%@",hand,currentCharacter];
        }
        
        //Initilize and solve puzzle
        AJBScrabble *currentScrabble=[[AJBScrabble alloc]initWithWord:filterNSStringToLowercaseCharactersAndSpecialCharacters(scrabble) andHand:filterNSStringToLowercaseCharacters(hand) andDictionary:dictionary];
        
        //Sort the solutions
        NSArray *sortedArray;
        sortedArray = [[currentScrabble findWords] sortedArrayUsingComparator:^NSComparisonResult(AJBWord* firstWord, AJBWord* secondWord){
            return [firstWord.word compare:secondWord.word];
        }];
        
        //Set the detail item of destination view controller
        AJBSolutionsViewController *solutionsViewController = segue.destinationViewController;
        [solutionsViewController setDetailItem:[[NSMutableArray alloc]initWithArray:sortedArray]];
    }
    //If segue to help, pass title and information
    else if([segue.identifier isEqualToString:@"scrabbleHelpSegue"]){
        AJBPuzzleHelpViewController *helpViewController=segue.destinationViewController;
        [helpViewController setTitle:@"Scrabble Solver Help" andInformation:@"This puzzle solver will find words that can be formed with the tiles on the board in a specific spot and the tiles in your hand.\n\nType in the letters of the word that you know into the top set of tiles and fill in the blank letters which are in the word with spaces, which will automatically be replaced with a \"?\".\n\nFor example; if you know that the word starts with the letter \"A\" and is four letters long, type \"A\" and then press space three times.\n\nPress return to move the curser to the tiles of the hand.\n\nTo generate a list of words which the answer could be, press the return key while the curser is in the hand section of the screen or tap the \"Solve\" button.\n\nTo clear the view, tap the \"Clear\" button. "];
    }
}
@end
