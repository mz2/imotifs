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
}

@property (readonly) Motif *m1;
@property (readonly) Motif *m2;
@property (readonly) BOOL flipped;
@property (readonly) double score;

-(MotifPair*) initWithMotif:(Motif*)a 
                   andMotif:(Motif*)b 
                  withScore:(double)score 
                  isFlipped:(BOOL)yesno;
@end
