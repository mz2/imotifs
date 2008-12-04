//
//  MotifPair.h
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MotifPair.h"
#import "Motif.h"

@interface MotifPair : NSObject {
    Motif* m1;
    Motif* m2;
    BOOL flipped;
    double score;
    NSInteger offset;
}

@property (readonly) Motif *m1;
@property (readonly) Motif *m2;
@property (readonly) BOOL flipped;
@property (readonly) double score;
@property (readonly) NSInteger offset;

-(MotifPair*) initWithMotif: (Motif*)a 
                   andMotif: (Motif*)b 
                      score: (double)score 
                    flipped: (BOOL)yesno 
                     offset: (NSInteger) offset;
@end
