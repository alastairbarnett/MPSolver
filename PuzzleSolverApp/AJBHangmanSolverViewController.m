//
//  AJBHangmanSolverViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 24/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBHangmanSolverViewController.h"

@implementation AJBHangmanSolverViewController
@synthesize clearButton;
@synthesize guessLabel;
@synthesize guessedLettersField;
@synthesize findGuessButton;
@synthesize dimView;
@synthesize lightView;
@synthesize loadingSpinner;

//Definitions regarding text field cell measurments
#define CELL_WIDTH 30
#define CELL_HEIGHT 30
#define MARGIN_WIDTH 5
#define MARGIN_HEIGHT 10

//Define number of cells
#define HEIGHT 2
#define WIDTH 8

//X and Y of first box
#define START_X ((320)-(CELL_WIDTH*WIDTH+MARGIN_WIDTH*(WIDTH-1)))/2 //Centers the boxes horozontally
#define START_Y 15

-(void)viewWillAppear:(BOOL)animated{
    
    //Remove loading view if it exists
    [self stopSpinner];
    
    //If this in not the first time the view has loaded, return (cells already exist)
    if([self.viewHasLoaded isEqualToNumber:@TRUE])return;
    
    //State that view has loaded
    self.viewHasLoaded=@TRUE;
    
    //Set the guessed
    self.guessedLettersField.backgroundColor=[UIColor colorWithRed:163.0f/256.0f green:102.0f/256.0f blue:73.0f/256.0f alpha:1.0f];
        
    //Create an array to hold the text fields
    NSMutableArray *textFieldArray=[[NSMutableArray alloc]init];
    
    //Iterate through X axis and Y axis of field grid
    for(int iteratorY=0;iteratorY<HEIGHT;iteratorY++)
        for(int iteratorX=0;iteratorX<WIDTH;iteratorX++){
            
            //Initialize current text field
            UITextField *newTextField=[[UITextField alloc] init];
            
            //Configure text field apperence
            newTextField.borderStyle = UITextBorderStyleRoundedRect;
            newTextField.backgroundColor=[UIColor colorWithRed:163.0f/256.0f green:102.0f/256.0f blue:73.0f/256.0f alpha:1.0f];
            newTextField.textColor=[UIColor whiteColor];
            newTextField.font=[UIFont fontWithName:@"Futura-Medium" size:16.0];

            //Make box at it's appropriate location for it's location in the text field grid
            newTextField.frame = CGRectMake(START_X+iteratorX*(CELL_WIDTH+MARGIN_WIDTH), START_Y+iteratorY*(CELL_HEIGHT+MARGIN_HEIGHT), CELL_WIDTH, CELL_HEIGHT);
            
            //Configure text field
            newTextField.textAlignment = UITextAlignmentCenter;
            newTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            newTextField.keyboardType=UIKeyboardTypeAlphabet;
            newTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
            newTextField.autocorrectionType=UITextAutocorrectionTypeNo;
            
            //@"\x1a" is the text for an empty cell
            newTextField.text=@"\x1a";
            
            //Add actions for events
            [newTextField addTarget:self action:@selector(textFieldEdited:) forControlEvents:UIControlEventEditingChanged];
            [newTextField addTarget:self action:@selector(returnKeyWasPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
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
    //Data may have changed, making the current results
    //potentially invalid so they must be converted back
    //to an 'unknown' state
    self.guessLabel.text=@"?";
    
    
    //If cell contains only 'unknown character', return (fixes recursion loop)
    if([sender.text isEqualToString:@"\x1a_"])return;
    
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
    
    //Find the index in the inputTextFieldArray of the sender text field
    int indexOfSender=0;
    for(int iterator=0;iterator<WIDTH*HEIGHT;iterator++){
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
    else if (sender.text.length==2 && indexOfSender!=WIDTH*HEIGHT-1){
        [[self.inputTextFieldArray objectAtIndex:indexOfSender+1]becomeFirstResponder];
    }
    
    //If the cell is not empty
    if (sender.text.length>=2){
        const char *stringAsCharArray=[sender.text UTF8String];
        
        //Get length of the string
        int iterator;
        for(iterator=0;stringAsCharArray[iterator]!=0;iterator++)continue;
        
        //Only keep the last character, convert to '?' if ' '
        if(stringAsCharArray[iterator-1]==' '){
            sender.text=@"\x1a_";
        }
        else{
            NSString* newString=[NSString stringWithFormat:@"\x1a%c",stringAsCharArray[iterator-1]];
            if(![newString isEqualToString:sender.text])sender.text=newString;
        }
        
        //If the sender is not the last, go to the next box
        if(indexOfSender!=WIDTH*HEIGHT-1)
            [[self.inputTextFieldArray objectAtIndex:indexOfSender+1]becomeFirstResponder];
    }
}

-(IBAction)letterFieldEdited:(id)sender{
    //Data may have changed, making the current results
    //potentially invalid so they must be converted back
    //to an 'unknown' state
    self.guessLabel.text=@"?";
    
    //If non alphabetic characters are in the string, remove them and return
    //Also, convert uppercase to lowercase
    if(![filterNSStringToLowercaseCharacters(self.guessedLettersField.text) isEqualToString:self.guessedLettersField.text]){
        self.guessedLettersField.text=filterNSStringToLowercaseCharacters(self.guessedLettersField.text);
        return;
    }
    
    //Declare and initialize primative variables
    const char *wordAsCharacters=[[self.guessedLettersField.text lowercaseString] UTF8String];
    char characterArrayToReturn[MAX_STRING_SIZE];
    memset(characterArrayToReturn , 0 , sizeof(characterArrayToReturn));
    bool letterIsInField[CHARACTER_SET_COUNT];
    memset(letterIsInField , 0 , sizeof(letterIsInField));
    
    
    //Test if the string is strictly increasing (i.e. each letter is larger than the last)
    //If it is, no modification is required and the function returns
    //This fixes a recursion loop
    bool isStrictlyIncreasing=TRUE;
    int iterator;
    for(iterator=0;wordAsCharacters[iterator+1]!=0;iterator++){
        //If next letter is lower than or equal to last letter fail test and break
        if(wordAsCharacters[iterator+1]<=wordAsCharacters[iterator]){
            isStrictlyIncreasing=FALSE;
            break;
        };
    }
    //Only return if the field is strictly increasing or of length one (string of length 1 must be strictly increasing)
    if(isStrictlyIncreasing || self.guessedLettersField.text.length==1)return;
    
    //Iterate through all letters in the field and indicate that that letter
    //is in the field. 
    for(int iterator=0; wordAsCharacters[iterator]!=0; iterator++){
        int positionInArrayOfCurrentCharacter=(int)wordAsCharacters[iterator]-'a';
        letterIsInField[positionInArrayOfCurrentCharacter]=TRUE;
    }
    int lengthOfStringToReturn=0;
    
    //For all letters, add them to the end of the string to put in the text field.
    for(int iterator=0 ; iterator<CHARACTER_SET_COUNT ; iterator++){
        if(letterIsInField[iterator]){
            characterArrayToReturn[lengthOfStringToReturn]=(char)iterator+'a';
            lengthOfStringToReturn++;
        }
    }
    //Terminate string with null character
    characterArrayToReturn[lengthOfStringToReturn+1]=0;
    
    //Assign the stirng to the text field text
    self.guessedLettersField.text=[NSString stringWithFormat:@"%s",characterArrayToReturn];
}


- (IBAction)clearButtonPressed:(id)sender{
    //Set the text of all cells to (empty)
    for(UITextField * currentField in self.inputTextFieldArray){
        currentField.text=@"\x1a";
    }
    
    //Empty guessed letters field
    self.guessedLettersField.text=@"";
    
    //Reset guess label to default
    self.guessLabel.text=@"?";
    
    //Make the first cell the first responder
    [[self.inputTextFieldArray objectAtIndex:0] becomeFirstResponder];
}

- (IBAction)returnKeyWasPressed:(id)sender {
    //Generate and show solutions when return key pressed
    [self performSegueWithIdentifier:@"solveHangmanSegue" sender:sender];
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

-(IBAction)findGuessButtonPressed:(id)sender{
    
    //Start the spinner in a new thread
    [self performSelectorInBackground:@selector(startSpinner) withObject:nil];
    
    //Fetch dictionary
    AJBDictionary *dictionary=self.dictionary;
    
    
    NSString *hangman=@"";
    
    //Iterate through the cells and append their values to the string
    for(int iterator=0;iterator<WIDTH*HEIGHT;iterator++){
        const char * currentFieldCharacterArray=[[[self.inputTextFieldArray objectAtIndex:iterator] text] UTF8String];
        int iteratorTwo;
        for(iteratorTwo=0;currentFieldCharacterArray[iteratorTwo+1]!=0;iteratorTwo++)continue;
        NSString * currentCharacter=[NSString stringWithFormat:@"%c", currentFieldCharacterArray[iteratorTwo]];
        
        //If empty, add blank char
        if([currentCharacter isEqualToString:@""] || [currentCharacter isEqualToString:@"\x1a"])
            hangman=[NSString stringWithFormat:@"%@.",hangman];
        //If not empty, add the character in the field to the string
        else
            hangman=[NSString stringWithFormat:@"%@%@",hangman,currentCharacter];
    }
    
    const char *hangmanAsString=[hangman UTF8String];
    char hangmanAsCharArray[MAX_STRING_SIZE];
    int stringLength=[hangman length];
    
    //Copy string to char array to edit it
    for(int iterator=0;hangmanAsString[iterator]!=0;iterator++)hangmanAsCharArray[iterator]=hangmanAsString[iterator];
    hangmanAsCharArray[stringLength]=0;
    int lastLetter=-1;
    
    //Find the last character which is not 'empty' ('.')
    for(int iterator=0;hangmanAsCharArray[iterator]!=0;iterator++){
        if(hangmanAsCharArray[iterator]!='.')lastLetter=iterator;
    }
    
    //Make string end at that position
    hangmanAsCharArray[lastLetter+1]=0;
    
    //replace '_' with '.' ro match format of puzzle solvers
    for(int iterator=0;hangmanAsCharArray[iterator]!=0;iterator++)if(hangmanAsCharArray[iterator]=='_')hangmanAsCharArray[iterator]='.';
    
    //Convert back to NSString
    hangman=[NSString stringWithFormat:@"%s", hangmanAsCharArray];
    
    //Initalize hangmanSolver and find the best guess
    AJBHangman *currentHangman=[[AJBHangman alloc]initWithWord:filterNSStringToLowercaseCharactersAndSpecialCharacters(hangman) andExcludedLetters:filterNSStringToLowercaseCharacters(self.guessedLettersField.text) andDictionary:dictionary];
    self.guessLabel.text=[currentHangman findGuess];
    
    //When the spinner shows up for about a tenth of a second then disappears, it looks extremly bad
    //For this reason, I make the thread sleep for an insignificant amount of time
    [NSThread sleepForTimeInterval:0.25f];
    
    //Stop the spinner in the background
    [self performSelectorInBackground:@selector(stopSpinner) withObject:nil];
}

-(IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"solveHangmanSegue"]){
        
        //Start the spinner in a new thread
        [self performSelectorInBackground:@selector(startSpinner) withObject:nil];
        
        //Fetch dictionary
        AJBDictionary *dictionary=self.dictionary;
        
        
        NSString *hangman=@"";
        
        //Iterate through the cells and append their values to the string
        for(int iterator=0;iterator<WIDTH*HEIGHT;iterator++){
            const char * currentFieldCharacterArray=[[[self.inputTextFieldArray objectAtIndex:iterator] text] UTF8String];
            int iteratorTwo;
            for(iteratorTwo=0;currentFieldCharacterArray[iteratorTwo+1]!=0;iteratorTwo++)continue;
            NSString * currentCharacter=[NSString stringWithFormat:@"%c", currentFieldCharacterArray[iteratorTwo]];
            
            //If empty, add blank char
            if([currentCharacter isEqualToString:@""] || [currentCharacter isEqualToString:@"\x1a"])
                hangman=[NSString stringWithFormat:@"%@.",hangman];
            //If not empty, add the character in the field to the string
            else
                hangman=[NSString stringWithFormat:@"%@%@",hangman,currentCharacter];
        }
        
        const char *hangmanAsString=[hangman UTF8String];
        char hangmanAsCharArray[MAX_STRING_SIZE];
        int stringLength=[hangman length];
        
        //Copy string to char array to edit it
        for(int iterator=0;hangmanAsString[iterator]!=0;iterator++)hangmanAsCharArray[iterator]=hangmanAsString[iterator];
        hangmanAsCharArray[stringLength]=0;
        int lastLetter=-1;
        
        //Find the last character which is not 'empty' ('.')
        for(int iterator=0;hangmanAsCharArray[iterator]!=0;iterator++){
            if(hangmanAsCharArray[iterator]!='.')lastLetter=iterator;
        }
        
        //Make string end at that position
        hangmanAsCharArray[lastLetter+1]=0;
        
        //replace '_' with '.' ro match format of puzzle solvers
        for(int iterator=0;hangmanAsCharArray[iterator]!=0;iterator++)if(hangmanAsCharArray[iterator]=='_')hangmanAsCharArray[iterator]='.';
        
        //Convert back to NSString
        hangman=[NSString stringWithFormat:@"%s", hangmanAsCharArray];
        
        //Initialize hangman class
        AJBHangman *currentHangman=[[AJBHangman alloc]initWithWord:filterNSStringToLowercaseCharactersAndSpecialCharacters(hangman) andExcludedLetters:filterNSStringToLowercaseCharacters(self.guessedLettersField.text) andDictionary:dictionary];        
        
        //Solve the puzzle and sort the solutions array
        NSArray *sortedArray;
        sortedArray = [[currentHangman findWords] sortedArrayUsingComparator:^NSComparisonResult(AJBWord* firstWord, AJBWord* secondWord){
            return [firstWord.word compare:secondWord.word];
        }];
        
        //Set solutions as detail item to destination view controller
        AJBSolutionsViewController *solutionsViewController = segue.destinationViewController;
        [solutionsViewController setDetailItem:[[NSMutableArray alloc]initWithArray:sortedArray]];
    }
    //Pass title and information if segue to help view
    else if([segue.identifier isEqualToString:@"hangmanHelpSegue"]){
        AJBPuzzleHelpViewController *helpViewController=segue.destinationViewController;
        [helpViewController setTitle:@"Hangman Solver Help" andInformation:@"Type in the letters of the word that you know and fill in the blank letters which are in the word with spaces, which will automatically be replaced with a \"?\".\n\nFor example; if you know that the word starts with the letter \"A\" and is four letters long, type \"A\" and then press space three times. Start from the start.\n\nIf a letter is confirmed to not be in the puzzle, type it into the text field near the middle of the screen labled \"Unused\".\n\nThe boxes are case insensitive and will only accept alphabetic characters, all symbols and digits will be ignored.\n\nTo find the best possible guess, tap the \"Guess\" button. If more than one letter shows up in the text field to the right of the \"Guess\" button, that indicates that any of the letters can be guessed as they have equal chance of being in the word.\n\nIf \"(none)\" appears in the text field, that means that there is no best guess that can be found, generally indicating that the word is not in the dictionary of the App.\n\nTo generate a list of words which the answer could be, press the return key or tap the \"Solve\" button.\n\nTo clear the view, tap the \"Clear\" button. "];
    }
}


@end
