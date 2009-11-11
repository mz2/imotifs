//
//  BCGeneticCode.h
//  BioCocoa
//
//  Created by John Timmer on 8/31/04.
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
