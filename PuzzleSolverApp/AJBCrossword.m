//
//  AJBCrossword.m
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 30/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBCrossword.h"

//Initialize object with the format of the target word and the dictionary
@implementation AJBCrossword
-(id)initWithWord:(NSString*)newWord andDictionary:(AJBDictionary*)newDictionary{
    self=[super init];
    self.word=newWord;
    self.dictionary=newDictionary;
    return self;
}

//Return words of the format of self.word

//This class is simply to make code appear neater, all of it's functionality can be
//called from the AJBDictionary object that it uses
-(NSMutableArray *)findWords{
    return [self.dictionary findWordsOfFormat:self.word];
}
@end
