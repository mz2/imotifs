//
//  Dirichlet.m
//  XMSParser
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Dirichlet.h>
#import <Multinomial.h>
#import <stdlib.h>
#import <math.h>

#import "DistributionBounds.h"
#import "SymbolBounds.h"

#import "dirichlet_math.h"
//init random number generator


@interface Dirichlet (private)

@end

@implementation Dirichlet

- (id) initWithAlphabet: (Alphabet*) alpha 
                  means: (Multinomial*) means
              precision: (double) prec {
    self = [super initWithMultinomial: means];
    
    if (self != nil) {
        [self setPrecision: prec];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    return self;
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [super encodeWithCoder: coder];
}


-(double) precision {
    double sum = 0.0;
    
    for (Symbol* sym in [alphabet symbols]) {
        sum = sum + [self weightForSymbol:sym];
    }
    
    return sum;
}

-(void) setPrecision: (double) newPrec {
    [self clearCachedValues];
    
    double prec = self.precision;
    
    for (Symbol* sym in [alphabet symbols]) {
        //PCLog(@"Setting alphasum to %@ : %.3f, %.3f", sym, [self weightForSymbol:sym],[self weightForSymbol:sym] * newPrec / prec);
        [self symbol:sym withWeight: [self weightForSymbol:sym] * newPrec / prec];
    }
}

-(void) multiplyPrecision: (double) ratio {
    for (Symbol* sym in [alphabet symbols]) {
        [self symbol:sym withWeight: [self weightForSymbol:sym] * ratio];
    }
}



-(Multinomial*) sample {
    int dim = weights.count;
    double gammas[dim];
    double sumGammas = 0.0;
    
    Multinomial *sample = [Multinomial multinomialWithAlphabet:self.alphabet];
    int i = 0;
    for (Symbol *sym in [alphabet symbols]) {
        gammas[i] = sampleGamma([self weightForSymbol: sym], 1.0);
        sumGammas += gammas[i++];
    }
    
    for (i = 0; i < dim; i++) {
        [sample symbol:[[alphabet symbols] objectAtIndex:i] withWeight: gammas[i] /= sumGammas];
    }
    
    return sample;
}

-(Multinomial*) mean {
    if (cachedMean == nil) {
        Multinomial *mean = [[Multinomial alloc] initWithAlphabet: alphabet];
        double prec = [self precision];
        
        for (Symbol *sym in [alphabet symbols]) {
            [mean symbol:sym withWeight: [self weightForSymbol: sym] / prec];
        }
        cachedMean = mean;
    }
    
    return cachedMean;
}

-(double) density:(Multinomial*) multinomial {
    double sumAlpha = 0.0;
    double sumLgammaAlpha = 0.0;
    double logLik = 0.0;
    
    for (Symbol *sym in [alphabet symbols]) {
        double a = [self weightForSymbol:sym];
        sumAlpha = sumAlpha + a;
        sumLgammaAlpha = sumLgammaAlpha + lgamma([self weightForSymbol:sym]);
        logLik = logLik + log([multinomial weightForSymbol: sym]) * (a - 1.0);
    }
    
    return exp(lgamma(sumAlpha) - sumLgammaAlpha + logLik);
}

-(double) logDensity:(Multinomial*) multinomial {
    double sumAlpha = 0.;
    double sumLgammaAlpha = 0.;
    double logLik = 0.;
    for (Symbol *sym in [alphabet symbols]) {
        double a = [self weightForSymbol:sym];
        sumAlpha += a;
        sumLgammaAlpha += lgamma(a);
        logLik += log([multinomial weightForSymbol:sym]) * (a - 1);
    }
    return lgamma(sumAlpha) - sumLgammaAlpha + logLik;
}

-(DistributionBounds*) confidenceAtMinInterval:(double) minInterval maxInterval:(double) maxInterval {
    //the marginals of a Dirichlet distribution are Beta distributions of form
    //Beta(a_i,prec - a_i)
    
    NSUInteger i = 0;
    //NSUInteger dim = weights.count;
    double prec = [self precision];
    static const double stepSize = 0.01;
    Multinomial *mean = [self mean];
    NSMutableArray *symBounds = [NSMutableArray array];
    
    for (Symbol *sym in weights) {
        double min = 0.0;
        double max = 1.0;
        double expval = [mean weightForSymbol: sym];
        double a_i = [self weightForSymbol: sym];
        
        double d;
        for (d = 0.0; d < 1.0; d = d+stepSize) {
            double b = cbeta(d, a_i, prec - a_i);
            if (b > minInterval) {
                min = d;
                break;
            } 
        }
        
        for (d = 1.0; d > 0.0; d = d-stepSize) {
            double b = cbeta(d, a_i, prec - a_i);
            if (b < maxInterval) {
                //NSLog(@"Min interval: b=%.3f a_i=%.3f prec - a_i = %.3f d = %.3f", b, a_i, prec - a_i,d);
                max = d;
                break;
            }
        }
        
        SymbolBounds *sb = [SymbolBounds boundsWithMin:min max:max mean:expval];
        [symBounds addObject: sb]; 
        //PCLog(@"Interval for %@: %.3f %.3f (mean %.3f)",sym, min, max, expval);
        i++;
    }
    
    DistributionBounds *distBounds = [DistributionBounds boundsWithAlphabet: alphabet 
                                                               symbolBounds: symBounds];
    return distBounds;
}

-(DistributionBounds*) confidenceAtInterval:(double) interval {
    NSParameterAssert(interval > 0.5);
    return [self confidenceAtMinInterval: 1.0 - interval maxInterval: interval]; 
}

-(void) dealloc {
    [super dealloc];
}

-(void) clearCachedValues {
    [super clearCachedValues];
    [cachedMean release];
    cachedMean = nil;
    [cachedDistBounds release];
    cachedDistBounds = nil;
}
@end
