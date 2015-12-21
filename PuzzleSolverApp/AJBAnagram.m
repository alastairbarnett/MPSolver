//
//  AJBAnagram.m
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 25/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBAnagram.h"

@implementation AJBAnagram
@synthesize word;
@synthesize dictionary;

//Initialize the object
-(id)initWithWord:(NSString*)newWord andDictionary:(AJBDictionary*)newDictionary{
    self=[super init];
    self.word=[[AJBWord alloc]initWithWord:newWord andDefinition:@""];
    self.dictionary=newDictionary;
    return self;
}

//Find and return Anagrams
-(NSMutableArray*)findAnagrams{
    //Find anagrams through dictionary anagram query method
    NSMutableArray* anagrams=[NSMutableArray arrayWithArray:[dictionary queryAnagram:self.word.word]];
    
    //Remove original word from anagrams
    for(AJBWord* iterator in anagrams){
        if([iterator.word isEqualToString:self.word.word]){
            [anagrams removeObject:iterator];
            break;
        }
    }
    
    //Return found anagrams
    return anagrams;
}
@end
