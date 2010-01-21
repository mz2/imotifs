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
	
	return [seq substringWithRange:NSMakeRange(actualStart, actualEnd - actualStart + 1)];
}

-(NSAttributedString*) formattedSequenceFromPosition:(NSInteger) pos
											  before:(NSInteger) before
											   after:(NSInteger) after {
	if ((pos < 0) || (pos == NSNotFound)) return [[[NSAttributedString alloc] initWithString:
												   @""] 
												  autorelease];
	
	NSInteger actualStart,actualEnd,actualPos;
	NSRange range = NSMakeRange(fmax(pos - before,0), fmax(pos + after + 1,0));
	
	NSString *seq = [self description];
	NSUInteger slen = seq.length;
	
	actualStart = pos - before;
	actualPos = before;
	actualEnd = pos + after;
	if (actualStart < 0) {actualPos = pos; actualStart = 0;}
	//if (actualStart < 0) {actualStart = 0;}
	if (actualEnd > [seq length]) {actualEnd = [seq length]-1;}
	NSMutableAttributedString *str = [[[NSMutableAttributedString alloc] initWithString:
									   [seq substringWithRange:NSMakeRange(actualStart, actualEnd - actualStart + 1)]] 
									  autorelease];
	
	NSInteger offset = actualStart - (pos - before);
	
	//PCLog(@"pos:%d,before:%d,after:%d,actual start of string:%d,string length:%d,pos in string:%d", 
	//	  pos, before, after, actualStart, str.length,actualPos);
	
	
	for (IMFeature *feature in [self features]) {
		if (![feature isKindOfClass:[IMPositionedFeature class]]) continue;
		IMPositionedFeature *pf = (IMPositionedFeature*) feature;
		if (![pf overlapsWithRange:range]) {
			//PCLog(@"%@ does not overlap %d => %d",pf,range.location,range.length);
			continue;
		} else {
		}
		
        
        [str addAttribute: NSForegroundColorAttributeName 
                    value: [NSColor redColor]
                    range: NSMakeRange(actualPos,1)];
		
		if ([feature isKindOfClass: [IMRangeFeature class]]) {
			NSInteger s,e;
			IMRangeFeature *rf = (IMRangeFeature*)feature;
			
			s = rf.start - pos;
			e = rf.end - pos;
			
			
			//PCLog(@"s:%d e:%d",s,e);
			if (s < 0) {
				

			} else if (s > after) {
				continue;
			}
			
			//PCLog(@"s:%d e:%d",s,e);
			if (before - s > 0) {
				s = actualPos + s;
				e = actualPos + e;
			}
			
			if (e >= slen) {
				e = slen - 1;
			}
			
			//PCLog(@"s:%d e:%d (%d_",s,e,actualPos);
			//PCLog(@"- - -");
			if (offset == 0) {
				if (s < 0) s = 0;
				if (e <= 0) continue;
				if (e >= str.length) e = str.length - 1;
				
				[str addAttribute: NSForegroundColorAttributeName 
							value: [feature.color colorWithAlphaComponent:0.7]
							range: NSMakeRange(fmax(s,0), fmax(e - s,0))];
				
				[str applyFontTraits: NSBoldFontMask 
							   range: NSMakeRange(fmax(s,0), fmax(e - s,0))];
				
			} else {
				
				if (s < 0) s = 0;
				if (e <= 0) continue;
				if (e >= str.length) e = str.length - 1;
				
				[str addAttribute: NSForegroundColorAttributeName 
							value: [feature.color colorWithAlphaComponent:0.7] 
							range: NSMakeRange(fmax(s,0), fmax(e - s,0))];
				
				[str applyFontTraits: NSBoldFontMask 
							   range: NSMakeRange(fmax(s,0), fmax(e - s,0))];
				
				
				/*
				PCLog(@"Position %d corresponds to %d in the string. Feature %d - %d => %d - %d", 
					  pos,
					  actualPos,
					  rf.start,rf.end,
					  s,e);
				 */
			}
			
			
			
		} else if ([feature isKindOfClass: [IMPointFeature class]]) {
			IMPointFeature *pf = (IMPointFeature*) feature;
			PCLog(@"Implement drawing point features such as this %@", pf);
		}
	}
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [str addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle 
                                                   forKey:NSParagraphStyleAttributeName] 
                 range:NSMakeRange(0,[str length])];
    [mutParaStyle release];
    
    [str addAttribute:NSFontAttributeName 
                value:[NSFont fontWithName:@"Courier New" size:13] 
                range:NSMakeRange(0, [str length])];
	
	return str;
}

-(NSRange) focusRange {
	if (self.focusPosition == NSNotFound) return NSMakeRange(0, 0);
	
	NSUInteger start = fmax(0,self.focusPosition-IMSequenceFocusAreaHalfLength);
	NSUInteger end = fmin([[self description] length]-1,self.focusPosition+IMSequenceFocusAreaHalfLength);
	return NSMakeRange(start, end - start + 1);
}

-(NSAttributedString*) focusPositionFormattedString {
	return [self formattedSequenceFromPosition: self.focusPosition 
										before: 20
										 after: 20];
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
	
	[[self class] setKeys:
	 [NSArray arrayWithObjects: @"selectedFeatures", nil]
triggerChangeNotificationsForDependentKey: @"focusPositionFormattedString"];
}

@end