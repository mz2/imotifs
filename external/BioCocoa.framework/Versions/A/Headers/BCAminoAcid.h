//
//  BCAminoAcid.h
//  BioCocoa
//
//  Created by Koen van der Drift on Sat May 10 2003.
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
@abstract Provides in-memory representations of amino acids. 
*/

#import <Foundation/Foundation.h>
#import "BCSymbol.h"


/*!
@class BCAminoAcid
@abstract    All amino acids are handled through this single class
@discussion  This class provides in-memory representations of amino acids.
*/

@interface BCAminoAcid : BCSymbol
{
	NSString		*threeLetterCode;
	
	float			kyteDoolittleValue;
	float			hoppWoodsValue;
	float			pKaValue;
}

/*!
    @method     initAminoAcids
    @abstract   Used internaly to generate the full set of amino acid objects.   
*/
+ (void) initAminoAcids;

/*!
    @method     objectForSavedRepresentation: (NSString *)aSymbol
    @abstract   Returns a BCAminoAcid object representing the amino acid submitted 
    @discussion all BC classes should implement a "savableRepresentation" and an 
    *  "objectForSavedRepresentation" method to allow archiving/uncarchiving in
    *  .plist formatted files.
*/
+ (id) objectForSavedRepresentation: (NSString *)aSymbol;

/*!
    @method      aaPropertiesDict
    @abstract	Returns a singleton NSDictionary holding the information for an amino acid
*/
+ (NSMutableDictionary *) aaPropertiesDict;

/*!
    @method     symbolForChar: (unsigned char)symbol
    @abstract   Returns a BCAminoAcid item representing the amino acid submitted 
*/
+ (id) symbolForChar: (unsigned char)symbol;

/*!
    @method     alanine
    @abstract   Obtains a reference to the single alanine representation
*/
+ (BCAminoAcid *) alanine;

/*!
    @method     arginine
    @abstract   Obtains a reference to the single arginine representation
*/
+ (BCAminoAcid *) arginine;

/*!
    @method     asparagine
    @abstract   Obtains a reference to the single asparagine representation
*/
+ (BCAminoAcid *) asparagine;

/*!
    @method     asparticacid
    @abstract   Obtains a reference to the single asparticacid representation
*/
+ (BCAminoAcid *) asparticacid;

/*!
    @method     cysteine
    @abstract   Obtains a reference to the single cysteine representation
*/
+ (BCAminoAcid *) cysteine;

/*!
    @method     glutamicacid
    @abstract   Obtains a reference to the single glutamicacid representation
*/
+ (BCAminoAcid *) glutamicacid;

/*!
    @method     glutamine
    @abstract   Obtains a reference to the single glutamine representation
*/
+ (BCAminoAcid *) glutamine;

/*!
    @method     glycine
    @abstract   Obtains a reference to the single glycine representation
*/
+ (BCAminoAcid *) glycine;

/*!
    @method     histidine
    @abstract   Obtains a reference to the single histidine representation
*/
+ (BCAminoAcid *) histidine;

/*!
    @method     isoleucine
    @abstract   Obtains a reference to the single isoleucine representation
*/
+ (BCAminoAcid *) isoleucine;

/*!
    @method     leucine
    @abstract   Obtains a reference to the single leucine representation
*/
+ (BCAminoAcid *) leucine;

/*!
    @method     lysine
    @abstract   Obtains a reference to the single lysine representation
*/
+ (BCAminoAcid *) lysine;

/*!
    @method     methionine
    @abstract   Obtains a reference to the single methionine representation
*/
+ (BCAminoAcid *) methionine;

/*!
    @method     phenylalanine
    @abstract   Obtains a reference to the single phenylalanine representation
*/
+ (BCAminoAcid *) phenylalanine;

/*!
    @method     proline
    @abstract   Obtains a reference to the single proline representation
*/
+ (BCAminoAcid *) proline;

/*!
    @method     serine
    @abstract   Obtains a reference to the single serine representation
*/
+ (BCAminoAcid *) serine;

/*!
    @method     threonine
    @abstract   Obtains a reference to the single threonine representation
*/
+ (BCAminoAcid *) threonine;

/*!
    @method     tryptophan
    @abstract   Obtains a reference to the single tryptophan representation
*/
+ (BCAminoAcid *) tryptophan;

/*!
    @method     tyrosine
    @abstract   Obtains a reference to the single tyrosine representation
*/
+ (BCAminoAcid *) tyrosine;

/*!
    @method     valine
    @abstract   Obtains a reference to the single valine representation
*/
+ (BCAminoAcid *) valine;

/*!
    @method     asx
    @abstract   Obtains a reference to the single asx amino acid representation
*/
+ (BCAminoAcid *) asx;

/*!
    @method     glx
    @abstract   Obtains a reference to the single glx amino acid representation
*/
+ (BCAminoAcid *) glx;

/*!
    @method     gap
    @abstract   Obtains a reference to the single gap amino acid representation
*/
+ (BCAminoAcid *) gap;

/*!
    @method     undefined
    @abstract   Obtains a reference to the single undefined amino acid representation
*/
+ (BCAminoAcid *) undefined;

/*!
    @method     threeLetterCode
    @abstract   Returns an NSString containg the three letter code for the amino acid
*/
- (NSString *)threeLetterCode;

- (float)kyteDoolittleValue;
- (void)setKyteDoolittleValue:(float)value;

- (float)hoppWoodsValue;
- (void)setHoppWoodsValue:(float)value;

- (float)pKaValue;
- (void)setpKaValue:(float)value;

@end
