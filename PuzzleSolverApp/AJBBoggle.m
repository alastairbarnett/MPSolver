//
//  AJBBoggle.m
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 24/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//
#import "AJBBoggle.h"

@implementation AJBBoggle
@synthesize boggleBoard;
@synthesize dictionary;


//Initialize object with board and dictionary
-(id)initWithBoard:(NSString*)newBoggleBoard andDictionary:(AJBDictionary *)newDictionary{
    self=[super init];
    self.boggleBoard=newBoggleBoard;
    self.dictionary=newDictionary;
    return self;
}


//Search for a word in the board. Recursive. Returns YES if word is found, Else retuns NO.
//Algorithm is derivitive of depth first search
//This function is purely c code because it needs to be efficient and
//performing conversions with NSStrings and NSMutableArrays is unnecessary
-(BOOL)searchBoard:(const char *)currentBoard forString:(const char *)string atLocation:(int)location asStart:(BOOL)isStart{
    
    //  Below is a representation of a 4x4 boggle board
    //
    //  0123
    //  4567
    //  89ab
    //  cdef
    //
    //In general for this function a 'position' is a number representing
    //how far the box is from the start going across then down.
    //XValues and YValues are the x and y co-orodinates.
    
    //Find the length of the remaining string
    int stringLength=0;
    for(;string[stringLength]!=0;stringLength++)continue;
    
    //Return YES if the string is empty as that means that all previous letters have been found
    if(stringLength==0)return YES;
    
    //Copy the board to the new local variable as it must be edited
    const char *boardCharArray=currentBoard;
    char mutableBoardCharArray[MAX_STRING_SIZE];
    for(int iterator=0;boardCharArray[iterator];iterator++){
        mutableBoardCharArray[iterator]=boardCharArray[iterator];
        mutableBoardCharArray[iterator+1]=0;
    }
    
    //Delete the first character if this is the first layer of recursion
    const char *stringCharArray=(const char *)string+isStart;
    
    int iteratorOne, iteratorTwo, currentPositionXValue=location%BOGGLE_SIZE,currentPositionYValue=location/BOGGLE_SIZE;
    
    //Two nested loops to iterate through connected letters as x and y can both only change by a maximum of one to reach these
    for(iteratorOne=-1;iteratorOne<=1;iteratorOne++)
        for(iteratorTwo=-1;iteratorTwo<=1;iteratorTwo++){
            //Calculate new x and y co-ordinates
            int newXValue=currentPositionXValue+iteratorOne,newYValue=currentPositionYValue+iteratorTwo;
            
            //Test if the new position is within the box (e.g. not (-1,-1)) and that it is not the current square.
            if(newXValue>=0 && newXValue<BOGGLE_SIZE && newYValue>=0 && newYValue<BOGGLE_SIZE && (newXValue+BOGGLE_SIZE*newYValue!=location)){
                
                //Convert x and y co-ordinates to a position to access the cell in an array.
                int newPosition=newXValue+BOGGLE_SIZE*newYValue;
                
                //If the letter being searched for is in the new square, search if the rest of the word can be formed
                //from that position using recursion
                if(stringCharArray[0]==boardCharArray[newPosition]){
                    
                    
                    //Make char pointer that is one more than the char pointer,
                    //essentially creates new string with old string but first char deleted
                    char * newStringCharArray=(char*)stringCharArray+1;
                    
                    //Delete the current letter from the board, as to not attempt to use it in the future
                    mutableBoardCharArray[location]='.';
                    
                    //Recursivly call SearchBoard with with new string, the current letter of the board deleted and in a new starting location
                    BOOL found=[self searchBoard:(const char *)mutableBoardCharArray forString:(const char *)newStringCharArray atLocation:(int)newPosition asStart:FALSE];
                    //Return YES if the function was able to find the string
                    if(found)return YES;
                }
            }
    }
    //If this point is reached, the string has not been found so the function returns NO
    return NO;
}

//Function to iterate through words that could be in the boggle puzzle
-(NSMutableArray*)searchForWords{
    
    //Declare local variables and fetch wordlist
    NSMutableArray *wordsToReturn=[[NSMutableArray alloc]init], *wordsList=[self.dictionary findWords];
    const char *boardAsCharacterArray=[self.boggleBoard UTF8String];
    
    //Iterate through all words in the wordslist
    //this can be done because words are eliminated fairly quickly by the searchBoard function
    for(AJBWord *currentWord in wordsList){
        //For a boggle word to score it must be of 3 letters or larger
        //Also, as there are only 16 tiles and each can only be used once, words must consist of 16 letters or less.
        //If the word does not fit these criteria, continue to the next iteration of the loop
        if([currentWord.word length]<3 || [currentWord.word length]>16)continue;  
        
        
        //Convert the word to a char array
        const char *wordAsCharacterArray=[currentWord.word UTF8String];
        
        //Iterate through positions on the board and call the searchBoard function if the letter at
        //the position matches the letter at the current positon on the board
        for(int iterator=0;iterator<BOGGLE_SIZE*BOGGLE_SIZE;iterator++)
            if(boardAsCharacterArray[iterator]==wordAsCharacterArray[0])
                if([self searchBoard:boardAsCharacterArray forString:wordAsCharacterArray atLocation:iterator asStart:TRUE]){
                    //Add the word to the array of words which were found then stop searching for the word
                    [wordsToReturn addObject:currentWord];
                    break;
                }
    }
    //Return results
    return wordsToReturn;
}

@end
