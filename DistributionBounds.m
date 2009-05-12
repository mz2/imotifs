//
//  DistributionBounds.m
//  iMotifs
//
//  Created by Matias Piipari on 12/05/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "DistributionBounds.h"
#import "SymbolBounds.h"


@implementation DistributionBounds

- (id) init
{
    self = [super init];
    if (self != nil) {
        bounds = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(SymbolBounds*) boundsForSymbol:(Symbol*) sym {
    return [bounds objectForKey: sym];
}

-(void) setBounds:(SymbolBounds*) bs forSymbol:(Symbol*) sym {
    [bounds setObject: bs 
               forKey: sym];
}

-(void) dealloc {
    [bounds release];
    [super dealloc];
}
@end
