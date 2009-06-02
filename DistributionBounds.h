//
//  DistributionBounds.h
//  iMotifs
//
//  Created by Matias Piipari on 12/05/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SymbolBounds;
@class Symbol;
@class Alphabet;

@interface DistributionBounds : NSObject {
    Alphabet *alphabet;
    NSMutableArray *bounds;
}

@property (retain, readonly) Alphabet *alphabet;
@property (retain, readonly) NSArray *bounds;

-(id) initWithAlphabet: (Alphabet*) alphabet 
          symbolBounds: (NSArray*) symBounds;

+(DistributionBounds*) boundsWithAlphabet: (Alphabet*)alphabet 
                             symbolBounds: (NSArray*)symBounds;

-(SymbolBounds*) boundsForSymbol: (Symbol*) sym;

-(void) setBounds: (SymbolBounds*) symBounds 
        forSymbol: (Symbol*) sym;

@end