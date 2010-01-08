//
//  BCNucleotide.h
//  BioCocoa
//
//  Created by John Timmer on 2/25/05.
//  Copyright 2005 The BioCocoa Project. All rights reserved.
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
@abstract Provides in-memory representations of nucleotides. 
*/

#import <Foundation/Foundation.h>
#import "BCSymbol.h"

/*!
@class BCNucleotide
@abstract    Nucleotide specific symbols.
@discussion  This class provides in-memory representations of nucleotides.
*/

@interface BCNucleotide : BCSymbol {
    
    BCSymbol		*complement;
    NSSet		*complements;
}


///////////////////////////////////////////////////////////
//  COMPLEMENTATION METHODS
///////////////////////////////////////////////////////////

/*!
@method     complement
 @abstract   Returns a reference to the symbol the complements the receiver
 @discussion When called on adenosine, this method will return a reference to thyidine.
 *  For ambiguous symbol, it returns the single most complete complement - when called on purine,
 *  it will return only pyrimidine. For amino acids, this will return nil.
 */
- (BCNucleotide  *)complement;

    /*!
    @method     complements
     @abstract   Returns references all symbols that may complement the receiver in an array
     @discussion When called on adenosine, this method will return an array containing references
     *  to thyidine, weak, any, etc. For amino acids, this will return nil.
     */
- (NSSet *)complements;

    /*!
    @method     complementsSymbol: (BCSymbol *)entry;
     @abstract   Evaluates whether the receiver complements the entry
     @discussion When called on adenosine, this method will return YES if the entry is thymidine,
     *  weak, any base, etc. For amino acids, this will return nil.
     */
- (BOOL) complementsSymbol: (BCNucleotide *)entry;

- (BOOL) isComplementOfSymbol: (BCNucleotide *)entry;

@end
