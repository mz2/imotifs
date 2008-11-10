//
//  MotifComparitor.m
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <math.h>
#import "MotifComparitor.h"
#import "IMDoubleMatrix2DTranspose.h"
#import "IMIntMatrix2D.h"
#import "IMMatrix2D.h"
#import "Multinomial.h"
#import "MotifPair.h"
#import "IMNSArrayExtras.h"
#import "IMDoubleMatrix2D.h"


@interface MotifComparitor (private)
-(NSArray*) comparisonMatrixBetwMotifs:(NSArray*)motifs0 
                            withMotifs:(NSArray*)motifs1;
-(NSArray*) comparisonMatrixBetwMotifs:(NSArray*)motifs;
-(NSArray*) bestMotifPairHitsFrom:(NSArray*) motifSet0 to:(NSArray**)set1 flip:(BOOL)flipped;

@end

@implementation MotifComparitor
@synthesize exponentRatio;
-(NSArray*) comparisonMatrixBetwMotifs:(NSArray*)motifs0 
                            withMotifs:(NSArray*)motifs1 {
    NSUInteger m0count,m1count;
    m0count = [motifs0 count];
    m1count = [motifs1 count];
    
    IMDoubleMatrix2D *dMatrix = [[IMDoubleMatrix2D alloc] initWithRows:m0count cols:m1count];
    IMDoubleMatrix2D *fMatrix = [[IMDoubleMatrix2D alloc] initWithRows:m0count cols:m1count];
    
    Alphabet *alpha = [[motifs0 objectAtIndex:0] alphabet];
    NSUInteger step = 0;
    Multinomial *elsewhere = [[[Multinomial alloc] initWithAlphabet:alpha] autorelease];
    NSUInteger i,j;
    for (i = 0; i < m0count; i++) {
        for (j = 0; j < m1count; j++) {
            [dMatrix setValue:[self compareMotif:[motifs0 objectAtIndex:i] 
                                      background:elsewhere 
                                         toMotif:[motifs1 objectAtIndex:j] 
                                      background:elsewhere] 
                          row:i 
                          col:j];
            [fMatrix setValue:[self compareMotif:[motifs0 objectAtIndex:i] 
                                      background:elsewhere 
                                         toMotif:[[motifs1 objectAtIndex:j] reverseComplement] 
                                      background:elsewhere] 
                          row:i 
                          col:j];
            ++step;
        }
    }
    
    NSArray *array = [NSArray arrayWithObjects:dMatrix,fMatrix,nil];
    [dMatrix release];
    [fMatrix release];
    return array;
}

-(NSArray*) comparisonMatrixBetwMotifs:(NSArray*)motifs {
    NSUInteger mcount = [motifs count];
    IMDoubleMatrix2D *dMatrix = [[IMDoubleMatrix2D alloc] initWithRows:mcount 
                                                                  cols:mcount];
    IMDoubleMatrix2D *fMatrix = [[IMDoubleMatrix2D alloc] initWithRows:mcount 
                                                                  cols:mcount];
    
    Alphabet *alpha = [[motifs objectAtIndex:0] alphabet];
    Multinomial *elsewhere = [[[Multinomial alloc] initWithAlphabet:alpha] autorelease];
    
    NSUInteger i,j;
    for (i = 0; i < mcount; i++) {
        for (j = (i+1); j < mcount; j++) {
            [dMatrix setValue:[self compareMotif:[motifs objectAtIndex:i] 
                                      background:elsewhere 
                                         toMotif:[motifs objectAtIndex:j] 
                                      background:elsewhere] 
                          row:i 
                          col:j];
            [fMatrix setValue:[self compareMotif:[motifs objectAtIndex:i] 
                                      background:elsewhere 
                                         toMotif:[[motifs objectAtIndex:j] reverseComplement] 
                                      background:elsewhere] 
                          row:i 
                          col:j];
        }
    }
    
    NSArray *array = [NSArray arrayWithObjects:dMatrix,fMatrix,nil];
    [dMatrix release];
    [fMatrix release];
    return array;
}

-(NSArray*) bestMotifPairHitsFrom:(NSArray*)motifs0 
                               to:(NSArray*)motifs1 
                      senseScores:(IMDoubleMatrix2D*) dMatrix 
                  antisenseScores:(IMDoubleMatrix2D*) fMatrix 
                             flip:(BOOL)flipped {
    NSMutableArray *mpairs = [NSMutableArray array];
    
    NSUInteger i,j,m0count,m1count;
    for (i = 0, m0count = [motifs0 count]; i < m0count; i++) {
        NSUInteger bestJ = -1;
        double bestScore = positiveInfinity;
        BOOL bestIsFlipped = NO;
        for (j = 0,m1count = [motifs1 count]; j < m1count; j++) {
            
            {
                double score = [dMatrix valueAtRow:i 
                                               col:j];
                if (score < bestScore) {
                    bestScore = score;
                    bestJ = j;
                    bestIsFlipped = NO;
                }                
            }
            
            {
                double score = [fMatrix valueAtRow:i 
                                               col:j];
                if (score < bestScore) {
                    bestScore = score;
                    bestJ = j;
                    bestIsFlipped = YES;
                }
            }
            
        }
        
        MotifPair *mpair = [[MotifPair alloc] initWithMotif:[motifs0 objectAtIndex:i] 
                                                   andMotif:[motifs1 objectAtIndex:j] 
                                                  withScore:bestScore
                                                  isFlipped:bestIsFlipped];
        [mpairs addObject:mpair];
        [mpair release];
    } 
    return mpairs;
}

-(id<IMDoubleMatrix2DIface>) bestHitsFrom:(NSArray*)motifs0 to:(NSArray*)motifs1 {
    NSArray *matrices = [self comparisonMatrixBetwMotifs:motifs0 
                                              withMotifs:motifs1];
    IMDoubleMatrix2D *dMatrix = [matrices objectAtIndex:0];
    IMDoubleMatrix2D *fMatrix = [matrices objectAtIndex:1];
    NSUInteger m0count,m1count;
    m0count = [motifs0 count];
    m1count = [motifs1 count];
    
    IMDoubleMatrix2D *hitMatrix = [[IMDoubleMatrix2D alloc] initWithRows:m0count
                                                                     cols:m1count];
    
    NSUInteger i,j;
    for (i = 0; i < m0count; i++) {
        for (j = 0; j < m1count; j++) {
            double d = [dMatrix valueAtRow:i 
                                       col:j];
            double f = [fMatrix valueAtRow:i 
                                       col:j];
            
            double best;
            BOOL bestIsFlipped;
            if (d < f) {
                best = d; bestIsFlipped = NO;
            } else {
                best = f; bestIsFlipped = YES;
            }
            
            [hitMatrix setValue:best 
                            row:i 
                            col:j];
        }
    }
    
    return [hitMatrix autorelease];
}

-(id<IMDoubleMatrix2DIface>) bestHitsBetween:(NSArray*)motifs {
    NSArray *matrices = [self comparisonMatrixBetwMotifs:motifs];
    IMDoubleMatrix2D *dMatrix = [matrices objectAtIndex:0];
    IMDoubleMatrix2D *fMatrix = [matrices objectAtIndex:1];
    NSUInteger mcount = [motifs count];
    
    IMDoubleMatrix2D *hitMatrix = [[IMDoubleMatrix2D alloc] initWithRows:mcount
                                                                    cols:mcount];
    
    NSUInteger i,j;
    for (i = 0; i < mcount; i++) {
        for (j = (i+1); j < mcount; j++) {
            double d = [dMatrix valueAtRow:i 
                                       col:j];
            double f = [fMatrix valueAtRow:i 
                                       col:j];
            
            double best;
            BOOL bestIsFlipped;
            if (d < f) {
                best = d; bestIsFlipped = NO;
            } else {
                best = f; bestIsFlipped = YES;
            }
            
            [hitMatrix setValue:best 
                            row:i 
                            col:j];
        }
    }
    
    return [hitMatrix autorelease];
    
}

-(NSArray*) allMotifPairHitsFrom:(NSArray*) motifs0 
                              to:(NSArray*) motifs1 
                       threshold:(double)thresh {
    NSArray *matrices = [self comparisonMatrixBetwMotifs:motifs0 
                                              withMotifs:motifs1];
    IMDoubleMatrix2D *dMatrix = [matrices objectAtIndex:0];
    IMDoubleMatrix2D *fMatrix = [matrices objectAtIndex:1];
    NSUInteger m0count,m1count;
    m0count = [motifs0 count];
    m1count = [motifs1 count];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSUInteger i,j;
    for (i = 0; i < m0count; i++) {
        for (j = 0; j < m1count; j++) {
            double d = [dMatrix valueAtRow:i 
                                       col:j];
            double f = [fMatrix valueAtRow:i 
                                       col:j];
            
            double best;
            BOOL bestIsFlipped;
            if (d < f) {
                best = d; bestIsFlipped = NO;
            } else {
                best = f; bestIsFlipped = YES;
            }
            
            if (best < thresh) {
                MotifPair *mpair = [[MotifPair alloc] initWithMotif:[motifs0 objectAtIndex:i] 
                                                           andMotif:[motifs1 objectAtIndex:j] 
                                                          withScore:best 
                                                          isFlipped:bestIsFlipped];
                [array addObject:mpair];
                [mpair release];
            }
        }
    }
    return [array autorelease];
}

-(NSArray*) bestMotifPairsHitsFrom:(NSArray*) motifs0 
                                to:(NSArray*) motifs1 {
    NSArray *matrices = [self comparisonMatrixBetwMotifs:motifs0 
                                              withMotifs:motifs1];
    IMDoubleMatrix2D *dMatrix = [matrices objectAtIndex:0];
    IMDoubleMatrix2D *fMatrix = [matrices objectAtIndex:1];
        
    NSArray *mpairs = [self bestMotifPairHitsFrom:motifs0 
                                               to:motifs1 
                                      senseScores:dMatrix 
                                  antisenseScores:fMatrix
                                             flip:NO];    
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] 
                                         initWithKey:@"score" 
                                         ascending:YES 
                                         selector:@selector(compare:)] autorelease];
    
    return [mpairs sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

-(MotifPair*) bestHitBetweenMotifs:(NSArray*)motifs0 andMotifs:(NSArray*)motifs1 {
    NSArray *mpairs = [self bestMotifPairsHitsFrom:motifs0 
                                                to:motifs1];
    double minScore = positiveInfinity;
    MotifPair *bestPair = nil;
    
    for (MotifPair *mp in mpairs) {
        if ([mp score] < minScore) {
            bestPair = mp;
        }
    }
    
    return [bestPair autorelease];
}

-(NSArray*) bestReciprocalHitsFrom:(NSArray*) motifs0 
                                to:(NSArray*) motifs1 {
    NSArray *matrices = [self comparisonMatrixBetwMotifs:motifs0 
                                              withMotifs:motifs1];
    IMDoubleMatrix2D *dMatrix = [matrices objectAtIndex:0];
    IMDoubleMatrix2D *fMatrix = [matrices objectAtIndex:1];
    
    NSArray *mpairs = [self bestMotifPairHitsFrom:motifs0 
                             to:motifs1 
                    senseScores:dMatrix 
                antisenseScores:fMatrix 
                           flip:NO];
    
    NSArray *mpairsTransp = [self bestMotifPairHitsFrom:motifs0 
                                                     to:motifs1 
                                            senseScores:[IMDoubleMatrix2DTranspose transpose:dMatrix] 
                                        antisenseScores:[IMDoubleMatrix2DTranspose transpose:fMatrix]
                                                   flip:YES];
    NSArray *mpairsIntersect = [mpairs retainAll:mpairsTransp];
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] 
                                         initWithKey:@"score" 
                                         ascending:YES 
                                         selector:@selector(compare:)] autorelease];
    
    return [mpairsIntersect sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
}

- (double) divMultinomial:(Multinomial*) d0 
          withMultinomial:(Multinomial*) d1 {
    double cScore = 0.0;
    
    for (Symbol* sym in [[d0 alphabet] symbols]) {
        cScore += pow([d0 weightForSymbol:sym] - [d1 weightForSymbol:sym], 2.0);
    }
    
    return pow(cScore, exponentRatio);
}

- (double) compareMotif:(Motif*)wm0 
             background:(Multinomial*)pad0 
                toMotif:(Motif*)wm1
             background:(Multinomial*)pad1 {
    double bestScore = positiveInfinity;
    
    int minPos = [wm1 columnCount];
    int maxPos = [wm0 columnCount] + [wm1 columnCount];
    
    int offset;
    for (offset = -[wm1 columnCount]; offset <= [wm0 columnCount]; ++offset) {
        double score = 0.0;
        int pos;
        for (pos = minPos; pos <= maxPos; ++pos) {
            Multinomial *col0 = pad0, *col1 = pad1;
            if (pos >= 0 && pos < [wm0 columnCount]) {
                col0 = [wm0 column:pos];
            }
            int opos = pos - offset;
            if (opos >= 0 && opos < [wm1 columnCount]) {
                col1 = [wm1 column:opos];
            }
            double cScore = [self divMultinomial:col0 
                                 withMultinomial:col1];
            score += cScore;
        }
        
        if (score < bestScore) {
            bestScore += score;
        } else {
            bestScore += bestScore;
        }
    }
    return bestScore;
}

/*
public abstract double compareMotifs(
                                     WeightMatrix wm0, 
                                     Distribution pad0, 
                                     WeightMatrix wm1, 
                                     Distribution pad1);


public abstract ScoreOffsetPair compareMotifsWithOffset
(WeightMatrix wm0, Distribution pad0, WeightMatrix wm1, Distribution pad1);

public MotifComparisonMatrixBundle getComparisonMatrixWithOffsets(
                                                                  Motif[] motifs0, Motif[] motifs1) throws IllegalAlphabetException {
    Matrix2D dMatrix = new SimpleMatrix2D(motifs0.length, motifs1.length);
    Matrix2D fMatrix = new SimpleMatrix2D(motifs0.length, motifs1.length);
    IntMatrix2D dOffsetMatrix = new SimpleIntMatrix2D(motifs0.length, motifs1.length);
    IntMatrix2D fOffsetMatrix = new SimpleIntMatrix2D(motifs0.length, motifs1.length);
    
    //Could check alphabets for all motifs here
    Distribution elsewhere = 
    new UniformDistribution(
                            (FiniteAlphabet) 
                            motifs0[0].getWeightMatrix().getAlphabet());
    
    for (int i = 0; i < motifs0.length; ++i) {
        for (int j = 0; j < motifs1.length; ++j) {
            
            ScoreOffsetPair dsp = 
            compareMotifsWithOffset(
                                    motifs0[i].getWeightMatrix(), 
                                    elsewhere, 
                                    motifs1[j].getWeightMatrix(), 
                                    elsewhere);
            
            //System.err.println("dspscore:" + dsp.score);
            dMatrix.set(i, j, dsp.score);
            dOffsetMatrix.set(i, j, dsp.offset);
            
            ScoreOffsetPair fsp = 
            compareMotifsWithOffset(
                                    motifs0[i].getWeightMatrix(), 
                                    elsewhere, 
                                    WmTools.reverseComplement(
                                                              motifs1[j].getWeightMatrix()), 
                                    elsewhere);
            fMatrix.set(i, j, fsp.score);
            fOffsetMatrix.set(i, j, fsp.offset);
        }
    }
	
    return new MotifComparisonMatrixBundle(
                                           dMatrix, 
                                           fMatrix,
                                           dOffsetMatrix,
                                           fOffsetMatrix,
                                           motifs0,
                                           motifs1);
}

public MotifComparisonMatrixBundle getComparisonMatrixWithOffsets(Motif[] set) 
throws IllegalSymbolException, IllegalAlphabetException {
    Matrix2D dMatrix = new SimpleMatrix2D(set.length, set.length);
    Matrix2D fMatrix = new SimpleMatrix2D(set.length, set.length);
    IntMatrix2D dOffsetMatrix = new SimpleIntMatrix2D(set.length, set.length);
    IntMatrix2D fOffsetMatrix = new SimpleIntMatrix2D(set.length, set.length);
    
    Distribution elsewhere = new UniformDistribution((FiniteAlphabet) set[0].getWeightMatrix().getAlphabet());
    
    for (int i = 0; i < set.length; ++i) {
        for (int j = (i+1); j < set.length; ++j) {
            ScoreOffsetPair dsp = 
            compareMotifsWithOffset(
                                    set[i].getWeightMatrix(), 
                                    elsewhere, 
                                    set[j].getWeightMatrix(), 
                                    elsewhere);
            
            dMatrix.set(i, j, dsp.score);
            dOffsetMatrix.set(i, j, dsp.offset);
            
            ScoreOffsetPair fsp = 
            compareMotifsWithOffset(
                                    set[i].getWeightMatrix(), 
                                    elsewhere, 
                                    WmTools.reverseComplement(set[j].getWeightMatrix()), 
                                    elsewhere);
            
            fMatrix.set(i, j, fsp.score);
            //System.err.println(
            //		set[i].getName() + " " + set[j].getName() + 
            //		" SCORE: "+dsp.score+" OFFSET:" + dsp.offset + " not flipped");
            //System.err.println(
            //		set[i].getName() + " " + set[j].getName() + 
            //		"SCORE: "+fsp.score+" OFFSET:" + fsp.offset + " flipped");
            fOffsetMatrix.set(i, j, fsp.offset);
        }
    }
*/

+(MotifComparitor*) sharedMotifComparitor {
    static MotifComparitor *comparitor;
    @synchronized(self) {
        if (!comparitor) {
            comparitor = [[MotifComparitor alloc] init];
        }
    }
    return comparitor;
}

-(IMMotifComparisonMatrixBundle*) comparisonMatrixBundleOfMotifs:(NSArray*)motifs0 
                                                      withMotifs:(NSArray*)motifs1 {
    return nil;
}
-(IMMotifComparisonMatrixBundle*) comparisonMatrixBundleOfMotifs:(NSArray*)motifs {
    return nil;
}

@end
