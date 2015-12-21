//
//  AJBHangman.m
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 25/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBHangman.h"

@implementation AJBHangman
@synthesize word;
@synthesize guessedLetters;
@synthesize dictionary;

//Initialize the object with the current known format of the word,
//the letters which are known to not be in the word and the dictionary to be used
-(id)initWithWord:(NSString *)newWord andExcludedLetters:(NSString*)newExcludedLetters andDictionary:(AJBDictionary*)newDictionary{
    self=[super init];
    self.word=newWord;
    self.guessedLetters=[self buildWithConfirmedLetters:newWord andExcludedLetters:newExcludedLetters];
    self.dictionary=newDictionary;
    return self;
}


//Finds words which the word can be given the word format and the unused letters
//Must take into account letters which cannot be in the word
//because they have been confirmed to not be in the word
-(NSMutableArray*)findWords{
    //Initialize variables
    NSMutableArray * possibleWords=[self.dictionary findWordsOfFormat:self.word], *wordsToReturn=[[NSMutableArray alloc]init];
    const char *formatAsCharArray=[self.word UTF8String];
    
    
    //Iterate through words that follow the format of the self.word
    for(AJBWord * iterator in possibleWords){
        
        NSMutableDictionary * impliesLetterFound=[[NSMutableDictionary alloc] init];
        const char *currentWordAsCharacterArray=[iterator.word UTF8String];
        //Pass test by default, change to FALSE if if fails
        BOOL passes=TRUE;
        
        
        //Iterate through the characters in the word
        for(int iteratorOne=0;currentWordAsCharacterArray[iteratorOne]!=0;iteratorOne++){
            
            //Initialise variables
            NSString * currentCharacter=[NSString stringWithFormat:@"%c",currentWordAsCharacterArray[iteratorOne]];
            
            //Is letter used in the word? nil:unknown, @FALSE:NO, @TRUE:YES
            NSNumber * isUsed=[self.guessedLetters objectForKey:currentCharacter];
            
            //must the letter have been found already? nil:unknown, @FALSE:NO, @TRUE:YES
            //e.g. hello could not be a possible solution for a word of the format "h..lo" because if it was then
            //when the letter revelealed l was guessed, the other l would have been revealed
            NSNumber * impliesCurrentFound=[impliesLetterFound objectForKey:currentCharacter];
            
            //Current letter has been encountered before
            if(impliesCurrentFound){
                //If current letter is not in the word and has been found or current letter is in the word and has not been found
                //Then the test and break
                if([impliesCurrentFound isEqualToNumber:@FALSE] == (formatAsCharArray[iteratorOne]==currentWordAsCharacterArray[iteratorOne])){
                    passes=FALSE;
                    break;
                }
            }
            //Current letter is new record whether it is in the word or not as far as is known
            else{
                [impliesLetterFound setObject:@(formatAsCharArray[iteratorOne]==currentWordAsCharacterArray[iteratorOne]) forKey:currentCharacter];
            }
            //If the letter has not been guessed or the letter is in the word the word does not fail 
            if(!isUsed || [isUsed isEqualToNumber:[NSNumber numberWithBool:TRUE]]){
                continue;
            }
            //Else the word does not pass
            else{
                passes=FALSE;
                break;
            }
        }
        //If the word passed the test add it to the array to return
        if(passes){
            [wordsToReturn addObject:iterator];
        }
    }
    //Return found words
    return wordsToReturn;
}

//Function to build NSSets of letters in the word and failed guesses
-(NSMutableDictionary*)buildWithConfirmedLetters:(NSString *)newConfirmedLetters andExcludedLetters:(NSString*)newExcludedLetters{
    //Initialize variables
    const char * confirmedCharArray=[newConfirmedLetters UTF8String], * excludedCharArray=[newExcludedLetters UTF8String];
    NSMutableDictionary *returnGuessedLetters=[[NSMutableDictionary alloc]init];
    
    //Add confirmed and excluded letters to the NSSet with their state
    for(int iterator=0;confirmedCharArray[iterator]!=0;iterator++)if(confirmedCharArray[iterator]!='.')
        [returnGuessedLetters setObject:[NSNumber numberWithBool:TRUE] forKey:[NSString stringWithFormat:@"%c",confirmedCharArray[iterator]]];
    for(int iterator=0;excludedCharArray[iterator]!=0;iterator++)
        [returnGuessedLetters setObject:[NSNumber numberWithBool:FALSE] forKey:[NSString stringWithFormat:@"%c",excludedCharArray[iterator]]];
    //Return NSSet
    return returnGuessedLetters;
    
}

-(NSString*)findGuess{
    //Best answers at start of game for each length of word. Cacheing is worthwile because they are processer intensive and common
    //Must be manually entered if wordslist is changed. These do not account for custom words (but that should not matter).
    NSArray *quickAnswers=@[
        /*0*/ @"(none)",
        /*1*/ @"(none)",
        /*2*/ @"o",
        /*3*/ @"a",
        /*4*/ @"e",
        /*5*/ @"s",
        /*6*/ @"e",
        /*7*/ @"e",
        /*8*/ @"e",
        /*9*/ @"e",
       /*10*/ @"e",
       /*11*/ @"e",
       /*12*/ @"e",
       /*13*/ @"e",
       /*14*/ @"s",
       /*15*/ @"s",
       /*16*/ @"s",
    ];
    
    //Check if the word is all unknown characters, if so; return a cached answer
    const char* formatAsCharArray=[self.word UTF8String];
    BOOL isAllUnknown=TRUE;
    for(int iterator=0;formatAsCharArray[iterator]!=0;iterator++){
        if(formatAsCharArray[iterator]!='.'){
            isAllUnknown=FALSE;
            break;
        }
    }
    if(isAllUnknown && [self.guessedLetters count]==0)return quickAnswers[self.word.length];
    
    //Fetch wordlist
    NSMutableArray *confirmedWords=[self findWords];
    
    //Initialize the count of each letter to 0
    int letterCounts[CHARACTER_SET_COUNT];
    for(int iterator=0;iterator<CHARACTER_SET_COUNT;iterator++){
        letterCounts[iterator]=0;
    }
    
    //Iterate through words increment counts of the letters in them
    for(AJBWord* wordIterator in confirmedWords){
        const char * wordAsCharArray=[wordIterator.word UTF8String];
        for(int iterator=0;wordAsCharArray[iterator]!=0;iterator++){
            letterCounts[wordAsCharArray[iterator]-'a']++;
        }
    }
    
    //Finf the maximum value of the counts
    int maximum=0;
    for(int iterator=0;iterator<CHARACTER_SET_COUNT;iterator++){
        if(letterCounts[iterator]>maximum && ![self.guessedLetters objectForKey:[NSString stringWithFormat:@"%c",iterator+'a']])maximum=letterCounts[iterator];
    }
    
    //Return string with all letters with counts equal to the maximum
    NSString *returnString=@"";
    if(maximum!=0)
        for(int iterator=0;iterator<CHARACTER_SET_COUNT;iterator++){
            if(letterCounts[iterator]==maximum && ![self.guessedLetters objectForKey:[NSString stringWithFormat:@"%c",iterator+'a']])returnString=[NSString stringWithFormat:@"%@%c", returnString, iterator+'a'];
        }
    //Return "(none)" instead of empty string
    if([returnString isEqualToString:@""])returnString=@"(none)";
    return returnString;
}
@end
