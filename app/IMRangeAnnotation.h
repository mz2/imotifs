//
//  IMRangeAnnotation.h
//  iMotifs
//
//  Created by Matias Piipari on 07/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IMRangeAnnotation : NSObject {
	NSInteger _start;
	NSInteger _end;
	
	CGFloat _score;
	
	BOOL _selected;
}

@property(nonatomic,assign)NSInteger start;
@property(nonatomic,assign)NSInteger end;
@property(nonatomic,assign)CGFloat score;
@property(nonatomic,assign,setter=isSelected) BOOL selected;

-(NSInteger) length;

// init
- (id)init;
- (id)initWithStart:(NSInteger)aStart end:(NSInteger)anEnd score:(CGFloat)score;
+ (id)rangeAnnotationWithStart:(NSInteger)aStart end:(NSInteger)anEnd score:(CGFloat)score;

-(BOOL) overlapsWithPosition:(NSInteger) pos;
@end