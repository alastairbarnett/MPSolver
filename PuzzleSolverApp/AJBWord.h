//
//  AJBWord.h
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 17/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PuzzleSolvers.h"


@interface AJBWord : NSObject
@property (nonatomic, strong) NSString * word;
@property (nonatomic, strong) NSString * definition;
@property (nonatomic, strong) NSString * anagram;
-(id)initWithWord:(NSString *)newWord andDefinition:(NSString *)newDefinition;
-(id)initWithWord:(NSString *)newWord andDefinition:(NSString *)newDefinition andAnagram:(NSString *)newAnagram;
-(NSString *)findAnagram;
-(NSString *)description;
@end
