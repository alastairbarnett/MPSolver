//
//  AJBScrabble.m
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 30/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBScrabble.h"

@implementation AJBScrabble
//Initialize variables
-(id)initWithWord:(NSString *)newWord andHand:(NSString *)newHand andDictionary:(AJBDictionary*)newDictionary{
    self=[super init];
    self.word=newWord;
    self.hand=newHand;
    self.dictionary=newDictionary;
    return self;
}

//Find words which follow the format that of the word on the board and can be formed from the hand
-(NSMutableArray*)findWords{
    //Initialize variables
    NSMutableArray *possibleWords=[self.dictionary findWordsOfFormat:self.word],*wordsToReturn=[[NSMutableArray alloc]init];
    
    
    //For all words that fit the format of the word on the board
    //check if all of the letters in it are in the hand or the board
    AJBWord *wordBuffer=[[AJBWord alloc]initWithWord:[NSString stringWithFormat:@"%@%@", self.hand, self.word] andDefinition:@""];
    
    //Get sorted string of hand+(word on board) (i.e. bad->abd)
    const char *wordAnagram=[wordBuffer.anagram UTF8String];
    
    //Iterate through words that fit the format of the word on the board
    for(AJBWord * iterator in possibleWords){
        //Get sorted string of the current word
        const char *iteratorAnagram=[iterator.anagram UTF8String];
        
        //Test if all letters in the word are in the hand or the word on the board
        int iteratorAnagramPosition=0,wordAnagramPosition=0;
        BOOL passes=TRUE;
        for(;iteratorAnagram[iteratorAnagramPosition]!=0 && wordAnagram[wordAnagramPosition]!=0;){
            if(iteratorAnagram[iteratorAnagramPosition]<wordAnagram[wordAnagramPosition]){
                passes=FALSE;
                break;
            }
            else if(iteratorAnagram[iteratorAnagramPosition]>wordAnagram[wordAnagramPosition]){
                wordAnagramPosition++;
            }
            else if(iteratorAnagram[iteratorAnagramPosition]==wordAnagram[wordAnagramPosition]){
                iteratorAnagramPosition++;
                wordAnagramPosition++;
            }
        }
        if(iteratorAnagram[iteratorAnagramPosition]!=0 && wordAnagram[wordAnagramPosition]==0)passes=FALSE;
        
        //Add the word to the array to return if it passes the test
        if(passes)[wordsToReturn addObject:iterator];
    }
    //Return words
    return wordsToReturn;
}
@end
