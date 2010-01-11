//
//  BCSequence.h
//  BioCocoa
//
//  Created by Koen van der Drift on 12/14/2004.
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
@abstract Provides in-memory representations of biological sequence (DNA, protein, etc.).
*/

#import <Foundation/Foundation.h>
#import "BCFoundationDefines.h"

@class BCSymbol;
@class BCSymbolSet;
@class BCAnnotation;


/*!
    @class      BCSequence
    @abstract   Class that holds a biological sequence (DNA, protein, etc.)
    @discussion This class is used for all types of sequences. The sequence type
	* is determined by the symbolset, which defines the BCSymbols that are allowed
	* to be in the sequence. Compare this to NSString, where the encoding determines the
	* type of string that is inside the NSString object.
*/

@interface BCSequence : NSObject <NSCopying>
{
	NSData				*sequenceData;		// holds a char array with the sequence string
	BCSymbolSet			*symbolSet;			// determines the BCSymbols that can be in this sequence
    NSArray				*symbolArray;		// array of BCSymbol objects to represent the sequence
	NSMutableDictionary	*annotations;		// annotations fot this sequence
	BCSequenceType		sequenceType;		// defines the sequence type 
}


#if 0
#pragma mark == INITIALIZATION METHODS ==
#endif


/*!
@method      initWithSymbolArray:symbolSet:
 @abstract   initializes a BCSequence object by passing it an NSArray of BCSymbol.
 @discussion
 * The method scans the passed array for all BCSymbol objects, and creates
 * a new BCSequence using them. The symbol set is used to filter the passed symbols.
 * The symbol set instance should be the same sequence type as the sequence, e.g. should
 * contain DNA symbols if used to initialize a DNA sequence. If not the right sequence type,
 * or if the symbolSet is nil, then the implementation guesses the most likely
 * symbolSet based on the symbols in the array.
 */
- (id)initWithSymbolArray:(NSArray *)anArray symbolSet:(BCSymbolSet *)aSet;

/*!
@method      initWithData:symbolSet:
 @abstract   initializes a BCSequence object by passing it an NSData of symbols.
 @discussion
 * The method scans the passed data for all BCSymbol objects, and creates
 * a new BCSequence using them. The symbol set is used to filter the passed symbols.
 * The symbol set instance should be the same sequence type as the sequence, e.g. should
 * contain DNA symbols if used to initialize a DNA sequence. If not the right sequence type,
 * or if the symbolSet is nil, then the implementation guesses the most likely
 * symbolSet based on the symbols in the array.
 */
- (id)initWithData:(NSData *)aData symbolSet:(BCSymbolSet *)aSet;


/*!
@method      initWithSymbolArray:
 @abstract   initializes a BCSequence object by passing it an NSArray of BCSymbol.
 @discussion This method calls '-initWithSymbolArray:symbolSet'
 * using the default symbol set for the class.
 * The method scans the passed array for all BCSymbol objects compatible with the
 * type of sequence being created.
 */
- (id)initWithSymbolArray:(NSArray *)anArray;


/*!
@method      initWithString:symbolSet:
 @abstract   initializes a BCSequence object by passing it an NSString.
 @discussion This is the designated initializer.
 * This method will attempt to create an array of BCSymbols using the
 * characters found in the string.
 * The BCSymbols created will depend on the symbol set passed as argument.
*/
- (id)initWithString:(NSString *)aString symbolSet:(BCSymbolSet *)aSet;


/*!
    @method     initWithString:
 @abstract   initializes a BCSequence object by passing it an NSString.
 @discussion This method calls initWithString:symbolSet:
 * using the default symbol set of the class as argument.
 * The method should only be called on a concrete subclass.
 * This method will create an array of BCSymbols using the
 * characters found in the string. The type of BCSymbols created
 * will depend on the the sequence type, e.g. a DNA sequence
 * will only use DNA bases.
*/
- (id)initWithString:(NSString*)aString;


/*!
    @method     initWithString:range:
    @abstract   initializes a BCSequence object by passing it an NSString and a range.
    @discussion This method calls '-initWithString:'. Note that the range is 0-based.
*/
- (id)initWithString:(NSString*)aString range:(NSRange)aRange;

/*!
	@method     initWithString:symbolSet:
	@abstract   initializes sequence object with the string passed as argument
	@discussion This method calls 'initWithString:symbolSet:'.
 */
- (id)initWithString:(NSString*)aString range:(NSRange)aRange symbolSet:(BCSymbolSet *)aSet;

/*!
	@method     initWithThreeLetterString:symbolSet:
	@abstract   initializes sequence object with a three-letter code string passed as argument
*/
- (id)initWithThreeLetterString:(NSString*)aString symbolSet:(BCSymbolSet *)aSet;

/*!
    @method     sequenceWithString:
	@abstract   creates and returns an autoreleased sequence object initialized with the string passed as argument
	@discussion This method calls 'initWithString:'
*/
+ (BCSequence *)sequenceWithString:(NSString *)aString;

/*!
	@method     sequenceWithString:symbolSet:
	@abstract   creates and returns an autoreleased sequence object initialized with the string passed as argument
	@discussion This method calls 'initWithString:symbolSet:'.
 */
+ (BCSequence *)sequenceWithString:(NSString *)aString symbolSet:(BCSymbolSet *)aSet;

/*!
	@method     sequenceWithThreeLetterString:symbolSet:
	@abstract   creates and returns an autoreleased sequence object initialized with a three-letter code string passed as argument
	@discussion This method calls 'initWithString:symbolSet:'.
*/
+ (BCSequence *)sequenceWithThreeLetterString:(NSString *)aString symbolSet:(BCSymbolSet *)aSet;

	/*!
    @method     sequenceWithSymbolArray:
    @abstract   creates and returns an autoreleased sequence object initialized with the array of BCSymbols passed as argument
	@discussion This method calls 'initWithSymbolArray:'
*/
+ (BCSequence *)sequenceWithSymbolArray:(NSArray *)entry;

/*!
    @method     sequenceWithSymbolArray:
    @abstract   creates and returns an autoreleased sequence object initialized with the array of BCSymbols passed as argument
	@discussion This method calls 'initWithSymbolArray:symbolSet'
*/
+ (BCSequence *)sequenceWithSymbolArray:(NSArray *)entry symbolSet: (BCSymbolSet *)aSet;

/*!
    @method     objectForSavedRepresentation:
    @abstract   Returns a BCSequence object representing the sequence submitted 
    @discussion all BC classes should implement a "savableRepresentation" and an 
    *  "objectForSavedRepresentation" method to allow archiving/uncarchiving in
    *  .plist formatted files.
*/
+ (BCSequence *)objectForSavedRepresentation:(NSString *)sequence;

/*!
    @method    convertThreeLetterStringToOneLetterString:symbolSet:
	@abstract  Converts a 3-letter code string to a 1-letter code string 
*/
- (NSString *)convertThreeLetterStringToOneLetterString:(NSString *)aString symbolSet: (BCSymbolSet *)aSet;


#if 0
#pragma mark == SEQUENCE TYPE DETERMINATION ==
#endif


/*!
    @method     sequenceTypeForString:
	@abstract   Returns the guessed sequence type of an arbitrary string.
*/
- (BCSequenceType)sequenceTypeForString:(NSString *)string;

/*!
    @method     sequenceTypeForData:
	@abstract   Returns the guessed sequence type from sequence data.
*/
- (BCSequenceType)sequenceTypeForData:(NSData *)aData;

/*!
    @method     sequenceTypeForSymbolArray:
	@abstract   Returns the guessed sequence type of an array of BCSymbols.
*/
- (BCSequenceType)sequenceTypeForSymbolArray:(NSArray *)anArray;



#if 0
#pragma mark == OBTAINING SEQUENCE INFORMATION ==
#endif


/*!
    @method     sequenceData
    @abstract   returns and NSData object containing the sequenceData
*/
- (NSData *) sequenceData;


/*!
    @method     bytes;
    @abstract   returns the raw bytes representing the sequence
*/
- (const unsigned char *) bytes;


/*!
    @method     symbolSet
    @abstract   returns the symbolSet associated with this sequence
*/
- (BCSymbolSet *) symbolSet;

/*!
	@method     setSymbolSet:
	@abstract   sets the symbolSet associated with this sequence
*/
- (void) setSymbolSet:(BCSymbolSet *)symbolSet;



/*!
    @method     sequenceType
    @abstract   returns the type of sequence
*/
- (BCSequenceType) sequenceType;


/*!
@method     length
@abstract   returns the length of the sequence
*/
- (unsigned int) length;


/*!
    @method     symbolAtIndex:
    @abstract   returns the BCSymbol object at index.  Returns nil if index is out of bounds.
*/
- (BCSymbol *)symbolAtIndex: (int)theIndex;




/*!
    @method     containsAmbiguousSymbols
    @abstract   determines whether any symbols in the sequence are compound symbols.
*/
- (BOOL) containsAmbiguousSymbols;


/*!
    @method     sequenceString
    @abstract   returns the sequence string of the object.
    @discussion returns an NSString containing a one letter-code string of the sequence.
	* This method is useful when the sequence needs to be displayed in a view.
*/
- (NSString*)sequenceString;


/*!
    @method    symbolArray
      @abstract   returns a ponter to the array of BCSymbol objects that make up the sequence.
      @discussion The array returned is the object used internally by BCSequence.
	  * The array obtained should only be used for reading, and should not be modified by the caller.	 
      * To modify the sequence, instead use one of the
	  * convenience methods setSymbolArray, removeSymbolsInRange, removeSymbolsAtIndex,
	  * or insertSymbolsFromSequence:atIndex. 
*/
- (NSArray *)symbolArray;


/*!
    @method    clearSymbolArray
    @abstract   clears the symbol array
    @discussion Removes all symbols from the symbol array and sets the array to nil.
    *   Call this method first to re-generate the symbolArray after the sequence has been modified.
*/
- (void)clearSymbolArray;

/*!
    @method    subSequenceStringInRange:
    @abstract   returns a subsequence in string form
    @discussion returns an NSString containing a subsequence specified by aRange (0-based).
    *   Returns nil if any part of aRange is out of bounds.
*/
- (NSString *)subSequenceStringInRange:(NSRange)aRange;

/*!
    @method    sequenceStringFromSymbolArray:
    @abstract   returns an NSString representation of a symbolArray
*/
- (NSString *)sequenceStringFromSymbolArray:(NSArray *)anArray;

/*!
    @method    subSymbolArrayInRange:
    @abstract   returns a sub-symbolarray form
    @discussion returns an NSArray containing a subsequence specified by aRange (0-based).
    *   Returns nil if any part of aRange is out of bounds.
*/
- (NSArray *)subSymbolArrayInRange:(NSRange)aRange;

/*!
    @method    subSequenceInRange:
    @abstract   returns a sub-symbollist
    @discussion returns an BCSequence containing a sub-symbollist specified by aRange (0-based).
    *   Returns nil if any part of aRange is out of bounds.
*/
- (BCSequence *)subSequenceInRange:(NSRange)aRange;


/*!
     @method     savableRepresentation
     @abstract   Returns the sequenceString for saving.
     @discussion All BCSymbol classes implement this method to provide a standard way of
     *  accessing their data in a format that can be stored in Apple .plist files within
     *  arrays or dictionaries.
*/
- (NSString *) savableRepresentation;


/*!
     @method     description
     @abstract   Overrides NSObject's description - describes the object in string form
     @discussion In the default implementation, returns the sequence string.  Useful primarily
     *  for debugging.
*/
- (NSString *) description;

/*!
    @method     addAnnotation:
    @abstract   Add a BCAnnotation object to the annotations dictionary
*/

- (void) addAnnotation:(BCAnnotation *)annotation;
/*!
    @method     addAnnotation:forKey:
    @abstract   Add an annotation to the annotations dictionary
    @discussion Using two strings for the key and value, this method adds an annotation
*/
- (void) addAnnotation:(NSString *)annotation forKey: (NSString *) key;

/*!
    @method     annotationForKey:
    @abstract   Get the annpotation for a specific key
    @discussion Returns the annotation for a given key, which is passed as an NSString
*/
- (id) annotationForKey: (NSString *) key;

/*!
    @method      annotations
    @abstract   Returns the annotations dictionary
*/
- (NSMutableDictionary *) annotations;

/*!
    @method     setAnnotations:
    @abstract   Set the annotations dictionary
    @discussion This will completely replace the current annotations dictaionry. All key-value pairs will be lost
	* and replaced by those in the new dictionary.
*/
//- (void)setAnnotations:(NSMutableDictionary *)aDict;


#if 0
#pragma mark == MANIPULATING THE SEQUENCE ==
#endif


/*!
    @method    setSymbolArray:
    @abstract   sets the symbollist as an array of BCSymbol objects.
*/
- (void)setSymbolArray:(NSArray *)anArray;


/*!
    @method   removeSymbolsInRange:
    @abstract   deletes a sub-symbollist.
    @discussion deletes the BCSymbols in the sub-symbollist specified by aRange (0-based).
*/
- (void)removeSymbolsInRange:(NSRange)aRange;


/*!
    @method   removeSymbolAtIndex:
    @abstract   deletes one symbol.
    @discussion deletes a BCSymbol located at index (0-based).
*/
- (void)removeSymbolAtIndex:(int)index;


/*!
    @method   insertSymbolsFromSequence:atIndex:
    @abstract   inserts a BCSequence into the current symbolarray, starting at index (0-based)
    @discussion inserts the BCSequence that is in the first argument in the current BCSequence.
*/
- (void)insertSymbolsFromSequence:(BCSequence *)seq atIndex:(int)index;



#if 0
#pragma mark == DERIVING RELATED SEQUENCES ==
#endif


/*!
    @method     reverse
	@abstract   returns a BCSequence that is the reverse of the one queried.
*/
- (BCSequence *) reverse;


/*!
    @method     complement
	@abstract   returns a BCSequence that is the complement of the one queried.
    @discussion This is a convenience method that calls BCToolComplement.
*/
- (BCSequence *) complement;


/*!
    @method     reverseComplement
	@abstract   returns a BCSequence that is the reverse complement of the one queried.
    @discussion This is a convenience method that calls BCToolComplement.
*/
- (BCSequence *) reverseComplement;


#if 0
#pragma mark == FINDING SUBSEQUENCES ==
#endif


- (NSArray *) findSequence: (BCSequence *) entry;
- (NSArray *) findSequence: (BCSequence *) entry usingStrict: (BOOL) strict;
- (NSArray *) findSequence: (BCSequence *) entry usingStrict: (BOOL) strict firstOnly: (BOOL) firstOnly;
- (NSArray *) findSequence: (BCSequence *) entry usingStrict: (BOOL) strict firstOnly: (BOOL) firstOnly usingSearchRange: (NSRange) range;

@end
