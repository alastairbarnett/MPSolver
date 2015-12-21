//
//  AJBBoggle.h
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 24/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "PuzzleSolvers.h"

//Defines the width and height of boggle puzzles
#define BOGGLE_SIZE 4

@interface AJBBoggle : NSObject
@property(nonatomic,strong)NSString * boggleBoard;
@property(nonatomic,strong)AJBDictionary * dictionary;
-(id)initWithBoard:(NSString*)newBoggleBoard andDictionary:(AJBDictionary *)newDictionary;
-(BOOL)searchBoard:(const char *)currentBoard forString:(const char *)string atLocation:(int)location asStart:(BOOL)isStart;
-(NSMutableArray *)searchForWords;
@end
