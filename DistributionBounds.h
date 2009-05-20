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

@interface DistributionBounds : NSObject {
    @protected
    NSMutableDictionary *bounds;
}

-(id) initWithAlphabet: alphabet 
          symbolBounds: symBounds;

+(DistributionBounds*) boundsWithAlphabet: alphabet 
                       symbolBounds: symBounds;

-(SymbolBounds*) boundsForSymbol:(Symbol*) sym;
-(void) setBounds:(SymbolBounds*) forSymbol:(Symbol*) sym;

@end