//
//  MotifsBelowDistanceCutoffOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 1/5/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MotifComparisonOperation.h"
@class Motif;
@class MotifSetController;

@interface MotifsBelowDistanceCutoffOperation : MotifComparisonOperation {
    Motif *motif;
    MotifSetController *motifSetController;
}

@property (retain,readonly) Motif* motif;
@property (retain,readonly) MotifSetController *motifSetController;


- (id) initWithComparitor: (MotifComparitor*) comp 
                    motif: (Motif*) motif 
againstMotifsControlledBy: (MotifSetController*) motifSetController;

@end
