/*
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the
Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
Boston, MA  02110-1301, USA.
*/
//
//  IMMotifComparisonMatrixBundle.m
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "IMMotifComparisonMatrixBundle.h"

@implementation IMMotifComparisonMatrixBundle
@synthesize rowMotifs,colMotifs;
@synthesize senseScoreMatrix,antisenseScoreMatrix;
@synthesize senseOffsetMatrix,antisenseOffsetMatrix;

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
