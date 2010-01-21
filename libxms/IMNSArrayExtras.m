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
//  IMNSArrayExtras.m
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "IMNSArrayExtras.h"


@implementation NSArray (IMNSArrayExtras)

-(NSArray*) retainAll:(NSArray*)arr {
    NSMutableSet* intersect = [NSMutableSet setWithArray:self];
    NSSet* set1 = [NSSet setWithArray:arr];
    [intersect intersectSet:set1];
    
    NSMutableArray *intersectArr = [NSMutableArray arrayWithCapacity:[intersect count]];
    for (id o in self) {
        if ([intersectArr containsObject:o])
            [intersectArr addObject:o];
    }
    return intersectArr;
}
@end
