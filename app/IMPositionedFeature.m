//
//  IMPositionedFeature.m
//  iMotifs
//
//  Created by Matias Piipari on 13/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "IMPositionedFeature.h"


@implementation IMPositionedFeature

-(BOOL) overlapsWithPosition:(NSInteger) pos {
	@throw [NSException exceptionWithName:@"IMUnimplementedMethodException" 
								   reason:nil userInfo:nil];
}

-(BOOL) overlapsWithRange:(NSRange) range {
	@throw [NSException exceptionWithName:@"IMUnimplementedMethodException" 
								   reason:nil userInfo:nil];	
}

@end
