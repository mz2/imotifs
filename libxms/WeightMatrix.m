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
//  WeightMatrix.m
//  XMSParser
//
//  Created by Matias Piipari on 23/06/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WeightMatrix.h"


@implementation WeightMatrix
-(id) init {
    [self dealloc];
    @throw [NSException exceptionWithName:@"BadInitCall" 
                                   reason:@"Use -initWithColumns instead"
                                 userInfo:nil];
}
-(id) initWithColumns:(NSArray*) cols {
    if (cols == nil) {
        [self dealloc];
        @throw [NSException exceptionWithName:@"BadInitCall"
                                       reason:@"cols cannot be nil"
                                     userInfo:nil];
    }
    [super init];
    columns = cols;
    [columns retain];
    return self;
}

@synthesize columns;
@end
