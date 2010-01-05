//
//  IMSequence.m
//  iMotifs
//
//  Created by Matias Piipari on 05/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IMSequence.h"


@implementation IMSequence
@synthesize focusPosition = _focusPosition;
@synthesize name = _name;

-(NSComparisonResult) compare:(IMSequence*) seq {
    if ([seq length] < [self length]) {
        return NSOrderedAscending;
    } else if ([seq length] > [self length]) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}
@end