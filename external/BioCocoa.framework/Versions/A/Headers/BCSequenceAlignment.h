//
//  BCSequenceAlignment.h
//  BioCocoa
//
//  Created by Philipp Seibel on 09.03.05.
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


