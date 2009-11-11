//
//  BCSequenceCodon.h
//  BioCocoa
//
//  Created by John Timmer on 9/17/04.
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
@abstract Provides in-memory representations of DNA or RNA based codons.
*/

#import <Foundation/Foundation.h>
#import "BCSequence.h"

/*!
    @class          BCSequenceCodon
    @abstract       Wrapper for an ordered array of BCCodons, either DNA- or RNA-based
    @discussion     A subclass of BCSequence, this class handles access to an ordered list 
    *   of BCCodons.  In addition to the usual BCSequence objects, it contains references to the 
    *   genetic code used to generate the BCSequenceCodon, and the reading frame as a string 
    *   (ie - +1, -2).  Typically, BCCodonSequences are not created directly, but via the BCUtilTranslator
    *   class methods.
*/

@interface BCSequenceCodon : BCSequence {
    BCGeneticCodeName   usedCode;
    NSString            *readingFrame;
}


#if 0
#pragma mark == INITIALIZATION METHODS ==
#endif

/*!
@method     initWithCodonArray:geneticCode:frame:
 @abstract   Designated class initializer.  Arguments should be self explanatory.
	@discussion This is the designated initializer: other initializers call this method.
	* The designated initializer is thus different from the superclass.
	* It calls the designated initializer for the superclass.
 */
- (id)initWithCodonArray:(NSArray *)anArray geneticCode: (BCGeneticCodeName)codeType frame: (NSString *)theFrame;

/*!
	@method     initWithString:skippingUnknownSymbols:
	@abstract   initializes a BCSequenceCodon object by passing it an NSString.
	@discussion  The implementation overrides the superclass. If skipFlag 
	* is YES, any character that cannot be converted to a BCNucleotideDNA object is eliminated
	* from the final symbolArray.  Otherwise, they are replaced by "undefined" symbols.
	* As codons cannot be easily represented as single characters, this method attempts to determine if 
	* the sequence is likely to be RNA (no T's, U's present), and creates a BCSequenceRNA from it if so.  If not,
	* it creates a BCSequence.  Once a sequence is made, it sends it for translation,
	* and the returned codon array is sent to the designated initializer
	* 'initWithCodonArray:geneticCode:frame:'
*/
- (id)initWithString:(NSString *)aString skippingUnknownSymbols:(BOOL)skipFlag;

///*!
//	@method     - (id)initWithSymbolArray:(NSArray *)anArray
//	@abstract   initializes a BCSequenceCodon object by passing it an NSArray of BCSymbol.
//	@discussion The implementation overrides the superclass.
//	* This method scans the passed array for all BCSymbol objects, and creates
//	* a new BCSequence using them. Once a sequence is made, it sends it for translation,
//	* and the returned codon array is sent to the designated initializer
//	* 'initWithCodonArray:geneticCode:frame:'
//*/
//- (id)initWithSymbolArray:(NSArray *)anArray;


/*!
    @method     initWithCodonArray:
    @abstract   nitializes a BCSequenceCodon object by passing it an array of BCCodon objects
    @discussion Scans the provided array for BCSequenceCodons and adds them to the resulting sequence.  
    *   If the first codon is RNA, it will assume a BCUnversalCodeRNA origin, otherwise the DNA version.
    *   The reading frame is assumed to be +1.
*/
- (id)initWithCodonArray:(NSArray *)anArray;


/*!
	@method     sequenceWithCodonArray:
	@abstract   creates and returns an autoreleased BCSequenceCodon object initialized with the codon array passed as argument
*/
+ (BCSequenceCodon *)sequenceWithCodonArray:(NSArray *)anArray;

- (BCSequence *)translate;

#if 0
#pragma mark == ORF/TRANSLATION METHODS ==
#endif


/*!
    @method     longestOpenReadingFrame
    @abstract   returns the longest stretch of codons that don't code for a stop or undefined aa.
*/
- (NSRange) longestOpenReadingFrame;

/*!
    @method     longestOpenReadingFrameUsingStartCodon:
    @abstract   returns the longest stretch of codons that starts with (codon) and doesn't contain a stop or undefined aa.
    @discussion the start codon argument can be provided as a single BCCodon or as an array of codons, for situations/sepcies
    *   where there is more than one start codon.  
*/
- (NSRange) longestOpenReadingFrameUsingStartCodon: (id)codon;


/*!
    @method     openReadingFramesLongerThanCutoff:
    @abstract   returns all open reading frames longer than the supplied cutoff
    @discussion The return array contains NSValues, coding for NSRanges.  if no open reading
    *   frames are found, it will return an empty array.  Note the BioCocoa provides a method
    *   in BCUtilValueAdditions that allows the sorting of these values based on the range length.
*/
- (NSArray *) openReadingFramesLongerThanCutoff: (unsigned int)cutoff;

/*!
    @method     openReadingFramesLongerThanCutoff:usingStartCodon:
    @abstract   behaves identically to "openReadingFramesLongerThanCutoff:", but requires a start codon to initiate the ORF
*/
- (NSArray *) openReadingFramesLongerThanCutoff: (unsigned int)cutoff usingStartCodon: (id)codon;


/*!
    @method     translationOfRange:
    @abstract   provides a protein sequence code for by the sub-sequence of codons within theRange
    @discussion This method will terminate short of the end of theRange if a stop codon or an undefined codon
    *   is encountered
*/
- (BCSequence *) translationOfRange: (NSRange) theRange;


/*!
    @method     translationOfRange:usingStartCodon:
    @abstract   behaves identically to "translationOfRange:" but requires a start codon to initiate translation
*/
- (BCSequence *) translationOfRange: (NSRange) theRange usingStartCodon: (id)codon;


/*!
    @method     translationsLongerThanCutoff:
    @abstract   provides an array of BCSequences encoded by the receiver which are longer than cutoff
*/
- (NSArray *) translationsLongerThanCutoff: (unsigned int)cutoff;


/*!
    @method     translationsLongerThanCutoff:usingStartCodon:
    @abstract   behaves identically to "translationsLongerThanCutoff:", but requires a start codon to initiate translation
*/
- (NSArray *) translationsLongerThanCutoff: (unsigned int)cutoff usingStartCodon: (id)codon;




#if 0
#pragma mark == BASIC INFO ==
#endif

/*!
    @method     usedCode
    @abstract   returns the genetic code used to generate the codon sequence
 */
- (BCGeneticCodeName) usedCode;


/*!
    @method     readingFrame
    @abstract   returns the reading frame ("+2", "-1", etc.) used to generate the codon sequence
*/
- (NSString *)readingFrame;


/*!
    @method     convertRangeToOriginalSequence:
    @abstract   converts a range in the codon sequence to the equivalent range in the coding sequence
    @discussion in many cases, the ranges of locations in a codon sequence (ie - ORF locations) need to be
    *   located in the coding sequence of DNA or RNA bases.  This method should allow the ranges generated by
    *   methods in this class to be converted to the equivalent ranges for use with BCSequence or RNA classes.
    *   The method accounts for reading frame.
*/
- (NSRange) convertRangeToOriginalSequence: (NSRange)entry;

@end
