//
//  DistributionBounds.m
//  iMotifs
//
//  Created by Matias Piipari on 12/05/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "DistributionBounds.h"
#import "SymbolBounds.h"
#import "Alphabet.h"


@implementation DistributionBounds
@synthesize alphabet,bounds;

- (id) init
{
    self = [super init];
    if (self != nil) {
        bounds = [[NSMutableArray alloc] init];
    }
    return self;
}


-(id) initWithAlphabet: (Alphabet*) a 
          symbolBounds: (NSArray*) symBounds {
    self = [self init];
    alphabet = [a retain];
    if (self != nil) {
        NSUInteger i = 0;
        for (i = 0; i < symBounds.count; i++) {
            [bounds addObject: [symBounds objectAtIndex: i]];
        }
    }
    
    return self;
}

+(DistributionBounds*) boundsWithAlphabet: (Alphabet*) alphabet 
                             symbolBounds: (NSArray*) symBounds {
    return [[[DistributionBounds alloc] initWithAlphabet:alphabet symbolBounds:symBounds] autorelease];
}

-(SymbolBounds*) boundsForSymbol:(Symbol*) sym {
    return [bounds objectAtIndex:[alphabet index:sym]];
}

-(void) setBounds:(SymbolBounds*) bs forSymbol:(Symbol*) sym {
    [bounds replaceObjectAtIndex:[alphabet index:sym] withObject: bs];
}

-(void) dealloc {
    [alphabet release];
    [bounds release];
    [super dealloc];
}
@end
