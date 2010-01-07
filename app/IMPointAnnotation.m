//
//  IMPointAnnotation.m
//  iMotifs
//
//  Created by Matias Piipari on 07/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "IMPointAnnotation.h"


@implementation IMPointAnnotation

@synthesize position = _position;

// init
- (id)init
{
    if (self = [super init]) {
        [self setPosition: 0];
    }
    return self;
}

- (id)initWithPosition:(NSInteger)aPosition  
{
    if (self = [super init]) {
        [self setPosition:aPosition];
    }
    return self;
}

+ (id)pointAnnotationWithPosition:(NSInteger)aPosition  
{
    id result = [[[self class] alloc] initWithPosition:aPosition];
	
    return [result autorelease];
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
	
    [super dealloc];
}





@end