//
//  AJBWord.m
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 17/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBWord.h"

@implementation AJBWord
@synthesize word;
@synthesize definition;
@synthesize anagram;


//Initialize and compute anagram
-(id)initWithWord:(NSString *)newWord andDefinition:(NSString *)newDefinition{
    self=[super init];
    self.word=newWord;
    self.definition=newDefinition;
    self.anagram=self.findAnagram;
    return self;
}


//Initialize with preconputed anagram
-(id)initWithWord:(NSString *)newWord andDefinition:(NSString *)newDefinition andAnagram:(NSString *)newAnagram{
    self=[super init];
    self.word=newWord;
    self.definition=newDefinition;
    self.anagram=newAnagram;
    return self;
}


//Arrange the string in alphabetical order
-(NSString *)findAnagram{
    
    //Initialize variables
    const char *wordAsCharacters=[[self.word lowercaseString] UTF8String];
    char characterArrayToReturn[MAX_STRING_SIZE];
    memset(characterArrayToReturn , 0 , sizeof(characterArrayToReturn));
    
    //Initialize the counts of the letters to 0
    int countOfLetters[CHARACTER_SET_COUNT];
    memset(countOfLetters , 0 , sizeof(countOfLetters));
    
    //Count the values of each of the letters in the word
    for(int iterator=0; wordAsCharacters[iterator]!=0; iterator++){
        int positionInArrayOfCurrentCharacter=(int)wordAsCharacters[iterator]-'a';
        countOfLetters[positionInArrayOfCurrentCharacter]++;
    }
    
    //Iterate through each letter value and append that number of letters to the
    //string to return
    int lengthOfStringToReturn=0;
    for(int iterator=0 ; iterator<CHARACTER_SET_COUNT ; iterator++){
        int secondIterator;
        for(secondIterator=0 ; secondIterator<countOfLetters[iterator] ; secondIterator++){
            characterArrayToReturn[lengthOfStringToReturn]=(char)iterator+'a';
            lengthOfStringToReturn++;
        }
    }
    
    //Return the sorted string as an NSString
    return [NSString stringWithFormat:@"%s",characterArrayToReturn];
}


//Return string with the word and an indicator that this is an AJBWord
-(NSString *)description{
    return [NSString stringWithFormat:@"AJBWord:%@", self.word];
}
@end
