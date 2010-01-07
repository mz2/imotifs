//
//  BCToolMassCalculator.h
//  BioCocoa
//
//  Created by Koen van der Drift on Wed Aug 25 2004.
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
@abstract Mass calculation for a sequence.
*/

#import <Foundation/Foundation.h>
#import "BCSequenceTool.h"
#import "BCFoundationDefines.h"

@class BCSymbol, BCSequence;

/*!
@class BCToolMassCalculator
@abstract    A wrapper class to calculate the mass of a  sequence.
@discussion  This class can be used to calculate the mass of a BCSequence. 
* To use it simply pass any BCSequence object to the initializer or class method.
* Then call the calculateMass: method. The class will
* return an NSArray containing two numbers, the minimal mass and maximum mass.
* This is needed to account for the possibility of having ambiguous symbols.

* Use the method setMassType:(BCMassType)type to set if the calculated mass should be monoisotopic or average.
* The default value is monoisotopic.
*/

@interface BCToolMassCalculator : BCSequenceTool {

	BCMassType		massType;
}

+ (BCToolMassCalculator *) massCalculatorWithSequence: (BCSequence *) list;

- (void)setMassType:(BCMassType)type;

- (NSArray *)calculateMass;
- (NSArray *)calculateMassForRange: (NSRange)aRange;
- (float) addWater;

@end
