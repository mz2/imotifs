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
    IMIntMatrix2DTranspose *transp = [[IMIntMatrix2DTranspose alloc] init];
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
