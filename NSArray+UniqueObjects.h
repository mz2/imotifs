//
//  NSArray+UniqueObjects.h
//  iMotifs
//
//  Created by Matias Piipari on 28/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (UniqueObjects)

-(NSArray*) uniqueObjects;

-(NSArray*) uniqueObjectsSortedUsingSelector: (SEL)comparator;

-(NSArray*) uniqueObjectsSortedUsingFunction: (NSInteger (*)(id, id, void *)) comparator  
                                     context: (id)context 
                                        hint: (id)hint;

-(NSArray*) uniqueObjectsSortedUsingFunction: (NSInteger (*)(id, id, void *)) comparator 
                                     context: (id)context;

-(NSArray*) uniqueObjectsSortedUsingSortDescriptors: (NSArray*) sortDescs;

@end
