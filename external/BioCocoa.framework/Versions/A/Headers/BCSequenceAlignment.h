//
//  BCSequenceAlignment.h
//  BioCocoa
//
//  Created by Philipp Seibel on 09.03.05.
//  Copyright (c) 2005 The BioCocoa Project. All rights reserved.
//
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
@abstract Provides alignment of sequences.
*/

#import <Foundation/Foundation.h>
#import "BCSequence.h"
#import "BCScoreMatrix.h"

@class BCSymbolSet, BCAnnotation;


/*!
@class      BCSequenceAlignment
@abstract   Represents an alignment of BCSequences
@discussion 
*/

@interface BCSequenceAlignment : NSObject {
  NSArray *sequenceArray;
}

- (id)initWithSequenceArray:(NSArray *)theSequenceArray;

@end

/*!
 @category BCSequenceAlignment(AlignmentQuerying)
 @abstract Obtain sequence alignment information
*/

@interface BCSequenceAlignment ( AlignmentQuerying )

/*!
@method     sequenceAtIndex:
@abstract   obtaining the BCSequence at the given index
@discussion 
*/
- (BCSequence *)sequenceAtIndex:(unsigned int)aIndex;

/*!
@method     alignmentInRange:
@abstract   returns a subalignment
@discussion 
*/
- (BCSequenceAlignment *)alignmentInRange:(NSRange)aRange;

/*!
@method     symbolsForColumnAtIndex:
@abstract   returns a NSArray containing the symbols at the given alignment column
@discussion 
*/
- (NSArray *)symbolsForColumnAtIndex:(unsigned int)aColumn;

/*!
@method     length
@abstract   obtaining the length of the alignment
@discussion 
*/
- (unsigned int)length;

- (unsigned int)sequenceCount;

/*!
@method     symbolSet
@abstract   obtaining the BCSymbolSet corresponding to the aligned BCSequences
@discussion 
*/
- (BCSymbolSet *)symbolSet;

@end

/*!
 @category BCSequenceAlignment(AlignmentAnnotation)
 @abstract sequence alignment annotations
*/
@interface BCSequenceAlignment ( AlignmentAnnotation )

/*!
@method     annotationForKey:
@abstract   obtaining the BCAnnotation for the given key
@discussion 
*/
- (BCAnnotation *)annotationForKey:(NSString *)theKey;

@end


/*!
 @category BCSequenceAlignment(PairwiseAlignment)
 @abstract perform pairwise sequence alignment
*/
@interface BCSequenceAlignment ( PairwiseAlignment )

/*!
@method     needlemanWunschAlignmentWithSequences:properties:
@abstract   perform Needleman-Wunsch pairwise sequence alignment
@discussion 
*/
+ (BCSequenceAlignment *)needlemanWunschAlignmentWithSequences:(NSArray *)theSequences properties:(NSDictionary *)properties;

/*!
@method     smithWatermanAlignmentWithSequences:properties:
@abstract   perform Smith-Waterman pairwise sequence alignment
@discussion 
*/
+ (BCSequenceAlignment *)smithWatermanAlignmentWithSequences:(NSArray *)theSequences properties:(NSDictionary *)properties;

@end


