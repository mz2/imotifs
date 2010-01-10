//
//  BCAminoAcid.h
//  BioCocoa
//
//  Created by Koen van der Drift on Sat May 10 2003.
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
