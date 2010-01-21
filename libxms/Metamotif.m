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
//  Metamotif.m
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "Metamotif.h"
#import "Motif.h"
#import "Alphabet.h"

@implementation Metamotif

-(id)initWithAlphabet:(Alphabet*) a
           andColumns:(NSArray*) c {
    self = [super initWithAlphabet: a 
                        andColumns: c];
    if (self != nil) {
        
    }
    return self;
}

-(id)initWithAlphabet:(Alphabet*) a
      fromConsensusString:(NSString*) s {
    self = [super initWithAlphabet: a 
               fromConsensusString: s];
    if (self != nil) {
        
    }
    return self;
    
}

- (id) initWithCoder:(NSCoder*) coder {
    [super initWithCoder: coder];
    return self;
}

- (void) encodeWithCoder:(NSCoder*) coder {
    [super encodeWithCoder: coder];
}

- (id)copyWithZone:(NSZone *)zone {
    Metamotif *newM = [[Metamotif alloc] initWithAlphabet: [self alphabet] 
                                           andColumns: [[self columns] copyWithZone:zone]];
    
    [newM setName: [[self name] copyWithZone:zone]];
    [newM setOffset: [self offset]];
    [newM setColor: [[self color] retain]];
    newM->annotations = [[self annotations] copyWithZone:zone];
    
    return [newM retain];
}

- (NSString*) description {
    NSMutableString* str = [NSMutableString stringWithFormat:@"[metamotif:%@\n",[self name]];
    
    int col = 0;
    double ent = 0;
    for (Multinomial* m in columns) {
        [str appendFormat:@"%d:%@",col++,m];
        ent += [m informationContent];
    }
    
    [str appendFormat:@"(%.3g bits) consensus: %@ offset:%d color:%@]\n",
     ent, 
     [self consensusString], 
     [self offset], 
     [self color]];
    return str;
}

- (NSArray*) exportedColumns {
    return [columns valueForKey:@"mean"];
}
@end
