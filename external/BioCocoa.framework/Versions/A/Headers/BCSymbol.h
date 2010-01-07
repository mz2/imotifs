//
//  BCSymbol.h
//  BioCocoa
//
//  Created by Koen van der Drift on Sun Aug 15 2004.
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
@abstract Provides symbol representation of individual sequence elements (nucleotide, amino acid, etc.).
*/

#import <Foundation/Foundation.h>
#import "BCFoundationDefines.h"

@class BCSymbolSet;

/*!
    @class      BCSymbol
    @abstract   Superclass of all individual sequence elements (nucleotide, amino acid, etc.)
    @discussion This class should not be instantiated, but acts to provide some common methods
    * and variables that are used by all subclasses.
*/

@interface BCSymbol : NSObject <NSCopying>
{
    unsigned char	symbolChar;
    NSString		*name;
    NSString		*symbolString;
    NSDictionary	*symbolInfo;
    NSSet			*represents;
    NSSet			*representedBy;

	float			monoisotopicMass;
	float			averageMass;
}

#if 0
#pragma mark == INITIALIZATION METHODS ==
#endif

/*!
    @method     initWithSymbolChar:
    @abstract   initializes a BCSymbol object using a single character.
    @discussion This method does nothing else, it only sets the symbol. 
    * It's the subclass responsibility to setup all other variables
*/
- (id)initWithSymbolChar:(unsigned char)aChar;

/*!
    @method     initializeSymbolRelationships
    @abstract   converts string-based selectors to symbol references
    @discussion After the initialization above, internal references to other symbols 
 *  (complement, representations, etc.) remain in string-based selector form.  The first time
 *  the actual reference is needed, this method will use the selectors to generate the actual
 *  references to the symbols.
*/
- (void) initializeSymbolRelationships;


#if 0
#pragma mark == OBJECT METHODS ==
#endif



/*!
    @method     name
    @abstract   returns the chemical name of the object.
    @discussion returns the common chemical name for the represented object.
    *  For a nucleotide with a symbol of 'A', this will return "Adenosine", while
    *  for an amino acid with that symbol, it will return "Alanine".
*/
- (NSString *)name;


/*!
    @method     symbolChar
    @abstract   returns the one letter symbol for the object
    @discussion Provides a unicode character symbol that represents the object.  
    *  These are the standard representations:  nucleotides are ATCGNYR etc., amino acids
    *  are ACDEF etc.  Stop codons are represented with *, and gaps are represented with -.
    *  If non-symbol items are allowed, they are represented by a ?.
*/
- (unsigned char) symbolChar;


/*!
    @method     symbolString
    @abstract   returns the symbol as a single character string.
    @discussion The behavior is identical to that for the "symbol" method above, except the
    *  value returned is an NSString, and so can be readily saved, appended to strings, etc.
*/
- (NSString *)symbolString;


/*!
    @method     savableRepresentation
    @abstract   Returns the symbol string of the object.
    @discussion All BCSymbol classes implement this method to provide a standard way of
    *  accessing their data in a format that can be stored in Apple .plist files within
    *  arrays or dictionaries.  Subclasses should provide a method of converting this information
    *  back into the appropriate Symbol object.
*/
- (NSString *) savableRepresentation;


/*!
    @method     description
    @abstract   Overrides NSObject's description - describes the object in string form
    @discussion In the default implementation, returns the name of the object.  Useful primarily
    *  for debugging.
*/
- (NSString *) description;




/*!
    @method     symbolInfo
    @abstract   Returns the dictionary that was used to initialize the symbol information
    @discussion The default set of symbols (bases and amino acids) are generated from information stored in a .plist
    *  file in dictionary form.  Upon initialization, each symbol retrieves and retains this dictionary, which is
    *  accessible by this method.  Use of this method should be avoided; rather, use "valueForKey" to retrieve information
    *  about a symbol from this dictionary.
*/
- (NSDictionary	*) symbolInfo;


/*!
    @method     valueForKey:
    @abstract   Retrieves a value from the symbolInfo dictionary
    @discussion The default set of symbols (bases and amino acids) are generated from information stored in dictionary form
    *  in a .plist file.  Upon initialization, each symbol retrieves and retains this dictionary.  Most, if not all,
    *  of the values in this dictionary (ie - monoisotopicMass) are accessible through defined methods.  This method may
    *  be used to retrieve those values which do not have specified methods.  It returns nil if the  key is not used.
    *  For a list of valid keys and their defined equivalents, check the file "BCStringDefinitions" or the .plist files
    *  in the "Symbol Templates" folder.
    *
    *  This method is primarily designed to allow rapid addition of features to the symbols which are the foundation of
    *  BioCocoa via editing of the included .plist files (in the "Symbol Templates" folder), rather than by code.
    *
    *  NB - the valid keys in this dictionary may vary between releases of BioCocoa, and returned values should not be 
    *  assumed to be non-nil.
*/
- (id) valueForKey: (NSString *)aKey;

/*!
    @method     setValue:forKey:
    @abstract   Non-functional method present for key-value coding compliance.
    @discussion The symbolInfo dictionary with which symbols are initialized is non-mutable in order to maintain these 
    *  objects in an internally consistent state.  Therefore, this method cannot actually change values in this 
    *  dictionary.  It is included only to allow Symbols to be key-value coding compliant.
*/
- (void) setValue: (id)aValue forKey: (NSString *)theKey;
    
    


/*!
    @method     monoisotopicMass
    @abstract   Returns a float value containing the monoisotopic mass for this BCSymbol
    @discussion The monoisotopic mass is the mass calculated using the first
	* isotope of each element (eg 12C, 14N, 16O, etc)
*/
- (float)monoisotopicMass;

/*!
    @method     setMonoisotopicMass:
    @abstract   Set the monoisotopic mass for this BCSymbol.
    @discussion The monoisotopic mass is the mass calculated using the first
	* isotope of each element (eg 12C, 14N, 16O, etc)
*/
- (void)setMonoisotopicMass:(float)value;

/*!
    @method     averageMass
    @abstract   Returns a float value containing the average mass for this BCSymbol
    @discussion The average mass is the mass calculated averaging over all
	* isotopes of each element.
*/
- (float)averageMass;

/*!
    @method     setAverageMass:
    @abstract   Set the average mass for this BCSymbol.
    @discussion The average mass is the mass calculated averaging over all
	* isotopes of each element.
*/
- (void)setAverageMass:(float)value;

/*!
    @method     massUsingType:
    @abstract   Returns the mass of this BCSymbol
    @discussion aType defines if either the monoisotopic or average mass is returned
*/
- (float)massUsingType:(BCMassType) aType;

/*!
    @method     minMassUsingType:
    @abstract   Returns the minimum mass for this BCSymbol
    @discussion This is used for ambiguous symbols which have a mass range, because they are represented
	* by different BCSymbols, each with their own mass. It will return the mass of the BCSymbol
	* with the lowest mass.
	* aType defines if either the monoisotopic or average mass is returned
*/
- (float)minMassUsingType:(BCMassType) aType;

/*!
    @method     maxMassUsingType:
    @abstract   Returns the maximum mass for this BCSymbol
    @discussion This is used for ambiguous symbols which have a mass range, because they are represented
	* by different BCSymbols, each with their own mass. It will return the mass of the BCSymbol
	* with the highest mass.
	* aType defines if either the monoisotopic or average mass is returned
*/
- (float)maxMassUsingType:(BCMassType) aType;



#if 0
#pragma mark == SYMBOL RELATIONSHIP METHODS ==
#endif


/*!
    @method     isCompoundSymbol
    @abstract   indicates if symbol is a compound symbol
*/
- (BOOL)isCompoundSymbol;

- (BOOL)isEqualToSymbol:(BCSymbol *)aSymbol;

/*!
    @method     representedSymbols
    @abstract   returns an array containing all symbols represented by the receiver
    @discussion For instance, when called on adenosine, this method will return an array with a single item, adenosine.
 *  When called on purine, it will return an array with adenosine and guanidine.
*/
- (NSSet *) representedSymbols;

/*!
    @method     representingSymbols
    @abstract   returns an array with all symbols that may represent the receiver
    @discussion For instance, when called on adenosine, this method will return adenosine,
 *  weak, any base, etc.
*/
- (NSSet *) representingSymbols;

/*!
    @method     representsSymbol:
    @abstract   Evaluates whether the receiver represents the entry
    @discussion For instance, when called on adenosine, this method will return YES if the entry is adenosine,
 *  It will return NO for anything else.
 *  When called on weak, will return YES for adenosine and thymidine, but NO for anything else.
*/
- (BOOL) representsSymbol: (BCSymbol *) entry;

/*!
    @method     isRepresentedBySymbol:
    @abstract   Evaluates whether the receiver is represented by the entry
    @discussion For instance, when called on adenosine, this method will return YES if the entry is adenosine,
 *  weak, any base, etc.
*/
- (BOOL) isRepresentedBySymbol: (BCSymbol *) entry;

/*!
    @method     symbolSetWithRepresentedSymbols
    @abstract   Returns a symbol set containing the symbols of all the symbols that are represented by the receiver.
*/
- (BCSymbolSet *)symbolSetOfRepresentedSymbols;

/*!
    @method     symbolSetWithRepresentedSymbols
	 @abstract   Returns a symbol set containing the symbols of all the symbols that represent by the receiver.
*/
- (BCSymbolSet *)symbolSetOfRepresentingSymbols;


@end
