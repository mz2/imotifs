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
//  BestHitsOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 12/8/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "MotifComparisonOperation.h"
#import "BestHitsOperation.h"
#import "MotifComparitor.h"
#import "MotifPair.h"
#import "MotifSetDocument.h"
#import "MotifSet.h"

NSString* const IMClosestMotifMatchScoreKey = @"closest-motif-match-score";
NSString* const IMClosestMotifMatchNameKey = @"closest-motif-name";

@implementation BestHitsOperation
@synthesize m1s,m2s,isReciprocal;
@synthesize motifSetDocument=_motifSetDocument;

-(id) initWithComparitor: (MotifComparitor*) comp 
                    from: (NSArray*) am1 
                      to: (NSArray*) am2 {
    return [self initWithComparitor: comp 
                               from: am1 
                                 to: am2 
                         reciprocal: NO];
}
    

-(id) initWithComparitor: (MotifComparitor*) comp 
                    from: (NSArray*) am1 
                      to: (NSArray*) am2
              reciprocal: (BOOL) recip {
    [super initWithComparitor: comp];
    m1s = [am1 retain];
    m2s = [am2 retain];
    isReciprocal = recip;
    return self;
}

-(void) dealloc {
    [m1s release];
    [m2s release];
    [super dealloc];
}

-(void) run {
    PCLog(@"Running BestHitsOperation");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self performSelectorOnMainThread:@selector(startProcessing) withObject:nil waitUntilDone:NO];

    NSArray *bestHitPairs;
    if (isReciprocal) {
        bestHitPairs = [comparitor bestReciprocalHitsFrom: m1s to: m2s];
    }
    else {
        bestHitPairs = [comparitor bestMotifPairsHitsFrom: m1s to: m2s];
    }
        
    [self performSelectorOnMainThread:@selector(endProcessing) withObject:nil waitUntilDone:NO];

    NSError *error;
    MotifSetDocument *msetDocument = [[NSDocumentController sharedDocumentController] 
                                      makeUntitledDocumentOfType:@"Motif set" 
                                      error:&error];
    
    if (msetDocument) {
        for (MotifPair *mp in bestHitPairs) {
            Motif *m1 = [[Motif alloc] initWithMotif: mp.m1];
            Motif *m2;
            if ([mp flipped]) 
                m2 = [[Motif alloc] initWithMotif: [mp.m2 reverseComplement]];
            else
                m2 = [[Motif alloc] initWithMotif: mp.m2];
            [m2 setOffset: mp.offset];
            
            [[m1 annotations] setObject: [NSNumber numberWithFloat:mp.score] 
                                 forKey: IMClosestMotifMatchScoreKey];
            [[m1 annotations] setObject: m2.name forKey: IMClosestMotifMatchNameKey];
            
            [[m2 annotations] setObject: [NSNumber numberWithFloat:mp.score] 
                                 forKey: IMClosestMotifMatchScoreKey];
            [[m2 annotations] setObject: m1.name forKey: IMClosestMotifMatchNameKey];
              
             
            [[msetDocument motifSet] addMotif: m1]; 
            [[msetDocument motifSet] addMotif: m2];
            NSLog(@"%@ -> %@ : %d (%d)",
                  m1.name,
                  m2.name,
                  mp.offset,
                  mp.flipped);
        }
        
        //[[NSDocumentController sharedDocumentController] addDocument: msetDocument];
        [[NSDocumentController sharedDocumentController] performSelectorOnMainThread: @selector(addDocument:) 
                                                                          withObject: msetDocument 
                                                                       waitUntilDone: YES];
        [msetDocument performSelectorOnMainThread: @selector(makeWindowControllers) 
                                       withObject: nil
                                    waitUntilDone: YES];
        [msetDocument performSelectorOnMainThread: @selector(showWindows) 
                                       withObject: nil 
                                    waitUntilDone: YES];
        
    } else {
        NSAlert *alert = [NSAlert alertWithError:error];
        int button = [alert runModal];
        if (button != NSAlertFirstButtonReturn) {
            // handle
        }
    }
    [pool release];
}


-(void) startProcessing {
    [self.motifSetDocument.alignmentProgressIndicator setHidden: NO];
    [self.motifSetDocument.alignmentProgressIndicator startAnimation: self];
}

-(void) endProcessing {
    [self.motifSetDocument.alignmentProgressIndicator stopAnimation: self];
    [self.motifSetDocument.alignmentProgressIndicator setHidden: YES];
}
@end
