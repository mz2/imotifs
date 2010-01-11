//
//  IMPointFeature.h
//  iMotifs
//
//  Created by Matias Piipari on 07/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMFeature.h"

@interface IMPointFeature : IMFeature {
	NSInteger _position;
	
}

@property(nonatomic,assign)NSInteger position;

- (id)initWithPosition:(NSInteger)aPosition
                strand:(IMStrand)strand;
+ (id)pointFeatureWithPosition:(NSInteger)aPosition 
                        strand:(IMStrand)strand;

@end