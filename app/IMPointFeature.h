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

- (id)initWithPosition:(NSInteger)aPosition;
+ (id)pointFeatureWithPosition:(NSInteger)aPosition;

@end