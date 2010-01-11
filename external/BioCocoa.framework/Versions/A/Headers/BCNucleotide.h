//
//  BCNucleotide.h
//  BioCocoa
//
//  Created by John Timmer on 2/25/05.
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
