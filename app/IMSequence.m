//
//  IMSequence.m
//  iMotifs
//
//  Created by Matias Piipari on 05/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IMSequence.h"
#import <BioCocoa/BCFoundation.h>
#import "IMRangeAnnotation.h"
#import "IMPointAnnotation.h"

@implementation IMSequence
@synthesize focusPosition = _focusPosition;
@synthesize name = _name;

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

-(NSArray*) annotationsOverlappingWithPosition:(NSInteger) position {
	NSMutableArray *anns = [NSMutableArray array];
	
	for (id key in [[self annotations] allKeys]) {
		BCAnnotation *annotation = [[self annotations] objectForKey: key];
		
		if ([annotation isKindOfClass: [IMRangeAnnotation class]]) {
			if ([(IMRangeAnnotation*)annotation overlapsWithPosition: position]) {
				[anns addObject: annotation];
			}
			
		} else if ([annotation isKindOfClass: [IMPointAnnotation class]]) {
			if ([(IMPointAnnotation*)annotation position] == position) {
				[anns addObject: annotation];
			}
		} else {
			//ignore
		}
	}
	
	return anns;
}
@end