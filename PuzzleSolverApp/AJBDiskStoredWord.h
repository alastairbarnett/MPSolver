//
//  AJBDiskStoredWord.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 6/11/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface AJBDiskStoredWord : NSManagedObject
@property (nonatomic, strong) NSString * word;
@property (nonatomic, strong) NSString * definition;
@property (nonatomic, strong) NSString * anagram;
@end
