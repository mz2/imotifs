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