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
#import "IMPositionedFeature.h"
#import "IMRangeFeature.h"
#import "IMPointFeature.h"

@interface IMSequence (private)
-(NSMutableSet*) _selectedFeatures;
@end

@implementation IMSequence


@synthesize focusPosition = _focusPosition;
@synthesize name = _name;
@synthesize features = _features;

- (id)initWithSymbolArray:(NSArray *)a {
	self = [super initWithSymbolArray:a];
	if (self == nil) return nil;
	self.focusPosition = NSNotFound;
	self.features = [NSMutableArray array];
	return self;
}

- (id)initWithString:(NSString *)aString symbolSet:(BCSymbolSet *)aSet {
	self = [super initWithString:aString symbolSet: aSet];
	if (self == nil) return nil;
	self.focusPosition = NSNotFound;
	self.features = [NSMutableArray array];
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
		
		if ([feature isKindOfClass:[IMPositionedFeature class]]) {
			if ([(IMPositionedFeature*)feature overlapsWithPosition: position]) {
				[anns addObject: feature];
			}
		} else {
			//ignore
		}
	}
	
	return anns;
}

-(NSSet*) selectedFeatures {
	NSMutableSet *set = [self _selectedFeatures];
	return set;
}

-(NSMutableSet*) _selectedFeatures {
	NSMutableSet *set = [NSMutableSet set];
	for (IMFeature *f in self.features) {
		if (f.selected) {[set addObject: f];}
	}
	return set;
}


-(NSString*) selectedFeaturesString {
	NSSet *selection = [self _selectedFeatures];
	
	if (selection.count == 0) {return @"none";}
	if (selection.count > 1) {return @"multiple selected";}
	if (selection.count == 1) {return [NSString stringWithFormat:@"%@ (%@)",
									   [[selection anyObject] type],[self selectedFeaturesRangeString]];}
	
	return nil;
}

-(NSString*) selectedFeaturesRangeString {
	NSSet *selection = [self _selectedFeatures];
	
	if (selection.count == 0) {return @"none";}
	if (selection.count > 1) {return @"multiple selected";}
	if (selection.count == 1) {
		IMFeature *f = [selection anyObject];
		if ([f isKindOfClass:[IMRangeFeature class]]) {
			return [NSString stringWithFormat:@"%d - %d",[(IMRangeFeature*)f start],[(IMRangeFeature*)f end]];	
		} else if ([f isKindOfClass:[IMPointFeature class]]) {
			return [NSString stringWithFormat:@"%d", [(IMPointFeature*)f position]];
		} return @"no range";
	}
	
	return nil;
}

-(NSString*) sequenceFromPosition:(NSInteger) pos
						   before:(NSInteger) before
							after:(NSInteger) after
{
	NSInteger actualStart,actualEnd;
	NSString *seq = [self description];
	actualStart = pos - before;
	actualEnd = pos + after;
	if (actualStart < 0) {actualStart = 0;}
	if (actualEnd > [seq length]) {actualEnd = [seq length]-1;}
	
	return [seq substringWithRange:NSMakeRange(actualStart, actualEnd)];
}

-(NSAttributedString*) formattedSequenceFromPosition:(NSInteger) pos
											  before:(NSInteger) before
											   after:(NSInteger) after {
	NSInteger actualStart,actualEnd;
	NSString *seq = [self description];
	actualStart = pos - before;
	actualEnd = pos + after;
	if (actualStart < 0) {actualStart = 0;}
	if (actualEnd > [seq length]) {actualEnd = [seq length]-1;}
	
	NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:seq];
	
	
	for (IMFeature *feature in [self features]) {
		
		if ([feature isKindOfClass: [IMRangeFeature class]]) {
			
			
		} else if ([feature isKindOfClass: [IMPointFeature class]]) {
			
		} else {
			//ignore
		}
	}
	
	return str;
}

-(NSAttributedString*) focusPositionFormattedString {
	return [self formattedSequenceFromPosition: self.focusPosition 
										before: 10
										 after: 10];
}

-(void) dealloc {
    [_name release], _name = nil;
	[_features release], _features = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark KVO

+ (void) initialize 
{
	[[self class] setKeys:
	 [NSArray arrayWithObjects: @"focusPosition", nil]
triggerChangeNotificationsForDependentKey: @"selectedFeatures"];
	
    [[self class] setKeys:
	 [NSArray arrayWithObjects: @"selectedFeatures", nil]
triggerChangeNotificationsForDependentKey: @"selectedFeaturesString"];
	
    [[self class] setKeys:
	 [NSArray arrayWithObjects: @"selectedFeatures", nil]
triggerChangeNotificationsForDependentKey: @"selectedFeaturesRangeString"];
}


@end