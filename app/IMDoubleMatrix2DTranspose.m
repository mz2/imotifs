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
//  IMDoubleMatrix2DTranspose.m
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "IMDoubleMatrix2DTranspose.h"
#import "IMDoubleMatrix2DIface.h"

@implementation IMDoubleMatrix2DTranspose

+(id<IMDoubleMatrix2DIface>) transpose:(id<IMDoubleMatrix2DIface>)r {
    IMDoubleMatrix2DTranspose *transp = [[IMDoubleMatrix2DTranspose alloc] init];
    transp->raw = [r retain];
    return [transp autorelease];
}

-(void) dealloc {
    [raw release];
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

-(double) valueAtRow:(NSUInteger)row col:(NSUInteger)col {
    return [raw valueAtRow:col 
                       col:row];
}

-(void) setValue:(double)v 
             row:(NSUInteger) row 
             col:(NSUInteger) col {
    return [raw setValue:v 
                     row:col 
                     col:row];
}

-(id<IMDoubleMatrix2DIface>) transpose {
    return [IMDoubleMatrix2DTranspose transpose:self];
}
@end
