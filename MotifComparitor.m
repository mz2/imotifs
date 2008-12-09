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
#import "IMIntMatrix2DTranspose.h"
#import "IMIntMatrix2D.h"
#import "IMMatrix2D.h"
#import "Multinomial.h"
#import "MotifPair.h"
#import "IMNSArrayExtras.h"
#import "IMDoubleMatrix2D.h"
#import "IMMotifComparisonMatrixBundle.h"
#import "ScoreOffsetPair.h"


@interface MotifComparitor (private)
-(NSArray*) comparisonMatrixBetwMotifs:(NSArray*)motifs0 
                            withMotifs:(NSArray*)motifs1;
-(NSArray*) comparisonMatrixBetwMotifs:(NSArray*)motifs;
-(NSArray*) bestMotifPairHitsFrom:(NSArray*) motifSet0 to:(NSArray**)set1 flip:(BOOL)flipped;

@end

@implementation MotifComparitor
@synthesize exponentRatio, indicator;

-(id) initWithExponentRatio: (double) ratio 
          progressIndicator: (NSProgressIndicator*)ind {
	self = [super init];
	if (self != nil) {
		exponentRatio = ratio;
        indicator = [ind retain];
	}
	return self;
}

-(void) dealloc {
    [indicator release];
    [super dealloc];
}

-(NSArray*) comparisonMatrixBetwMotifs:(NSArray*)motifs0 
                            withMotifs:(NSArray*)motifs1 {
    NSUInteger m0count,m1count;
    m0count = [motifs0 count];
    m1count = [motifs1 count];
    
    IMDoubleMatrix2D *dMatrix = [[IMDoubleMatrix2D alloc] initWithRows:m0count cols:m1count];
    IMDoubleMatrix2D *fMatrix = [[IMDoubleMatrix2D alloc] initWithRows:m0count cols:m1count];
    
    Alphabet *alpha = [[motifs0 objectAtIndex:0] alphabet];
    //NSUInteger step = 0;
    Multinomial *elsewhere = [[[Multinomial alloc] initWithAlphabet:alpha] autorelease];
    NSUInteger i,j;
    for (i = 0; i < m0count; i++) {
        for (j = 0; j < m1count; j++) {
			double fval = [self compareMotif:[motifs0 objectAtIndex:i] 
								  background:elsewhere 
									 toMotif:[motifs1 objectAtIndex:j] 
								  background:elsewhere];
			double rval = [self compareMotif:[motifs0 objectAtIndex:i] 
								  background:elsewhere 
									 toMotif:[[motifs1 objectAtIndex:j] reverseComplement] 
								  background:elsewhere];
            [dMatrix setValue:fval row:i col:j];
            [fMatrix setValue:rval row:i col:j];
            //++step;
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

-(NSArray*) bestMotifPairHitsFrom: (NSArray*)motifs0 
                               to: (NSArray*)motifs1 
                      senseScores: (IMDoubleMatrix2D*) dMatrix 
                     senseOffsets: (IMIntMatrix2D*) dOffsetMatrix
                  antisenseScores: (IMDoubleMatrix2D*) fMatrix 
                 antisenseOffsets: (IMIntMatrix2D*) fOffsetMatrix
                             flip:(BOOL)flipped {
    NSMutableArray *mpairs = [NSMutableArray array];
    
    NSUInteger i,j,m0count,m1count;
    m0count = [motifs0 count];
    m1count = [motifs1 count];
    double incrementSize = 1.0 / (double)m0count * 100.0;
    
    for (i = 0; i < m0count; i++) {
        [indicator incrementBy:incrementSize];
        NSLog(@"indicator state: %.3f",[indicator doubleValue]);
        NSUInteger bestJ = -1;
        double bestScore = positiveInfinity;
        NSUInteger bestOffset = NSUIntegerMax;
        BOOL bestIsFlipped = NO;
        for (j = 0,m1count = [motifs1 count]; j < m1count; j++) {
            {
                double score = [dMatrix valueAtRow:i 
                                               col:j];
                if (score < bestScore) {
                    bestScore = score;
                    bestJ = j;
                    bestIsFlipped = NO;
                    bestOffset = [dOffsetMatrix valueAtRow:i col:j];
                }                
            }
            
            {
                double score = [fMatrix valueAtRow:i 
                                               col:j];
                if (score < bestScore) {
                    bestScore = score;
                    bestJ = j;
                    bestIsFlipped = YES;
                    bestOffset = [fOffsetMatrix valueAtRow:i col:j];
                }
            }
            
        }
        
		NSLog(@"i:%d bestJ:%d bestOffset:%d",i,bestJ,bestOffset);
        MotifPair *mpair = [[MotifPair alloc] initWithMotif: [motifs0 objectAtIndex:i] 
                                                   andMotif: [motifs1 objectAtIndex:bestJ] 
                                                      score: bestScore
                                                    flipped: bestIsFlipped
                                                     offset: bestOffset];
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
            
			NSLog(@"Setting value %d %d", i, j);
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
                                                              score:best 
                                                            flipped:bestIsFlipped
                                                             offset:0];
                [array addObject:mpair];
                [mpair release];
            }
        }
    }
    return [array autorelease];
}

-(NSArray*) bestMotifPairsHitsFrom:(NSArray*) motifs0 
                                to:(NSArray*) motifs1 {
    //[indicator setHidden: NO];
    //[indicator setDoubleValue:0.0];
    //[indicator startAnimation: self];
    IMMotifComparisonMatrixBundle *matrices = [self comparisonMatrixBundleOfMotifs:motifs0 
                                                  withMotifs:motifs1];
    IMDoubleMatrix2D *dMatrix = [matrices senseScoreMatrix];
    IMDoubleMatrix2D *fMatrix = [matrices antisenseScoreMatrix];
    IMIntMatrix2D *dOffsetMatrix = [matrices senseOffsetMatrix];
    IMIntMatrix2D *fOffsetMatrix = [matrices antisenseOffsetMatrix];
    
    
	//NSLog(@"Getting best motif pair hits between motif sets");
    NSArray *mpairs = [self bestMotifPairHitsFrom: motifs0 
                                               to: motifs1 
                                      senseScores: dMatrix
                                     senseOffsets: dOffsetMatrix
                                  antisenseScores: fMatrix
                                 antisenseOffsets: fOffsetMatrix
                                             flip: NO];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] 
                                         initWithKey:@"score" 
                                         ascending:YES 
                                         selector:@selector(compare:)] autorelease];
    
    //[indicator setDoubleValue:100.0];
    //[indicator stopAnimation: self];
    //[indicator setHidden: YES];
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
    IMMotifComparisonMatrixBundle *matrices = [self comparisonMatrixBundleOfMotifs:motifs0 withMotifs:motifs1];
    IMDoubleMatrix2D *dMatrix = [matrices senseScoreMatrix];
    IMDoubleMatrix2D *fMatrix = [matrices antisenseScoreMatrix];
    IMIntMatrix2D *dOffsetMatrix = [matrices senseOffsetMatrix];
    IMIntMatrix2D *fOffsetMatrix = [matrices antisenseOffsetMatrix];
    
    NSArray *mpairs = [self bestMotifPairHitsFrom:motifs0 
                             to: motifs1 
                    senseScores: dMatrix 
                   senseOffsets: dOffsetMatrix
                antisenseScores: fMatrix 
                antisenseOffsets: fOffsetMatrix
                           flip: NO];
    
    NSArray *mpairsTransp = [self bestMotifPairHitsFrom: motifs0 
                                                     to: motifs1 
                                            senseScores: [IMDoubleMatrix2DTranspose transpose:dMatrix] 
                                           senseOffsets: [IMIntMatrix2DTranspose transpose:dOffsetMatrix]
                                        antisenseScores: [IMDoubleMatrix2DTranspose transpose:fMatrix]
                                       antisenseOffsets: [IMIntMatrix2DTranspose transpose:fOffsetMatrix]
                                                   flip: YES];
    
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
        double sym0w = [d0 weightForSymbol:sym];
		double sym1w = [d1 weightForSymbol:sym];
		//NSLog(@"%.3f %.3f %.3f %.3f %.3f",sym0w, sym1w, sym0w - sym1w, pow(sym0w - sym1w, 2.0), cScore);
		cScore += pow(sym0w - sym1w, 2.0);
    }
    //NSLog(@"%.3f %.3f %.3f", cScore, pow(cScore, exponentRatio), exponentRatio);
	double val = pow(cScore, exponentRatio);
	//NSLog(@"%.3f",val);
    return val;
}

- (ScoreOffsetPair*) compareWithOffsetsMotif:(Motif*)wm0 
                       background:(Multinomial*)pad0 
                          toMotif:(Motif*)wm1
                       background:(Multinomial*)pad1 {
    double bestScore = positiveInfinity;
    int bestOffset = 0;
    
    int wm0cols = [wm0 columnCount];
    int wm1cols = [wm1 columnCount];
    int minPos = -wm1cols;
    int maxPos = wm0cols + wm1cols;
    
    int offset;
    for (offset = -wm1cols; offset <= wm0cols; ++offset) {
        double score = 0.0;
        int pos;
        for (pos = minPos; pos <= maxPos; ++pos) {
            Multinomial *col0 = pad0, *col1 = pad1;
            if (pos >= 0 && pos < wm0cols) {
                col0 = [wm0 column:pos];
            }
            int opos = pos - offset;
            if (opos >= 0 && opos < wm1cols) {
                col1 = [wm1 column:opos];
            }
            double cScore = [self divMultinomial:col0 
                                 withMultinomial:col1];
            score += cScore;
        }
        if (score < bestScore) {
            bestScore = score;
            bestOffset =  offset;
        }
    }
    return [[[ScoreOffsetPair alloc] initWithScore: bestScore 
                                            offset: bestOffset] autorelease];
}

- (double) compareMotif:(Motif*)wm0 
             background:(Multinomial*)pad0 
                toMotif:(Motif*)wm1
             background:(Multinomial*)pad1 {
    double bestScore = positiveInfinity;
    
    int wm0cols = [wm0 columnCount];
    int wm1cols = [wm1 columnCount];
    int minPos = -wm1cols;
    int maxPos = wm0cols + wm1cols;
    
    int offset;
    for (offset = -wm1cols; offset <= wm0cols; ++offset) {
        double score = 0.0;
        int pos;
        for (pos = minPos; pos <= maxPos; ++pos) {
            Multinomial *col0 = pad0, *col1 = pad1;
            if (pos >= 0 && pos < wm0cols) {
                col0 = [wm0 column:pos];
            }
            int opos = pos - offset;
            if (opos >= 0 && opos < wm1cols) {
                col1 = [wm1 column:opos];
            }
            double cScore = [self divMultinomial:col0 
                                 withMultinomial:col1];
            score += cScore;
        }
        bestScore = fmin(score, bestScore);
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
*/

-(IMMotifComparisonMatrixBundle*) comparisonMatrixBundleOfMotifs:(NSArray*)motifs {
    return nil;
}

-(IMMotifComparisonMatrixBundle*) comparisonMatrixBundleOfMotifs:(NSArray*)motifs0 
                                                      withMotifs:(NSArray*)motifs1 {
    //[indicator setHidden: NO];
    [indicator startAnimation: self];
    
    int m0count = motifs0.count;
    int m1count = motifs1.count;
    Alphabet *alpha = [[motifs0 objectAtIndex:0] alphabet];
    IMDoubleMatrix2D *dMatrix = [[IMDoubleMatrix2D alloc] initWithRows:m0count cols:m1count];
    IMDoubleMatrix2D *fMatrix = [[IMDoubleMatrix2D alloc] initWithRows:m0count cols:m1count];
    IMIntMatrix2D *dOffsetMatrix = [[IMIntMatrix2D alloc] initWithRows:m0count cols:m1count];
    IMIntMatrix2D *fOffsetMatrix = [[IMIntMatrix2D alloc] initWithRows:m0count cols:m1count];
    
    Multinomial *elsewhere = [[[Multinomial alloc] initWithAlphabet:alpha] autorelease];
    [indicator setDoubleValue:0.0];
    double incrementSize = 1.0 / (double)m0count * 100.0;
    int i;
    for (i = 0; i < m0count; i++) {
        
        //setDoubleValue rather than incrementBy used because of multithreading
        [indicator setDoubleValue:incrementSize * (double)i];
        int j;
        for (j = 0; j < m1count; j++) {
            ScoreOffsetPair *dsp = [self compareWithOffsetsMotif: [motifs0 objectAtIndex:i]
                                                      background: elsewhere 
                                                         toMotif: [motifs1 objectAtIndex:j] 
                                                      background: elsewhere];
            [dMatrix setValue:dsp.score row:i col:j];
            [dOffsetMatrix setValue:dsp.offset row:i col:j];

            ScoreOffsetPair *fsp = [self compareWithOffsetsMotif: [motifs0 objectAtIndex:i]
                                                      background: elsewhere 
                                                         toMotif: [[motifs1 objectAtIndex:j] reverseComplement] 
                                                      background: elsewhere];
            
            [fMatrix setValue:fsp.score row:i col:j];
            [fOffsetMatrix setValue:fsp.offset row:i col:j];
        }
    }
    
    [indicator stopAnimation: self];
    
    return [[[IMMotifComparisonMatrixBundle alloc] initWithBestSenseHitScores: dMatrix 
                                                                      offsets: dOffsetMatrix 
                                                        andAntisenseHitScores: fMatrix 
                                                                      offsets: fOffsetMatrix 
                                                                    rowMotifs: motifs0 
                                                                    colMotifs: motifs1] autorelease];
}

/*
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

/*
+(MotifComparitor*) sharedMotifComparitor {
    static MotifComparitor *comparitor;
    @synchronized(self) {
        if (!comparitor) {
            comparitor = [[MotifComparitor alloc] initWithExponentRatio:2.0];
        }
    }
    return comparitor;
}
*/
@end
