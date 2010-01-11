//
//  BCToolSequenceFinder.h
//  BioCocoa
//
//  Created by Koen van der Drift on 10/28/04.
//  Copyright (c) 2003-2009 The BioCocoa Project.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. The name of the author may not be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
