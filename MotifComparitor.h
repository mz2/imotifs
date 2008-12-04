//
//  MotifComparitor.h
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IMDoubleMatrix2DIface.h>
@class IMIntMatrix2D;
@class Multinomial;
@class Motif;
@class IMMotifComparisonMatrixBundle;
@class ScoreOffsetPair;

@interface MotifComparitor : NSObject {
    double exponentRatio;
}

@property (readonly) double exponentRatio;

-(id) initWithExponentRatio:(double) ratio;

-(id<IMDoubleMatrix2DIface>) bestHitsFrom:(NSArray*)motifSet0 to:(NSArray*)motifSet1;
-(id<IMDoubleMatrix2DIface>) bestHitsBetween:(NSArray*) motifSet;

-(NSArray*) allMotifPairHitsFrom:(NSArray*) motifSet0 
                              to:(NSArray*)set1 
                       threshold:(double)thresh;
-(NSArray*) bestMotifPairsHitsFrom:(NSArray*) motifSet0 
                                to:(NSArray*)set1;
-(NSArray*) bestReciprocalHitsFrom:(NSArray*) motifSet0 
                                to:(NSArray*)set1;

-(double) compareMotif:(Motif*)motif0 
            background:(Multinomial*)bg0 
               toMotif:(Motif*)motif1
            background:(Multinomial*)bg1;

-(ScoreOffsetPair*) compareWithOffsetsMotif:(Motif*)motif0 
            background:(Multinomial*)bg0 
               toMotif:(Motif*)motif1
            background:(Multinomial*)bg1;


-(IMMotifComparisonMatrixBundle*) comparisonMatrixBundleOfMotifs:(NSArray*)motifs0 
                                                      withMotifs:(NSArray*)motifs1;
-(IMMotifComparisonMatrixBundle*) comparisonMatrixBundleOfMotifs:(NSArray*)motifs;

+ (MotifComparitor*) sharedMotifComparitor;
@end
