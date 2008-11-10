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
