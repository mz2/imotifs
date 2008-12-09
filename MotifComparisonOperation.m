//
//  MotifBestHitsOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 12/8/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "MotifComparisonOperation.h"


@implementation MotifComparisonOperation
@synthesize comparitor;
   
-(id) initWithComparitor:(MotifComparitor*) aComparitor {
    self = [super init];
    if (self != nil) {
        comparitor = [aComparitor retain];
    }
    return self;
}

-(void) dealloc {
    [comparitor release];
    [super dealloc];
}

@end