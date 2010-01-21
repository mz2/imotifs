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
