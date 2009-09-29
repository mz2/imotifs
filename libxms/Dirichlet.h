//
//  Dirichlet.h
//  XMSParser
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Cocoa/Cocoa.h"
#import "Multinomial.h"
#import "dirichlet_math.h"

@class DistributionBounds;


@interface Dirichlet : Multinomial <NSCoding> {
    
    @protected
    Multinomial *cachedMean;
    DistributionBounds *cachedDistBounds;
}

- (id) initWithAlphabet: (Alphabet*) alpha 
                  means: (Multinomial*) means
              precision: (double) prec;

@property (readwrite) double precision;

-(double) density:(Multinomial*) multinomial;
-(Multinomial*) sample;
-(Multinomial*) mean;

-(DistributionBounds*) confidenceAtMinInterval:(double) minInterval maxInterval:(double) maxInterval;
-(DistributionBounds*) confidenceAtInterval:(double) interval; //interval should be above 0.5

@end
