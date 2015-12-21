//
//  AJBHangman.h
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 25/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "PuzzleSolvers.h"

@interface AJBHangman : NSObject
@property(nonatomic,strong) NSString * word;
@property(nonatomic,strong) NSMutableDictionary * guessedLetters;
@property(nonatomic,strong) AJBDictionary * dictionary;
-(id)initWithWord:(NSString *)newWord andExcludedLetters:(NSString*)newExcludedLetters andDictionary:(AJBDictionary*)newDictionary;
-(NSMutableDictionary*)buildWithConfirmedLetters:(NSString *)confirmedLetters andExcludedLetters:(NSString*)excludedLetters;
-(NSMutableArray*)findWords;
-(NSString*)findGuess;
@end
