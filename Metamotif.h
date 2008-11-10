//
//  Metamotif.h
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Alphabet.h"
#import "Motif.h"

@interface Metamotif : Motif {

}

-(Motif*)initWithAlphabet:(Alphabet*) alpha
               andColumns:(NSArray*) columns;
-(Motif*)initWithAlphabet:(Alphabet*) alpha
      fromConsensusString:(NSString*) str;

@end
