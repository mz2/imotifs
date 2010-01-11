//
//  BestHitsOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 12/8/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MotifComparisonOperation.h"
@class Motif;
@class MotifSetDocument;

extern NSString* const IMClosestMotifMatchScoreKey;
extern NSString* const IMClosestMotifMatchNameKey;

@interface BestHitsOperation : MotifComparisonOperation {
    NSArray *m1s;
    NSArray *m2s;
    
    MotifSetDocument *_motifSetDocument;
    
    @private
    BOOL isReciprocal;
}

-(id) initWithComparitor: (MotifComparitor*) comp 
                    from: (NSArray*) am1 
                      to: (NSArray*) am2;

-(id) initWithComparitor: (MotifComparitor*) comp 
                    from: (NSArray*) am1 
                      to: (NSArray*) am2
              reciprocal: (BOOL) recip;

@property (retain,readonly) NSArray *m1s;
@property (retain,readonly) NSArray *m2s;
@property (readonly) BOOL isReciprocal;

@property (nonatomic,retain) MotifSetDocument *motifSetDocument;

@end
