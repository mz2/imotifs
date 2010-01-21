/*
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the
Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
Boston, MA  02110-1301, USA.
*/
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
