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
    NSProgressIndicator *indicator;
}

@property (readonly) double exponentRatio;
@property (readonly) NSProgressIndicator *indicator;

-(id) initWithExponentRatio: (double) ratio 
          progressIndicator: (NSProgressIndicator*)indicator;

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

//+ (MotifComparitor*) sharedMotifComparitor;
@end
