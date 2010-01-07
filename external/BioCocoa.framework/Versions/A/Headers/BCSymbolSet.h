//
//  BCSymbolSet.h
//  BioCocoa
//
//  Created by Alexander Griekspoor on Fri Sep 10 2004.
//  Copyright (c) 2004 The BioCocoa Project. All rights reserved.
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

