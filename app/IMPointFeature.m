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
//  IMPointFeature.m
//  iMotifs
//
//  Created by Matias Piipari on 07/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "IMPointFeature.h"


@implementation IMPointFeature

@synthesize position = _position;

// init
- (id)init
{
    if (self = [super init]) {
        [self setPosition: 0];
    }
    return self;
}

- (id)initWithPosition:(NSInteger)aPosition strand:(IMStrand)strand type:(NSString*) type
{
    if (self = [super init]) {
        [self setPosition:aPosition];
        [self setStrand:strand];
		[self setType: type];
    }
    return self;
}

+ (id)pointFeatureWithPosition:(NSInteger)aPosition strand:(IMStrand)strand type:(NSString*) type
{
    id result = [[[self class] alloc] initWithPosition:aPosition strand: strand type: type];
	
    return [result autorelease];
}

-(BOOL) overlapsWithPosition:(NSInteger) pos {
	if (self.position == pos) return YES;	
	return NO;
}

-(BOOL) overlapsWithRange:(NSRange) range {
	NSInteger rangeStart = range.location;
	NSInteger rangeEnd = range.location + range.length;
	
	if (self.position >= rangeStart && self.position <= rangeEnd) return YES;
	
	return NO;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"[IMPointFeature position:%d strand:%d type:%@]",
            self.position,self.strand,self.type];
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
	
    [super dealloc];
}





@end