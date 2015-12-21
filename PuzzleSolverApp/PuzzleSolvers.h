//
//  PuzzleSolvers.h
//  PuzzleSolvers
//
//  Created by Alastair Barnett on 25/09/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

//Header that all classes solving puzzles need, includes 

#import <Foundation/Foundation.h>

//Essentially the number of letters in the alphabet
//I do not expect the number of letters in the alphabet to change but this
//looks neater than just typing 26
#define CHARACTER_SET_COUNT 26

//Size to declare char arrays by default for the purpose of storing a word
#define MAX_STRING_SIZE 200

//NSString of all letters in alphabet
#define ALPHABET_CHARACTER_SET_NSSTRING @"abcdefghijklmnopqrstuvwxyz"

//NSString of all letters in alphabet plus the 'unknown letter' character
#define ALPHABET_AND_SPECIAL_CHARACTER_SET_NSSTRING @"abcdefghijklmnopqrstuvwxyz."

//Trim an NSString of everything but lowercase letters (convert uppercase to lowercase)
//This function is used often and huge block of object code looks messy and undeciperable
//so this allows the function to be called the good old c way
#define filterNSStringToLowercaseCharacters(NSStringObject) [[[NSStringObject lowercaseString]componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:ALPHABET_CHARACTER_SET_NSSTRING] invertedSet]] componentsJoinedByString:@""]

//Same as above but allow 'unknown letter' characters
#define filterNSStringToLowercaseCharactersAndSpecialCharacters(NSStringObject) [[[NSStringObject lowercaseString]componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:ALPHABET_AND_SPECIAL_CHARACTER_SET_NSSTRING] invertedSet]] componentsJoinedByString:@""]

//Import AJBDictionary and AJBWord classes
#import "AJBWord.h"
#import "AJBDictionary.h"
