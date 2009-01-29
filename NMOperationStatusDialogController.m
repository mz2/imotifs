//
//  NMOperationStatusDialogController.m
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "NMOperationStatusDialogController.h"
#import "MotifSetDocument.h"

@implementation NMOperationStatusDialogController
@synthesize iterationNumberLabel,evidenceLabel,iterationNumberLabel,likelihoodLabel, spinner,level;
@synthesize operation;
@synthesize closeButton, showResultsButton, outputMotifSetPath;

-(void) awakeFromNib {
    NSLog(@"Awakening from NIB");
    [spinner startAnimation: self];
}
-(void) dealloc {
    [super dealloc];
}
-(void) setIterationNumber: (NSNumber*)num {
    [iterationNumberLabel setObjectValue:num];
}
-(void) setPriorMassShifted: (NSNumber*)num {
    //no-op for now
}
-(void) setBestLikelihood: (NSNumber*)num {
    [likelihoodLabel setObjectValue:num];
}
-(void) setAccummulatedEvidence: (NSNumber*)num {
    [evidenceLabel setObjectValue: num];
}
-(void) setIterationTime: (NSNumber*)num {
    [level setObjectValue: num];
}

-(void) setStatus:(NSString*)str {
    //NSLog(@"Replacing window %@ title %@ with %@", self.window, self.window.title, str);
    [self.window setTitle:str];
}

-(IBAction) stop:(id) sender {
    ddfprintf(stderr, @"Stopping NMICA...\n");
    [operation cancel];
    [spinner stopAnimation: self];
    [self close];
}
-(IBAction) motifDiscoveryDone:(id) sender {
    [spinner stopAnimation: self];
    [closeButton setEnabled: NO];
    //[showResultsButton setHidden: NO];
}
-(IBAction) showResults:(id) sender {
    [self close];
    NSLog(@"Getting motifs from %@", outputMotifSetPath);
    MotifSetDocument *doc = [[MotifSetDocument alloc] initWithContentsOfURL: [NSURL fileURLWithPath: outputMotifSetPath] 
                                                                     ofType: @"Motif set"];
    //try setting the motif set by hand?
}
@end
