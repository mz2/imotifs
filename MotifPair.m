//
//  MotifPair.m
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "MotifPair.h"

@implementation MotifPair
@synthesize m1;
@synthesize m2;
@synthesize flipped;
@synthesize score;

-(MotifPair*) initWithMotif:(Motif*)a andMotif:(Motif*)b withScore:(double)s isFlipped:(BOOL)yesno {
    m1 = [a retain];
    m2 = [b retain];
    flipped = yesno;
    score = s;
    return self;
}

-(BOOL) equals:(id)o {
    if ([o isKindOfClass:[MotifPair class]]) {
        return false;
    }
    
    MotifPair *po = (MotifPair*) o;
    return m1 == po.m1 && m2 == po.m2;
}

-(NSUInteger) hash {
    return [m1 hash] * 37 + [m2 hash];
}

-(void) dealloc {
    [m1 release];
    m1 = nil;
    [m2 release];
    m2 = nil;
    [super dealloc];
}
@end
