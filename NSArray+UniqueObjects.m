//
//  NSArray+UniqueObjects.m
//  iMotifs
//
//  Created by Matias Piipari on 28/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSArray+UniqueObjects.h"


@implementation NSArray (UniqueObjects)

-(NSArray*) uniqueObjects {
    NSSet *set = [[NSSet alloc] initWithArray: self];
    NSArray *vals = [set allObjects];
    [set release];
    return vals;
}

-(NSArray*) uniqueObjectsSortedUsingSelector: (SEL)comparator {
    NSSet *set = [[NSSet alloc] initWithArray: self];
    NSArray *vals = [[set allObjects] sortedArrayUsingSelector: comparator];
    [set release];
    return vals;
}

-(NSArray*) uniqueObjectsSortedUsingFunction: (NSInteger (*)(id, id, void *)) comparator 
                                     context: (id)context 
                                        hint: (id)hint {
    NSSet *set = [[NSSet alloc] initWithArray: self];
    NSArray *vals = [[set allObjects] sortedArrayUsingFunction: comparator 
                                                       context: context 
                                                          hint: hint];
    [set release];
    return vals;
}

-(NSArray*) uniqueObjectsSortedUsingFunction: (NSInteger (*)(id, id, void *)) comparator 
                                     context: (id)context {
    NSSet *set = [[NSSet alloc] initWithArray: self];
    
    NSArray *vals = [[set allObjects] sortedArrayUsingFunction:comparator context:context];
    [set release];
    return vals;
}

-(NSArray*) uniqueObjectsSortedUsingSortDescriptors: (NSArray*) sortDescs {
    NSSet *set = [[NSSet alloc] initWithArray: self];
    NSArray *vals = [[set allObjects] sortedArrayUsingDescriptors:sortDescs];
    [set release];
    return vals;
}

@end
