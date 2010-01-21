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
//  IMRangeAnnotation.m
//  iMotifs
//
//  Created by Matias Piipari on 07/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "math.h"
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
	if (self.start <= pos && self.end >= pos) return YES;	
	return NO;
}

-(BOOL) overlapsWithRange:(NSRange) range {
	NSInteger rangeStart = (NSInteger)fmax(range.location,0);
	NSInteger rangeEnd = (NSInteger)fmax(range.location + range.length,0);
	
	if ((self.end >= rangeStart) && (self.end <= rangeEnd)) return YES;
	if ((self.start >= rangeStart) && (self.start <= rangeEnd)) return YES;
	
	return NO;
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
