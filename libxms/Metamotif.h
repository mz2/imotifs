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

@interface Metamotif : Motif <NSCopying, NSCoding> {

}

-(id)initWithAlphabet:(Alphabet*) alpha
               andColumns:(NSArray*) columns;
-(id)initWithAlphabet:(Alphabet*) alpha
      fromConsensusString:(NSString*) str;

@end
