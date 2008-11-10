//
//  IMIntMatrix2DTranspose.m
//  iMotifs
//
//  Created by Matias Piipari on 20/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "IMIntMatrix2DTranspose.h"
#import "IMIntMatrix2D.h"
#import "IMIntMatrix2DIface.h"

@implementation IMIntMatrix2DTranspose

+(id<IMIntMatrix2DIface>) transpose:(id<IMIntMatrix2DIface>)r {
    IMIntMatrix2DTranspose *transp = [[[IMIntMatrix2DTranspose alloc] init] autorelease];
    transp->raw = r;
    return transp;
}

-(void) dealloc {
    [raw release];
    raw = nil;
    [super dealloc];
}

-(NSUInteger) rows {
    return [raw columns];
}

-(NSUInteger) columns {
    return [raw rows];
}

-(NSUInteger) elements {
    return [raw elements];
}

-(NSInteger) valueAtRow:(NSUInteger)row col:(NSUInteger)col {
    return [raw valueAtRow:col 
                       col:row];
}

-(void) setValue:(NSInteger)v 
             row:(NSUInteger) row 
             col:(NSUInteger) col {
    return [raw setValue:v 
                     row:col 
                     col:row];
}

-(id<IMIntMatrix2DIface>) transpose {
    return [IMIntMatrix2DTranspose transpose:self];
}

@end
