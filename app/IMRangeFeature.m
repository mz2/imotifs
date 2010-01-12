//
//  IMRangeAnnotation.m
//  iMotifs
//
//  Created by Matias Piipari on 07/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "IMRangeFeature.h"


@implementation IMRangeFeature
@synthesize start = _start;
@synthesize end = _end;

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

- (id)initWithStart:(NSInteger)aStart
                end:(NSInteger)anEnd
              score:(CGFloat)score
             strand:(IMStrand)strand
               type:(NSString*)type
{
    if (self = [super init]) {
        [self setStart:aStart];
        [self setEnd:anEnd];
		[self setScore: 0];
        [self setStrand: strand];
        [self setType: type];
    }
    return self;
}

+ (id)rangeFeatureWithStart:(NSInteger)aStart 
                        end:(NSInteger)anEnd 
                      score:(CGFloat)score
                     strand:(IMStrand)strand
                       type:(NSString*)type
{
    id result = [[[self class] alloc] initWithStart:aStart end:anEnd score: score strand:strand type:type];
	
    return [result autorelease];
}

-(NSInteger) length {
	return self.end - self.start + 1;
}

-(BOOL) overlapsWithPosition:(NSInteger) pos {
    PCLog(@"%d [%d -- %d]", pos, self.start, self.end);
	if (self.start > pos) return NO;
	if (self.end < pos) return NO;
    
    PCLog(@"Overlaps with position");
	
	return YES;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"[IMRangeFeature start:%d end:%d strand:%d type:%@]",
            self.start,self.end,self.strand,self.type];
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [super dealloc];
}


@end
