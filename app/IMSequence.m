//
//  IMSequence.m
//  iMotifs
//
//  Created by Matias Piipari on 05/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IMSequence.h"
#import <BioCocoa/BCFoundation.h>
#import "IMFeature.h"
#import "IMRangeFeature.h"
#import "IMPointFeature.h"

@implementation IMSequence
@synthesize focusPosition = _focusPosition;
@synthesize name = _name;
@synthesize features = _features;

- (id)initWithSymbolArray:(NSArray *)a {
	self = [super initWithSymbolArray:a];
	if (self == nil) return nil;
	self.focusPosition = NSNotFound;
	return self;
}

- (id)initWithString:(NSString *)aString symbolSet:(BCSymbolSet *)aSet {
	self = [super initWithString:aString symbolSet: aSet];
	if (self == nil) return nil;
	self.focusPosition = NSNotFound;
	return self;
}

-(NSComparisonResult) compare:(IMSequence*) seq {
    if ([seq length] < [self length]) {
        return NSOrderedAscending;
    } else if ([seq length] > [self length]) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

-(NSArray*) featuresOverlappingWithPosition:(NSInteger) position {
	NSMutableArray *anns = [NSMutableArray array];
	
	for (IMFeature *feature in [self features]) {
		
		if ([[self features] isKindOfClass: [IMRangeFeature class]]) {
			if ([(IMRangeFeature*)feature overlapsWithPosition: position]) {
				[anns addObject: feature];
			}
			
		} else if ([feature isKindOfClass: [IMPointFeature class]]) {
			if ([(IMPointFeature*)feature position] == position) {
				[anns addObject: feature];
			}
		} else {
			//ignore
		}
	}
	
	return anns;
}
@end