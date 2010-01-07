//
//  IMRangeAnnotation.m
//  iMotifs
//
//  Created by Matias Piipari on 07/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "IMRangeAnnotation.h"


@implementation IMRangeAnnotation
@synthesize start = _start;
@synthesize end = _end;
@synthesize score = _score;
@synthesize selected = _selected;

// init
- (id)init
{
    if (self = [super init]) {
        [self setStart: 0];
        [self setEnd: 0];
		[self setScore: 0];
    }
    return self;
}

- (id)initWithStart:(NSInteger)aStart end:(NSInteger)anEnd  score:(CGFloat)score
{
    if (self = [super init]) {
        [self setStart:aStart];
        [self setEnd:anEnd];
		[self setScore: 0];
    }
    return self;
}

+ (id)rangeAnnotationWithStart:(NSInteger)aStart end:(NSInteger)anEnd score:(CGFloat)score
{
    id result = [[[self class] alloc] initWithStart:aStart end:anEnd score: score];
	
    return [result autorelease];
}

-(NSInteger) length {
	return self.end - self.start + 1;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [super dealloc];
}


@end
