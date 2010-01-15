//
//  IMFeature.m
//  iMotifs
//
//  Created by Matias Piipari on 08/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IMFeature.h"


@implementation IMFeature
@synthesize score = _score;
@synthesize selected = _selected;
@synthesize strand = _strand;
@synthesize type = _type;
@synthesize color = _color;


-(void) dealloc {
	[_type release], _type = nil;
	[super dealloc];
}

@end
