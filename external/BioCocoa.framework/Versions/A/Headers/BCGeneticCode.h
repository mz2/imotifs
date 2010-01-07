//
//  BCGeneticCode.h
//  BioCocoa
//
//  Created by John Timmer on 8/31/04.
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
@abstract Provides an interface for obtaining the codons of different genetic codes.
*/

#import <Foundation/Foundation.h>
#import "BCFoundationDefines.h"


@class BCSequence, BCCodonRNA, BCCodonDNA, BCCodon, BCNucleotideDNA, BCNucleotideRNA, BCAminoAcid;

// @class  BCSequence, BCSequenceRNA

/*!
@class       BCGeneticCode
@abstract    Provides an interface for obtaining the codons of different genetic codes.
@discussion  Genetic codes are essentially a translation dictionary implemented in BCCodons.  
*   This class does not get implemented, but rather creates and allows access to NSArrays that
*   contain the appropriate set of codons for a given genetic code.  Individual codes can be 
*   accessed either by their BCGeneticCodeName, or via appropriately named class methods.
*/


@interface BCGeneticCode : NSObject {
    
}

+ (NSArray *) geneticCode: (BCGeneticCodeName)codeType forSequenceType: (BCSequenceType)seqType;

+ (BCCodon *) codon: (BCSequence*)aCodon inGeneticCode: (BCGeneticCodeName)codeType;


+ (NSArray *) universalGeneticCodeDNA;

+ (NSArray *) universalGeneticCodeRNA;

+ (void) initUniversalGeneticCode;


+ (NSArray *) vertebrateMitochondrialGeneticCodeDNA;

+ (NSArray *) vertebrateMitochondrialGeneticCodeRNA;

+ (void) initVertebrateMitochondrialGeneticCode;


@end
