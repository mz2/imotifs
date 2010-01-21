/*
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the
Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
Boston, MA  02110-1301, USA.
*/
//
//  MetamotifTests.m
//  iMotifs
//
//  Created by Matias Piipari on 12/05/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>

#import "MetamotifTests.h"
#import "Dirichlet.h"
#import "Multinomial.h"
#import "incomplete_beta.h"

#define IMAccuracy (double) 0.0001

@implementation MetamotifTests

- (void) testMathFunctions
{
    STAssertTrue(YES, @"true is true");
    
    //> dbeta(0.2,2,1)
    //[1] 0.4
    STAssertEqualsWithAccuracy(pbeta(0.2, 2.0, 1.0),0.4,IMAccuracy,@"Incorrect beta density");
    
    //> dbeta(0.9,1.5,4.5)
    //[1] 0.003492314
    STAssertEqualsWithAccuracy(pbeta(0.9,1.5,4.5),0.003492314,IMAccuracy,@"Incorrect beta density");
    
    //pbeta(0.5,1,2)
    //[1] 0.75
    STAssertEqualsWithAccuracy(cbeta(0.5, 1.0, 2.0),0.75,IMAccuracy,@"Incorrect cumulative density");

    //> pbeta(0.5,1,3)
    //[1] 0.875
    STAssertEqualsWithAccuracy(cbeta(0.5, 1.0, 3.0),0.875,IMAccuracy,@"Incorrect cumulative density");
}

@end
