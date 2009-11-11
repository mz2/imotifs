//
//  BCSymbolSet.h
//  BioCocoa
//
//  Created by Alexander Griekspoor on Fri Sep 10 2004.
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
@abstract A collection of BCSymbols of the same type.
*/

#import <Foundation/Foundation.h>
#import "BCFoundationDefines.h"

@class BCSymbol;

/*!
@class      BCSymbolSet
@abstract   A collection of BCSymbols of the same type
@discussion BCSymbolSet objects provide a lot of flexibility for the user
* of the framework when creating and manipulating sequence objects.
* They can be thought of as filters, by restricting a sequence object
* to a certain set of symbols. For instance, a dna sequence could be
* created that will only accept the non-ambiguous bases A, T, G, C
* but not the compound symbols like P and Y.
* 
* BCSymbolSet objects are immutable. The class object provides a number
* of factory methods for prebuilt symbol sets such as 
* '+ (BCSymbolSet *)dnaSymbolSet' and '+ (BCSymbolSet *)dnaStrictSymbolSet'.
* It is recommanded to use these methods when creating a symbol set
* supported by the class. For other cases, a new BCSymbolSet can easily
* be created from an array of symbols, or by combining existing symbol sets.
* Because BCSymbolSet are immutable, new objects have to be created to
* modify existing symbol sets.
*/


@interface BCSymbolSet : NSObject <NSCopying>
{
	NSSet	*symbolSet;
	BCSequenceType	sequenceType;
}
	
#if 0
#pragma mark == INITIALIZATION METHODS ==
#endif

/*!
@method     initWithArray:sequenceType:
@abstract   initialize symbol set with an array of symbols and a sequence type
@discussion Designated initializer.
*/
- (id)initWithArray:(NSArray *)symbols sequenceType:(BCSequenceType)type;

/*!
@method     initWithArray:
@abstract   initialize symbol set with an array of symbols
@discussion Decides the sequence type based on the first symbol in the passed array.
*/
- (id)initWithArray:(NSArray *)symbols;

/*!
@method     initWithString:sequenceType:
@abstract   initialize symbol set with an array of symbols and a sequence type
@discussion Initializes the symbol sets using a string, by scanning the characters
	and generating symbols of the right sequence type
	e.g. A --> Adenosine if sequence type is DNA, Alanine if protein
*/
- (id)initWithString:(NSString *)stringOfCharacters sequenceType:(BCSequenceType)type;

//factory methods - return an autoreleased object
+ (BCSymbolSet *)symbolSetWithArray:(NSArray *)symbols;
+ (BCSymbolSet *)symbolSetWithArray:(NSArray *)symbols sequenceType:(BCSequenceType)type;
+ (BCSymbolSet *)symbolSetWithString:(NSString *)aString sequenceType:(BCSequenceType)type;

+ (BCSymbolSet *)symbolSetForSequenceType:(BCSequenceType)type;


#if 0
#pragma mark == FACTORY METHODS FOR PREBUILT SETS ==
#endif

+ (BCSymbolSet *)dnaSymbolSet;
+ (BCSymbolSet *)dnaStrictSymbolSet;
+ (BCSymbolSet *)rnaSymbolSet;
+ (BCSymbolSet *)rnaStrictSymbolSet;
+ (BCSymbolSet *)proteinSymbolSet;
+ (BCSymbolSet *)proteinStrictSymbolSet;
+ (BCSymbolSet *)unknownSymbolSet;
+ (BCSymbolSet *)unknownAndGapSymbolSet;


#if 0
#pragma mark == GENERAL METHODS ==
#endif


- (NSSet *)symbolSet;
- (NSArray *)allSymbols;
- (NSCharacterSet *)characterSetRepresentation;
- (NSString *)stringRepresentation;
- (BCSequenceType)sequenceType;

- (BOOL)containsCharactersFromString: (NSString *) aString;

- (BOOL)containsSymbol:(BCSymbol *)aSymbol;	// aSymbol=W and contains A --> no
- (BOOL)containsSymbolRepresentedBy:(BCSymbol *)aSymbol; // aSymbol=W and contains A --> yes
- (BOOL)containsAllSymbolsRepresentedBy:(BCSymbol *)aSymbol; // aSymbol=W and contains A,T --> yes
- (BOOL)containsSymbolRepresenting:(BCSymbol *)aSymbol; // aSymbol=A and contains W --> yes

//creating new symbol sets from existing ones
- (BCSymbolSet *)symbolSetByFormingUnionWithSymbolSet:(BCSymbolSet *)otherSet;
- (BCSymbolSet *)symbolSetByFormingIntersectionWithSymbolSet:(BCSymbolSet *)otherSet;


/* TO DO (or not to do?)
- (BCSymbolSet *)complementSet;
- (BCSymbolSet *)expandedSet; // ambigous symbols expanded
*/

- (BOOL)isSupersetOfSet:(BCSymbolSet *)theOtherSet;

//filtering an array of symbols
//returned array = without the unknown symbols
- (NSArray *)arrayByRemovingUnknownSymbolsFromArray:(NSArray *)anArray;
- (NSString *)stringByRemovingUnknownCharsFromString:(NSString *)aString;
- (NSData *)dataByRemovingUnknownCharsFromData:(NSData *)aData;

//returns nil if symbol unknown
- (BCSymbol *)symbolForChar:(unsigned char)aChar;

//NSCopying formal protocol
- (id)copyWithZone:(NSZone *)zone;


//BCSymbolSet is immutable
//Keep this for a future BCMutableSymbolSet, if ever needed
/* 
////////////////////////////////////////////////////////////////////////////
//
#pragma mark ‚ 
#pragma mark ‚MUTABILITY METHODS
//
//  MUTABILITY METHODS
////////////////////////////////////////////////////////////////////////////

- (void)addSymbol:(BCSymbol *)symbol;
- (void)addSymbols:(NSArray *)symbols;
- (void)addSymbolsInString:(NSString *)aString;
- (void)removeSymbol:(BCSymbol *)symbol;
- (void)removeSymbols:(NSArray *)symbols;
- (void)removeSymbolsInString:(NSString *)aString;

- (void)formUnionWithSymbolSet:(BCSymbolSet *)otherSet;
- (void)formIntersectionWithSymbolSet:(BCSymbolSet *)otherSet;
- (void)makeComplementary;
*/

@end

