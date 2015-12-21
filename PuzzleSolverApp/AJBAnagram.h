//
//  AJBAnagram.h
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 25/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "PuzzleSolvers.h"

@interface AJBAnagram : NSObject
@property(nonatomic,strong)AJBWord * word;
@property(nonatomic,strong)AJBDictionary * dictionary;
-(id)initWithWord:(NSString*)newWord andDictionary:(AJBDictionary*)newDictionary;
-(NSMutableArray*)findAnagrams;
@end
