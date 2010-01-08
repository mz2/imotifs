//
//  BCCodon.h
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
@abstract Provides codon functionality for translation of RNA sequences.
*/

#import <Foundation/Foundation.h>
#import "BCCodon.h"

@class BCSequence;


/*!
@class       BCCodonRNA
@abstract    Provides codon functionality for translation of RNA sequences
@discussion  A codon is a composite object, consisting of three bases and a corresponding amino acid.  This class
*   provides the equivalent functionality in code form.  The common (amino acid) portion of the class is implemented 
*   by the superclass, BCCodon.  The RNA specific form provides a designated initilization
*   routine and methods for querying its base component.  You will typically not create these items, but rather access
*   them via methods in BCGeneticCode.
*/

@interface BCCodonRNA : BCCodon {
    
}

/*!
    @method     unmatched
    @abstract   provides access to a singleton codon that represents a generic non-coding triplet
*/
+ (BCCodonRNA *)unmatched;

        
/*!
     @method     initWithRNASequenceString:andAminoAcidString:
     @abstract   designated class initilizer
     @discussion takes the supplied strings and uses them to get references to the corresponding BCSymbol objects.  Will return
     *   nil if any of these objects cannot be created with the given strings, or the strings are malformed.
*/
- (BCCodonRNA *)initWithRNASequenceString: (NSString *)sequenceString andAminoAcidString: (NSString *)aaString;


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
