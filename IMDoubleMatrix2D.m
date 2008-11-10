//
//  IMMatrix2D.m
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "IMDoubleMatrix2D.h"
#import "IMDoubleMatrix2DIface.h"
#import "IMDoubleMatrix2DTranspose.h"
#import <stdlib.h>

@implementation IMDoubleMatrix2D

-(id) initWithRows:(NSUInteger)rs cols:(NSUInteger)cs {
    self = [super init];
    if (self != nil) {
        _rows = rs;
        _columns = cs;
        _elems = rs * cs;
        values = calloc(_elems,sizeof(double));
    }
    return self;
}

-(id) initWithRows:(NSUInteger)rs cols:(NSUInteger)cs value:(double)value {
    [self initWithRows:rs cols:cs];    
    int i;
    for (i = 0; i < _elems; ++i) {
        values[i] = value;
    }
    return self;
}

-(void) dealloc {
    free(values);
    values = nil;
    [super dealloc];
}

-(NSUInteger) rows {
    return _rows;
}

-(NSUInteger) columns {
    return _columns;
}
-(NSUInteger) elements {
    return _elems;
}

-(double) valueAtRow:(NSUInteger)row 
                 col:(NSUInteger)col {
    return values[row * _columns + col];
}

-(void) setValue:(double)v 
             row:(NSUInteger) row 
             col:(NSUInteger) col {
    values[row * _columns + col] = v;
}

-(id<IMDoubleMatrix2DIface>) transpose {
    return [IMDoubleMatrix2DTranspose transpose:self];
}

@end
