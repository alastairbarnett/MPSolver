//
//  AJBDictionary.h
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 19/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBWord.h"
#import "PuzzleSolvers.h"


@interface AJBDictionary : NSObject
@property(nonatomic,strong) NSMutableDictionary *wordsDictionary;
@property(nonatomic,strong) NSMutableArray *wordsArray;
@property(nonatomic,strong) NSMutableDictionary *wordsAnagramDictionary;
@property(nonatomic,strong) NSMutableSet *baseWordsDictionary;
@property(nonatomic,strong) NSMutableDictionary *wordsByLength;
@property(nonatomic,strong) NSNumber *wordsCount;
-(void)addWord:(NSString *)word withDefinition:(NSString*)defintion andAnagram:(NSString *)anagram asBaseWord:(BOOL)addAsBaseWord;
-(NSMutableArray *)findWordsOfLength:(int)lengthOfWord;
-(NSMutableArray *)queryAnagram:(NSString*)word;
-(NSMutableArray *)findWords;
-(NSMutableArray *)findWordsOfFormat:(NSString*)format;
-(void)removeWord:(NSString *)word;
@end
