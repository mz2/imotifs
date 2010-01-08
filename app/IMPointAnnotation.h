//
//  IMPointAnnotation.h
//  iMotifs
//
//  Created by Matias Piipari on 07/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IMPointAnnotation : NSObject {
	NSInteger _position;
	
}

@property(nonatomic,assign)NSInteger position;

- (id)initWithPosition:(NSInteger)aPosition;
+ (id)pointAnnotationWithPosition:(NSInteger)aPosition;

@end