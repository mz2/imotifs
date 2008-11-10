//
//  IMMotifComparisonMatrixBundle.m
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "IMMotifComparisonMatrixBundle.h"

@implementation IMMotifComparisonMatrixBundle
@synthesize rowMotifs;
@synthesize colMotifs;
@synthesize senseScoreMatrix; 
@synthesize antisenseScoreMatrix;
@synthesize senseOffsetMatrix;
@synthesize antisenseOffsetMatrix;

-(IMMotifComparisonMatrixBundle*) initWithBestSenseHitScores:(IMDoubleMatrix2D*) matrix0
                                                     offsets:(IMIntMatrix2D*) matrixOffsets0
                                       andAntisenseHitScores:(IMDoubleMatrix2D*) matrix1
                                                     offsets:(IMIntMatrix2D*) matrixOffsets1
                                                   rowMotifs:(NSArray*)motifs0
                                                   colMotifs:(NSArray*)motifs1 {
    self = [super init];
    if (self != nil) {
        senseScoreMatrix = [matrix0 retain];
        antisenseScoreMatrix = [matrix1 retain];
        senseOffsetMatrix = [matrixOffsets0 retain];
        antisenseOffsetMatrix = [matrixOffsets1 retain];
        rowMotifs = [motifs0 retain];
        colMotifs = [motifs1 retain];
    }
    return self;
   
}

@end
