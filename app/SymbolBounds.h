//
//  SymbolBounds.h
//  iMotifs
//
//  Created by Matias Piipari on 12/05/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SymbolBounds : NSObject {
    double min;
    double max;
    double mean;
}

@property (readwrite) double min;
@property (readwrite) double max;
@property (readwrite) double mean;

- (id) initWithMin:(double) mi Max:(double)ma mean:(double) me;
+ (SymbolBounds*) boundsWithMin:(double) mi 
                            max:(double)ma 
                           mean:(double) me;

@end
