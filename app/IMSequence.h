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
//  IMSequence.h
//  iMotifs
//
//  Created by Matias Piipari on 05/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BioCocoa/BCSequenceArray.h>
@class IMFeature;

@interface IMSequence : BCSequence {
    NSInteger _focusPosition;
	
	NSString *_name;
    NSMutableSet *_features;
	
	
}

@property (readwrite) NSInteger focusPosition;
@property (copy,readwrite) NSString *name;
@property (retain,readwrite) NSMutableSet *features;
@property (retain,readonly) NSSet *selectedFeatures;
@property (retain,readonly) NSString *selectedFeaturesString;
@property (retain,readonly) NSString *selectedFeaturesRangeString;

-(NSArray*) featuresOverlappingWithPosition:(NSInteger) position;

-(NSString*) sequenceFromPosition:(NSInteger) pos
						   before:(NSInteger) before
							after:(NSInteger) after;

-(NSAttributedString*) formattedSequenceFromPosition:(NSInteger) pos
											  before:(NSInteger) before
											   after:(NSInteger) after;
-(NSAttributedString*) focusPositionFormattedString;

-(NSRange) focusRange;

@end