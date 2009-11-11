//
//  BCCodonDNA.h
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
@abstract Provides codon functionality for translation of DNA sequences.
*/

#import <Foundation/Foundation.h>
#import "BCCodon.h"

@class BCSequence;


/*!
    @class       BCCodonDNA
    @abstract    Provides codon functionality for translation of DNA sequences
    @discussion  A codon is a composite object, consisting of three bases and a corresponding amino acid.  This class
    *   provides the equivalent functionality in code form.  The common (amino acid) portion of the class is implemented 
    *   by the superclass, BCCodon.  The DNA specific form provides a designated initilization
    *   routine and methods for querying its base component.  You will typically not create these items, but rather access
    *   them via methods in BCGeneticCode.
*/

@interface BCCodonDNA : BCCodon {
    
}

/*!
    @method     unmatched
    @abstract   provides access to a singleton codon that represents a generic non-coding triplet
*/
+ (BCCodonDNA *)unmatched;


/*!
    @method     initWithDNASequenceString:andAminoAcidString:
    @abstract   designated class initilizer
    @discussion takes the supplied strings and uses them to get references to the corresponding BCSymbol objects.  Will return
    *   nil if any of these objects cannot be created with the given strings, or the strings are malformed.
*/
- (BCCodonDNA *)initWithDNASequenceString: (NSString *)sequenceString andAminoAcidString: (NSString *)aaString;


/*!
    @method     triplet
    @abstract   returns a BCSequence comprised of the appropriate bases
*/
- (BCSequence *) triplet;


/*!
    @method     matchesTriplet:
    @abstract   returns yes only if every base of the entry is represented by the bases of the codon in the appropriate order.
    @discussion implementation of this method accounts for ambiguous bases.
*/
- (BOOL) matchesTriplet: (NSArray *)entry;


@end
