//
//  ScoreOffsetPair.h
//  iMotifs
//
//  Created by Matias Piipari on 12/3/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ScoreOffsetPair : NSObject {
    double score;
    NSInteger offset;
}
-(id) initWithScore:(double)s offset:(NSInteger)offs;
@property (readonly) double score;
@property (readonly) NSInteger offset;
@end
