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
