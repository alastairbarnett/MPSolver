//
//  AJBScrabble.h
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 30/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "PuzzleSolvers.h"

@interface AJBScrabble : NSObject
@property(nonatomic,strong)NSString * word;
@property(nonatomic,strong)NSString * hand;
@property(nonatomic,strong)AJBDictionary * dictionary;
-(id)initWithWord:(NSString *)newWord andHand:(NSString *)newHand andDictionary:(AJBDictionary*)newDictionary;
-(NSMutableArray*)findWords;
@end
