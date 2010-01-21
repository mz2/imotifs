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
//  SymbolBounds.m
//  iMotifs
//
//  Created by Matias Piipari on 12/05/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "SymbolBounds.h"


@implementation SymbolBounds
@synthesize min,max,mean;

- (id) initWithMin:(double) mi Max:(double)ma mean:(double) me
{
    self = [super init];
    if (self != nil) {
        min = mi;
        max = ma;
        mean = me;
    }
    return self;
}

+ (SymbolBounds*) boundsWithMin:(double) mi max:(double)ma mean:(double) me {
    return [[[SymbolBounds alloc] initWithMin: mi Max: ma mean: me] autorelease];
}

@end
