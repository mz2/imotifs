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
//  MotifsBelowDistanceCutoffOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 1/5/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "MotifsBelowDistanceCutoffOperation.h"
#import "MotifComparitor.h"
#import "MotifSetController.h"
#import "Multinomial.h"
#import "IMAppController.h"
#import "Motif.h"


@implementation MotifsBelowDistanceCutoffOperation
@synthesize motif, motifSetController;
- (id) initWithComparitor: (MotifComparitor*) comp 
                    motif: (Motif*) m 
againstMotifsControlledBy: (MotifSetController*) msc {
    self = [super init];
    if (self != nil) {
        [super initWithComparitor: comp];
        motif = [m retain];
        motifSetController = [msc retain];
    }
    return self;
}

-(void) dealloc {
    [motif release];
    [motifSetController release];
    [super dealloc];
}

-(void) run {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];    
    PCLog(@"Running MotifsBelowDistanceCutoffOperation");
    Multinomial *elsewhere = [Multinomial multinomialWithAlphabet:[Alphabet dna]];
    NSUInteger contentCount = [motifSetController.content count];
    
    [motifSetController setSelectionIndexes:nil];
    
    [comparitor.indicator startAnimation: self];
    [comparitor.indicator setDoubleValue:0.0];
    int i = 0;
    [motifSetController showAll];
    for (Motif *m in motifSetController.content) {
        [comparitor.indicator setDoubleValue: (double)i / (double)contentCount * 100.0];
        double val = [comparitor compareMotif: motif 
                                   background: elsewhere 
                                      toMotif: m 
                                   background: elsewhere];
        if (val >= [[[NSApplication sharedApplication] delegate] consensusSearchCutoff]) {
            PCLog(@"Motif %@ doesn't match below cutoff %.3f",
                  m.name,[[[NSApplication sharedApplication] delegate] consensusSearchCutoff]);
            [motifSetController hideObject:m];
        }
        i++;
    }
    [comparitor.indicator setDoubleValue: 100];
    [comparitor.indicator stopAnimation: self];
    //[comparitor.indicator setHidden: YES];
    PCLog(@"Rearranging after finding ");
    [motifSetController rearrangeObjects];
    [pool release];
    PCLog(@"MotifsBelowDistanceCutoffOperation done.");
    
}
@end
