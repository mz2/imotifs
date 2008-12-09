//
//  ScoreOffsetPair.m
//  iMotifs
//
//  Created by Matias Piipari on 12/3/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "ScoreOffsetPair.h"


@implementation ScoreOffsetPair
- (id) initWithScore:(double)s offset:(NSInteger) offs
{
    self = [super init];
    if (self != nil) {
        score = s;
        offset = offs;
    }
    return self;
}
-(void) dealloc {
    [super dealloc];
}

@synthesize score, offset;
@end
