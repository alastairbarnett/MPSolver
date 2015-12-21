//
//  AJBDictionary.m
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 19/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBDictionary.h"

@implementation AJBDictionary
@synthesize wordsArray;
@synthesize wordsAnagramDictionary;
@synthesize wordsDictionary;
@synthesize wordsByLength;
@synthesize wordsCount;

-(void)addWord:(NSString *)word withDefinition:(NSString*)defintion andAnagram:(NSString *)anagram asBaseWord:(BOOL)addAsBaseWord{
    //Declare pointer to the object of the new word
    AJBWord * newWordObject;
    
    //If word is in dictionary, re-define the definition and return (it is already in the database)
    if([self.wordsDictionary objectForKey:word] != nil){
        newWordObject=[self.wordsDictionary objectForKey:word];
        newWordObject.definition=defintion;
        return;
    }
    
    //Compute the anagram if it is not provided
    if(anagram) newWordObject=[[AJBWord alloc]initWithWord:word andDefinition:defintion andAnagram:anagram];
    else newWordObject=[[AJBWord alloc]initWithWord:word andDefinition:defintion];
    
    
    //Add word to universal word list
    if(!self.wordsArray)self.wordsArray=[[NSMutableArray alloc]init];
    [self.wordsArray addObject:newWordObject];
    
    //Add word to anagram lookup database
    if(!self.wordsAnagramDictionary)self.wordsAnagramDictionary=[[NSMutableDictionary alloc]init];
    NSMutableArray *anagramArray=[self.wordsAnagramDictionary objectForKey:newWordObject.anagram];
    if(anagramArray)[anagramArray addObject:newWordObject];
    else [self.wordsAnagramDictionary setObject:[[NSMutableArray alloc]initWithObjects:newWordObject, nil] forKey:newWordObject.anagram];
    
    
    //Add word to the dictionary word list, this allows constant time (quick) access to the
    //word object and vefification that the word is in the si
    if(!self.wordsDictionary)self.wordsDictionary=[[NSMutableDictionary alloc]init];
    [wordsDictionary setObject:newWordObject forKey:word];
    
    //Add the word by the list specific to size
    if(!self.wordsByLength)self.wordsByLength=[[NSMutableDictionary alloc]init];
    NSMutableArray *wordArray=[self.wordsByLength objectForKey:[NSNumber numberWithUnsignedLong:[word length]] ];
    if(wordArray)[wordArray addObject:newWordObject];
    else [self.wordsByLength setObject:[[NSMutableArray alloc]initWithObjects:newWordObject, nil] forKey:[NSNumber numberWithUnsignedLong:[word length]]];
    
    //Increase the variable that stores the number of words in the dictionary
    if(!self.wordsCount)self.wordsCount=[NSNumber numberWithInt:0];
    self.wordsCount = [NSNumber numberWithInt:[self.wordsCount integerValue]+1];
    
    
    //If the word in in the hardcoded word list add it to baseWordsList
    //This prevents it from being deleted when the user overwrites the definition
    //and then deletes the word
    if(addAsBaseWord){
        if(!self.baseWordsDictionary){
            self.baseWordsDictionary=[[NSMutableSet alloc]init];
        }
        [self.baseWordsDictionary addObject:word];
    }
}


//Attempts to remove a word from the wordlist
-(void)removeWord:(NSString *)word{
    
    //Avoid crach if the word is not in the list by returning
    if(![self.wordsDictionary objectForKey:word])return;
    
    //If the word is in the base word list, do not delete it, only reset the definition to default(@"") then return
    else if([self.baseWordsDictionary containsObject:word]){
        AJBWord *wordObject=[self.wordsDictionary objectForKey:word];
        wordObject.definition=@"";
        return;
    }
    
    
    //Create a new word object with the string passed in to generate an ordered string (i.e. bac->abc)
    AJBWord * newWordObject=[[AJBWord alloc]initWithWord:word andDefinition:@""];
    
    //iterate through the main wordlist and remove the word if it is found
    for(AJBWord *iterator in self.wordsArray){
        if([iterator.word isEqualToString:word]){
            [self.wordsArray removeObject:iterator];
            break;
        }
    }
    
    //Find the array of anagrams of the word being deleted inside the dictionary that stores these arrays
    //then remove the word from it. If the array is them empty remove it from the dictionary
    NSMutableArray *anagramArray=[self.wordsAnagramDictionary objectForKey:newWordObject.anagram];
    for(AJBWord *iterator in anagramArray){
        if([iterator.word isEqualToString:word]){
            [anagramArray removeObject:iterator];
            break;
        }
    }
    if(anagramArray.count == 0)[self.wordsAnagramDictionary removeObjectForKey:newWordObject.anagram];
    
    
    //Remove the word from the word dictionary
    [wordsDictionary removeObjectForKey:word];
    
    //Find the array of words the same length as the word in the words by length lookup
    //then remove the word from it. If the array is them empty remove it from the lookup dictionary
    NSMutableArray *lengthArray=[self.wordsByLength objectForKey:[NSNumber numberWithUnsignedLong:[word length]]];
    for(AJBWord *iterator in lengthArray){
        if([iterator.word isEqualToString:word]){
            [lengthArray removeObject:iterator];
            break;
        }
    }
    if(lengthArray.count == 0)[self.wordsByLength removeObjectForKey:[NSNumber numberWithUnsignedLong:[word length]]];
    
    //Decrement the word count
    self.wordsCount = [NSNumber numberWithInt:[self.wordsCount integerValue]-1];
}

//Finds all words of the format specified for example: 'h.llo' may return 'hello'
-(NSMutableArray *)findWordsOfFormat:(NSString*)format{
    NSMutableArray * foundWords=[[NSMutableArray alloc] init];
    const char *formatAsCharArray=[[format lowercaseString] UTF8String];
    
    //Use words by length cache if there are no known letters
    BOOL isAllUnknown=TRUE;
    for(int iterator=0;formatAsCharArray[iterator]!=0;iterator++){
        if(formatAsCharArray[iterator]!='.'){
            isAllUnknown=FALSE;
            break;
        }
    }
    if(isAllUnknown)return [self.wordsByLength objectForKey:[NSNumber numberWithInt:[format length]]];
    
    //Get the list of words to search (words the same length)
    NSMutableArray *arrayToSearch=[self.wordsByLength objectForKey:[NSNumber numberWithUnsignedLong:[format length]]];
    
    //Iterate through the words
    for(AJBWord * iterator in arrayToSearch){
        const char *currentWordAsCharArray=[[iterator.word lowercaseString] UTF8String];
        BOOL match=TRUE;
        
        //For each letter in the current word, check if either it is in the format string or letter at
        //that position in the format string is an unknown letter. If neither of these are true, indicate
        //that the word does not fit into the format by assigning FALSE to the 'match' bool
        for(int secondIterator=0;formatAsCharArray[secondIterator]!=0;secondIterator++){
            if(
               currentWordAsCharArray[secondIterator]!=formatAsCharArray[secondIterator] &&
               formatAsCharArray[secondIterator]!='.'
               ){
                match=FALSE;
                break;
            }
        }
        //If the word fits into the format, add it the the list of words to return
        if(match)[foundWords addObject:iterator];
    }
    //Return the list of words
    return foundWords;
}


//Simply return the list of words that are the length specified
-(NSMutableArray *)findWordsOfLength:(int)lengthOfWord{
    return [[NSMutableArray alloc] initWithArray:[self.wordsByLength objectForKey:[NSNumber numberWithInt:lengthOfWord]]];
}


//Returns all anagrams of a word including itself
-(NSMutableArray *)queryAnagram:(NSString*)word{
    AJBWord *newWord=[[AJBWord alloc] initWithWord:word andDefinition:@""];
    NSMutableArray *newArray=[[NSMutableArray alloc] initWithArray:[self.wordsAnagramDictionary objectForKey:newWord.anagram]];
    return newArray;
}


//Returns a list of all words in the dictionary
-(NSMutableArray*)findWords{
    return self.wordsArray;
}

@end
