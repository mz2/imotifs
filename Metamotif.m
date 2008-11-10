//
//  Metamotif.m
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "Metamotif.h"
#import "Alphabet.h"

@implementation Metamotif

-(Motif*)initWithAlphabet:(Alphabet*) a
               andColumns:(NSArray*) c {
    return [super initWithAlphabet: a 
                        andColumns: c];
}
-(Motif*)initWithAlphabet:(Alphabet*) a
      fromConsensusString:(NSString*) s {
    return [super initWithAlphabet: a 
               fromConsensusString: s];
}

@end
