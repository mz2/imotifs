//
//  IMPointFeature.h
//  iMotifs
//
//  Created by Matias Piipari on 07/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMFeature.h"
#import "IMPositionedFeature.h"

@interface IMPointFeature : IMPositionedFeature {
	NSInteger _position;
	
}

@property(nonatomic,assign)NSInteger position;

- (id)initWithPosition:(NSInteger)aPosition
                strand:(IMStrand)strand
				  type:(NSString*) type;
+ (id)pointFeatureWithPosition:(NSInteger)aPosition 
                        strand:(IMStrand)strand
						  type:(NSString*) type;

@end