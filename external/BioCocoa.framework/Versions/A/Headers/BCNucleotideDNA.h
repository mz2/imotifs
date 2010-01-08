//
//  BCNucleotideDNA.h
//  BioCocoa
//
//  Created by John Timmer on 8/11/04.
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
@abstract Provides in-memory representations of DNA bases.
*/

#import <Foundation/Foundation.h>
#import "BCNucleotide.h"

@class BCNucleotideRNA;

/*!
    @class BCNucleotideDNA
    @abstract    All DNA bases are handled through this single class
    @discussion  This class provides in-memory representations of DNA bases.
 *  Through class methods and static variables, single application wide representations
 *  of each individual base and the ambiguous base representations are provided to all
 *  BioCocoa applications.  Access to an individual base is provided by methods such as:
 *  [BCNucleotideDNA adenine];
 *  [BCNucleotideDNA purine];
 *  Repesentations of a non-base and gap characters (for alignments) are also available.
 *  Typically, bases are not handled directly, but rather through their container objects,
 *  BCSequence subclasses.
 *  
 *  Why not use strings?
 *  Unicode characters are 16bit, while pointers on MacOS-X are (currently) 32 bit.  In
 *  the overall picture, memory differences are not significant.  In return, each base provides
 *  detailed information about complements, ambiguity, etc. which would otherwise need to be coded
 *  by hand.
 *
 *  Initialization of base data
 *  Details of base information and relationships are read from the "nucleotides.plist" file
 *  within the Framework bundle.  Loss or alteration of this file will cause all DNA-based programs
 *  to fail.  References to other bases (ie - the complement) are retained as string-formatted selectors
 *  until they are needed, at which point they are used to generate pointers to the other bases.
 *  Custom bases can be generated using this file as an example - they remain stored in an NSDictionary.
 *
 *  Individual bases are obtained using their named class method, or by sending an appropriate symbol to the
 *  "symbolForChar:" class method.
*/


@interface BCNucleotideDNA : BCNucleotide
{
}


#if 0
#pragma mark == CLASS METHODS ==
#endif


/*!
    @method     initBases
    @abstract   Used internaly to generate the full set of base objects.   
*/
+ (void) initBases;


/*!
    @method     symbolForChar:
    @abstract   Returns a BCNucleotideDNA item representing the base submitted 
*/
+ (id) symbolForChar: (unsigned char)symbol;


/*!
    @method     objectForSavedRepresentation:
    @abstract   Returns a BCNucleotideDNA object representing the base submitted 
    @discussion all BC classes should implement a "savableRepresentation" and an 
    *  "objectForSavedRepresentation" method to allow archiving/uncarchiving in
    *  .plist formatted files.
*/
+ (id) objectForSavedRepresentation: (NSString *)aSymbol;


/*!
    @method     adenosine
    @abstract   Obtains a reference to the single adenosine representation
*/
+ (BCNucleotideDNA *) adenosine;

/*!
    @method     thymidine
    @abstract   Obtains a reference to the single thymidine representation
*/
+ (BCNucleotideDNA *) thymidine;


/*!
    @method     cytidine
    @abstract   Obtains a reference to the single cytidine representation
*/
+ (BCNucleotideDNA *) cytidine;


/*!
    @method     guanidine
    @abstract   Obtains a reference to the single guanidine representation
*/
+ (BCNucleotideDNA *) guanidine;


/*!
    @method     anyBase
    @abstract   Obtains a reference to the single N representation
*/
+ (BCNucleotideDNA *) anyBase;

/*!
    @method     purine
    @abstract   Obtains a reference to the single purine representation
*/
+ (BCNucleotideDNA *) purine;

/*!
    @method     pyrimidine
    @abstract   Obtains a reference to the single pyrimidine representation
*/
+ (BCNucleotideDNA *) pyrimidine;

/*!
    @method     strong
    @abstract   Obtains a reference to the single strong-bond representation
*/
+ (BCNucleotideDNA *) strong;

/*!
    @method     weak
    @abstract   Obtains a reference to the single weak-bond representation
*/
+ (BCNucleotideDNA *) weak;

/*!
    @method     M
    @abstract   Obtains a reference to the single M (A, C) representation
*/
+ (BCNucleotideDNA *) amino;

/*!
    @method     K
    @abstract   Obtains a reference to the single K (A, C) representation
*/
+ (BCNucleotideDNA *) keto;

/*!
    @method     H
    @abstract   Obtains a reference to the single H (A, C, T) representation
*/
+ (BCNucleotideDNA *) H;

/*!
    @method     V
    @abstract   Obtains a reference to the single V (A, C, G) representation
*/
+ (BCNucleotideDNA *) V;

/*!
    @method     D
    @abstract   Obtains a reference to the single D (A, G, T) representation
*/
+ (BCNucleotideDNA *) D;

/*!
    @method     B
    @abstract   Obtains a reference to the single D (C, G, T) representation
*/
+ (BCNucleotideDNA *) B;

/*!
    @method     gap
    @abstract   Obtains a reference to the single representation of a gap, for alignments
*/
+ (BCNucleotideDNA *) gap;

/*!
    @method     undefined
    @abstract   Obtains a reference to the single representation of any non-base character
*/
+ (BCNucleotideDNA *) undefined;


/*!
    @method     customBase:
    @abstract   Obtains a reference to a user-defined base
*/
+ (BCNucleotideDNA *) customBase: (NSString *)baseName;


#if 0
#pragma mark == OBJECT METHODS ==
#endif

#if 0
#pragma mark == INITIALIZATION METHODS ==
#endif



/*!
    @method     initWithSymbolChar:
    @abstract   designated initialization method
    @discussion Given a symbol, this method generates the appropriate Nucleotide representation using
    *  information in the bundle's "nucleotides.plist" file.
*/
- (id)initWithSymbolChar:(unsigned char)aChar;

#if 0
#pragma mark == BASE INFORMATION METHODS ==
#endif


/*!
    @method     isBase
    @abstract   Returns NO if the receiver is a gap or undefined 
*/
- (BOOL) isBase;

#if 0
#pragma mark == BASE RELATIONSHIP METHODS ==
#endif

- (BCNucleotideRNA *) RNABaseEquivalent;


@end
