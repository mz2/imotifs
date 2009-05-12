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
