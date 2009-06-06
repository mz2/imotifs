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
    DebugLog(@"Running BestHitsOperation");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSArray *bestHitPairs;
    if (isReciprocal) {
        bestHitPairs = [comparitor bestReciprocalHitsFrom: m1s to: m2s];
    }
    else {
        bestHitPairs = [comparitor bestMotifPairsHitsFrom: m1s to: m2s];
    }
        
    NSError *error;
    MotifSetDocument *msetDocument = [[NSDocumentController sharedDocumentController] 
                                      makeUntitledDocumentOfType:@"Motif set" 
                                      error:&error];
    
    if (msetDocument) {
        [[NSDocumentController sharedDocumentController] addDocument: msetDocument];
        [msetDocument makeWindowControllers];
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
            DebugLog(@"%@ -> %@ : %d (%d)",
                  m1.name,
                  m2.name,
                  mp.offset,
                  mp.flipped);
        }
        [msetDocument showWindows];
        
    } else {
        NSAlert *alert = [NSAlert alertWithError:error];
        int button = [alert runModal];
        if (button != NSAlertFirstButtonReturn) {
            // handle
        }
    }
    [pool release];
}
@end
