//
//  AJBCrosswordSolverViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 23/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBCrosswordSolverViewController.h"
@implementation AJBCrosswordSolverViewController
@synthesize clearButton;

//Definitions regarding text field cell measurments
#define CELL_WIDTH 35
#define CELL_HEIGHT 35
#define MARGIN_WIDTH -1 //Overlap Boarder
#define MARGIN_HEIGHT 5 //Overlap Boarder
#define HEIGHT 3
#define WIDTH 8

//X and Y of first box
#define START_X ((320)-(CELL_WIDTH*WIDTH+MARGIN_WIDTH*(WIDTH-1)))/2 //Centers the boxes horozontally
#define START_Y ((152)-(CELL_HEIGHT*HEIGHT+MARGIN_HEIGHT*(HEIGHT-1)))/2

-(void)viewWillAppear:(BOOL)animated{
    
    //Remove loading view if it exists
    [self stopSpinner];
    
    //If this in not the first time the view has loaded, return (cells already exist)
    if([self.viewHasLoaded isEqualToNumber:@FALSE]){
        
        //State that the view has loaded
        self.viewHasLoaded=@TRUE;
        
        //Create an array to hold the text fields
        NSMutableArray *textFieldArray=[[NSMutableArray alloc]init];
        
        //Iterate through X axis and Y axis of field grid
        for(int iteratorY=0;iteratorY<HEIGHT;iteratorY++)
            for(int iteratorX=0;iteratorX<WIDTH;iteratorX++){
                
                //Initialize current text field
                UITextField *newTextField=[[UITextField alloc] init];
                
                
                //Set text field apperence
                newTextField.layer.borderColor=[UIColor blackColor].CGColor;
                newTextField.layer.borderWidth=1.0f;
                newTextField.font=[UIFont fontWithName:@"Futura-Medium" size:17.0];
                
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
        
        //Initialize buttons to white box with black borders
        self.clearButton.layer.borderColor=[UIColor blackColor].CGColor;
        self.clearButton.layer.borderWidth=1;
        
        self.solveButton.layer.borderColor=[UIColor blackColor].CGColor;
        self.solveButton.layer.borderWidth=1;
    }
    
    //Iterate through text fields and color them according to whether they have a '?' in them
    for(UITextField *currentField in self.inputTextFieldArray){
        //Has question mark in field
        if([currentField.text isEqualToString:@"\x1a?"]){
            
            //Color cell black with white text
            currentField.textColor=[UIColor whiteColor];
            currentField.backgroundColor=[UIColor blackColor];
        }
        else{
            //Color cell white with black text
            currentField.textColor=[UIColor blackColor];
            currentField.backgroundColor=[UIColor whiteColor];
        }
    }
    
    //Initialize easter egg
    self.easterEggAlreadyEnabled=@FALSE;
    self.easterEggCurrentFrame=@0;
}

-(void)viewDidLoad{
    //initialize view has loaded
    self.viewHasLoaded=@FALSE;
}

-(void)viewWillDisappear:(BOOL)animated{
    //Invalidate NSTimers to disable animation (if any)
    [self.easterEggAnimationTimer invalidate];
    self.easterEggAnimationTimer=nil;
    [self.easterEggSoundTimer invalidate];
    self.easterEggSoundTimer=nil;
}

- (void)textFieldEdited:(UITextField*)sender{
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
            sender.text=@"\x1a?";
        }
        else{
            NSString* newString=[NSString stringWithFormat:@"\x1a%c",stringAsCharArray[iterator-1]];
            if(![newString isEqualToString:sender.text])sender.text=newString;
        }
        
        //If the sender is not the last, go to the next box
        if(indexOfSender!=WIDTH*HEIGHT-1)
            [[self.inputTextFieldArray objectAtIndex:indexOfSender+1]becomeFirstResponder];
    }
    
    //If easter egg is enabled, do not interfere with animation by changing cell colors
    if([self.easterEggAlreadyEnabled isEqualToNumber:@FALSE]){
        
        //Iterate through text fields and color them according to whether they have a '?' in them
        for(UITextField *currentField in self.inputTextFieldArray){
            //Has question mark in field
            if([currentField.text isEqualToString:@"\x1a?"]){
                
                //Color cell black with white text
                currentField.textColor=[UIColor whiteColor];
                currentField.backgroundColor=[UIColor blackColor];
            }
            else{
                //Color cell white with black text
                currentField.textColor=[UIColor blackColor];
                currentField.backgroundColor=[UIColor whiteColor];
            }
        }
    }
}

//Define quick reference for colors 
#define R [UIColor redColor]
#define Y [UIColor yellowColor]
#define G [UIColor greenColor]
#define B [UIColor blueColor]


//Animation method triggered by NSTimer
-(void)animateBoxes{
    
    
    //Each array inside the 'animation' array is a frame of the array
    NSArray* animation=@[
        @[
            R,R,R,R,R,G,G,R,
            G,G,G,G,G,G,R,R,
            R,R,G,R,G,R,R,R
        ],
        @[
            G,G,G,G,G,G,R,R,
            G,R,R,R,R,R,R,G,
            G,G,G,R,G,R,G,G
        ]
    ];
    
    //Iterate through text fields and set the colors of the current frame
    for(int iterator=0;iterator<WIDTH*HEIGHT;iterator++){
        //Local variable for the field which is currently being accessed
        UITextField * currentField=[self.inputTextFieldArray objectAtIndex:iterator];
        
        //Set background color from array
        currentField.backgroundColor=animation[[self.easterEggCurrentFrame intValue]][iterator];
        const CGFloat *componentColors = CGColorGetComponents(currentField.backgroundColor.CGColor);
        
        //Set text field as inverse color to background
        currentField.textColor=[[UIColor alloc] initWithRed:(1.0 - componentColors[0])
                                                      green:(1.0 - componentColors[1])
                                                       blue:(1.0 - componentColors[2])
                                                      alpha:componentColors[3]];
    }
    //Increase frame counter
    self.easterEggCurrentFrame=[NSNumber numberWithInt:(([self.easterEggCurrentFrame intValue]+1)%animation.count)];
}

//Play the sound of the easter egg with AudioToolbox framework
-(void)playEasterEggSound{
    
    //Get URL of resource
    NSURL *soundPathURL=[[NSBundle mainBundle] URLForResource:@"everybodyWalkTheDinosaur" withExtension:@"aif"];
    SystemSoundID soundID;
    
    //Create Sound
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundPathURL, &soundID);
    
    //Play Sound
    AudioServicesPlaySystemSound (soundID);
}


- (IBAction)clearButtonPressed:(id)sender{
    
    //Test for easter egg code entry, do not do if easter egg is already enabled
    if([self.easterEggAlreadyEnabled isEqualToNumber:@FALSE]){
        
        //Extract the string from the boxes
        NSString *fieldText=@"";
        for(int iterator=0;iterator<WIDTH*HEIGHT;iterator++){
            const char * currentFieldCharacterArray=[[[self.inputTextFieldArray objectAtIndex:iterator] text] UTF8String];
            int iteratorTwo;
            for(iteratorTwo=0;currentFieldCharacterArray[iteratorTwo+1]!=0;iteratorTwo++)continue;
            
            NSString * currentCharacter=[NSString stringWithFormat:@"%c", currentFieldCharacterArray[iteratorTwo]];
            
            //Add character it it exists, else add nothing
            if(![currentCharacter isEqualToString:@"\x1a"])fieldText=[NSString stringWithFormat:@"%@%@",fieldText,currentCharacter];
        }
        //Test if string is equal to easter egg activation string ("everybodywalkthedinosaur")
        if([fieldText isEqualToString:@"everybodywalkthedinosaur"]){
            //State that easter egg is enabled and play sound
            self.easterEggAlreadyEnabled=@TRUE;
            [self playEasterEggSound];
            
            //Start the sount timer (sound is aproximatly 4.15 seconds in length)
            self.easterEggSoundTimer=[NSTimer     scheduledTimerWithTimeInterval:4.15f
                                                                          target:self
                                                                        selector:@selector(playEasterEggSound)
                                                                        userInfo:nil
                                                                         repeats:YES];
            //Show first frame of amimation
            [self animateBoxes];
            
            //Start the animation timer
            self.easterEggAnimationTimer=[NSTimer scheduledTimerWithTimeInterval:0.4f
                                                                          target:self
                                                                        selector:@selector(animateBoxes)
                                                                        userInfo:nil
                                                                         repeats:YES];
            
        }
    }
    
    //Iterate through text boxes
    for(UITextField * currentField in self.inputTextFieldArray){
        
        //If the easter egg is not enabled, make the text field white with black text
        if([self.easterEggAlreadyEnabled isEqualToNumber:@FALSE]){
            currentField.textColor=[UIColor blackColor];
            currentField.backgroundColor=[UIColor whiteColor];
        }
        
        //Set to (empty)
        currentField.text=@"\x1a";
    }
    
    //make first cell first responders
    [[self.inputTextFieldArray objectAtIndex:0] becomeFirstResponder];
}

- (IBAction)returnKeyWasPressed:(id)sender {
    //Generate and show solutions when return key pressed
    [self performSegueWithIdentifier:@"solveCrosswordSegue" sender:sender];
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
    if([segue.identifier isEqualToString:@"solveCrosswordSegue"]){
        
        //Start spinner in new thread, must be done otherwise the view does not refresh
        [self performSelectorInBackground:@selector(startSpinner) withObject:nil];
        
        //Fetch dictionary
        AJBDictionary *dictionary=self.dictionary;
        
        //Iterate through all of the boxes and extract a string from the letters
        NSString *crossword=@"";
        for(int iterator=0;iterator<WIDTH*HEIGHT;iterator++){
            const char * currentFieldCharacterArray=[[[self.inputTextFieldArray objectAtIndex:iterator] text] UTF8String];
            int iteratorTwo;
            for(iteratorTwo=0;currentFieldCharacterArray[iteratorTwo+1]!=0;iteratorTwo++)continue;
            NSString * currentCharacter=[NSString stringWithFormat:@"%c", currentFieldCharacterArray[iteratorTwo]];
            if([currentCharacter isEqualToString:@""] || [currentCharacter isEqualToString:@"\x1a"])
                crossword=[NSString stringWithFormat:@"%@.",crossword];
            else
                crossword=[NSString stringWithFormat:@"%@%@",crossword,currentCharacter];
        }
        
        //Ensure that empty spaces at the end of the string are removed
        const char *crosswordAsString=[crossword UTF8String];
        char crosswordAsCharArray[MAX_STRING_SIZE];
        int stringLength=[crossword length];
        for(int iterator=0;crosswordAsString[iterator]!=0;iterator++)crosswordAsCharArray[iterator]=crosswordAsString[iterator];
        crosswordAsCharArray[stringLength]=0;
        int lastLetter=-1;
        
        //Locate the last letter of the string
        for(int iterator=0;crosswordAsCharArray[iterator]!=0;iterator++){
            if(crosswordAsCharArray[iterator]!='.')lastLetter=iterator;
        }
        
        //Make the string end after that
        crosswordAsCharArray[lastLetter+1]=0;
        
        //Convert '?' to '.' for puzzle solver format
        for(int iterator=0;crosswordAsCharArray[iterator]!=0;iterator++)if(crosswordAsCharArray[iterator]=='?')crosswordAsCharArray[iterator]='.';
        crossword=[NSString stringWithFormat:@"%s", crosswordAsCharArray];
        
        
        //Declare view controller pointer
        AJBSolutionsViewController *solutionsViewController = segue.destinationViewController;
        
        //Initialize crossword solver object
        AJBCrossword *currentCrossword=[[AJBCrossword alloc]initWithWord:filterNSStringToLowercaseCharactersAndSpecialCharacters(crossword) andDictionary:dictionary];
        
        //Find and sort solutions
        NSArray *sortedArray;
        sortedArray = [[currentCrossword findWords] sortedArrayUsingComparator:^NSComparisonResult(AJBWord* firstWord, AJBWord* secondWord){
            return [firstWord.word compare:secondWord.word];
        }];
        
        //Set detail item of destination view controller
        [solutionsViewController setDetailItem:[[NSMutableArray alloc]initWithArray:sortedArray]];
    }
    //If segue to help, pass title and information
    else if([segue.identifier isEqualToString:@"crosswordHelpSegue"]){
        AJBPuzzleHelpViewController *helpViewController=segue.destinationViewController;
        [helpViewController setTitle:@"Crossword Solver Help" andInformation:@"Type in the letters of the word that you know and fill in the blank letters which are in the word with spaces, which will automatically be replaced with a \"?\".\n\nFor example; if you know that the word starts with the letter \"A\" and is four letters long, type \"A\" and then press space three times.\n\nThe boxes are case insensitive and will only accept alphabetic characters, all symbols and digits will be ignored.\n\nTo generate solutions to the puzzle press the return key or tap the \"Solve\" button. To clear the view, tap the \"Clear\" button."];
    }
}

@end
