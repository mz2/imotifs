//
//  BCToolMassCalculator.h
//  BioCocoa
//
//  Created by Koen van der Drift on Wed Aug 25 2004.
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
