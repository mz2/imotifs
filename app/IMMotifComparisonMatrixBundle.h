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
//  IMMotifComparisonMatrixBundle.h
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IMDoubleMatrix2D.h>
#import <IMIntMatrix2D.h>

@interface IMMotifComparisonMatrixBundle : NSObject {
    NSArray *rowMotifs;
    NSArray *colMotifs;
    IMDoubleMatrix2D *senseScoreMatrix; 
    IMDoubleMatrix2D *antisenseScoreMatrix;
    IMIntMatrix2D *senseOffsetMatrix;
    IMIntMatrix2D *antisenseOffsetMatrix;
}

-(IMMotifComparisonMatrixBundle*) initWithBestSenseHitScores: (IMDoubleMatrix2D*) matrix0
                                                     offsets: (IMIntMatrix2D*) matrixOffsets0
                                       andAntisenseHitScores: (IMDoubleMatrix2D*) matrix1
                                                     offsets: (IMIntMatrix2D*) matrixOffsets1
                                                   rowMotifs: (NSArray*)motifs0
                                                   colMotifs: (NSArray*)motifs1;
@property (copy,readonly) NSArray *rowMotifs;
@property (copy,readonly) NSArray *colMotifs;

@property (readonly) IMDoubleMatrix2D *senseScoreMatrix;
@property (readonly) IMDoubleMatrix2D *antisenseScoreMatrix;

@property (readonly) IMIntMatrix2D *senseOffsetMatrix;
@property (readonly) IMIntMatrix2D *antisenseOffsetMatrix;

@end
