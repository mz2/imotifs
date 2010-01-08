//
//  IMRangeAnnotation.h
//  iMotifs
//
//  Created by Matias Piipari on 07/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMFeature.h"

@interface IMRangeFeature : IMFeature {
    NSInteger _start;
	NSInteger _end;
}

@property(nonatomic,assign) NSInteger start;
@property(nonatomic,assign) NSInteger end;

-(NSInteger) length;

// init
- (id)init;
- (id)initWithStart:(NSInteger)aStart 
                end:(NSInteger)anEnd
              score:(CGFloat)score
             strand:(IMStrand)strand;
+ (id)rangeFeatureWithStart:(NSInteger)aStart 
                        end:(NSInteger)anEnd
                      score:(CGFloat)score
                     strand:(IMStrand)strand;

-(BOOL) overlapsWithPosition:(NSInteger) pos;
@end