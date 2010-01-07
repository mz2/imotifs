//
//  BCToolSequenceFinder.h
//  BioCocoa
//
//  Created by Koen van der Drift on 10/28/04.
//  Copyright 2004 The BioCocoa Project. All rights reserved.
//
//  This code is covered by the Creative Commons Share-Alike Attribution license.
//	You are free:
//	to copy, distribute, display, and perform the work
//	to make derivative works
//	to make commercial use of the work
//
//	Under the following conditions:
//	You must attribute the work in the manner specified by the author or licensor.
//	If you alter, transform, or build upon this work, you may distribute the resulting work only under a license identical to this one.
//
//	For any reuse or distribution, you must make clear to others the license terms of this work.
//	Any of these conditions can be waived if you get permission from the copyright holder.
//
//  For more info see: http://creativecommons.org/licenses/by-sa/2.5/

/*!
@header
@abstract Sequence searching.
*/

#import <Foundation/Foundation.h>
#import "BCSequenceTool.h"

@class	BCSequence, BCSymbol;

/*!
@class BCToolSequenceFinder
@abstract    A wrapper class to search a sequence
@discussion  This class can be used to search a sequence for a subsequence. 
* To use it simply pass any BCSequence object to the initializer or class method.
* Then call the findSequence: method and pass the sequence to search for. The class will
* return an NSArray containing NSRanges where all subsequences have been found.

* The search can be influenced in two ways:
* When the BOOL strict is set to NO, the search will include ambigous symbols
* When the BOOL firstOnly is set to YES, only the first occurance of the subsequence is returned.
*/

@interface BCToolSequenceFinder : BCSequenceTool
{
	BCSequence	*searchSequence;
	NSRange			searchRange;
	BOOL			strict;
	BOOL			firstOnly;
}

+ (BCToolSequenceFinder *) sequenceFinderWithSequence: (BCSequence *)list;

- (BCSequence *)searchSequence;
- (void)setSearchSequence:(BCSequence *)list;

- (NSRange)searchRange;
- (void)setSearchRange:(NSRange)aRange;

- (void)setStrict: (BOOL)value;
- (void)setFirstOnly: (BOOL)value;

- (BOOL)compareSymbol: (BCSymbol *)first withSymbol: (BCSymbol *) second;
- (NSArray *)findSequence: (BCSequence *)entry;

@end
