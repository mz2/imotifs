//
//  SymbolBounds.m
//  iMotifs
//
//  Created by Matias Piipari on 12/05/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "SymbolBounds.h"


@implementation SymbolBounds
@synthesize min,max,mean;

- (id) initWithMin:(double) mi Max:(double)ma mean:(double) me
{
    self = [super init];
    if (self != nil) {
        min = mi;
        max = ma;
        mean = me;
    }
    return self;
}

+ (SymbolBounds*) boundsWithMin:(double) mi max:(double)ma mean:(double) me {
    return [[[SymbolBounds alloc] initWithMin: mi Max: ma mean: me] autorelease];
}

@end
