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

@property (copy,readonly) NSArray *rowMotifs;
@property (copy,readonly) NSArray *colMotifs;

@property (readonly) IMDoubleMatrix2D *senseScoreMatrix;
@property (readonly) IMDoubleMatrix2D *antisenseScoreMatrix;

@property (readonly) IMIntMatrix2D *senseOffsetMatrix;
@property (readonly) IMIntMatrix2D *antisenseOffsetMatrix;

@end
