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
//  NMOperationStatusDialogController.m
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "NMOperationStatusDialogController.h"
#import "MotifSetDocument.h"
#import "NMOperation.h"

@implementation NMOperationStatusDialogController
@synthesize iterationNumberLabel,evidenceLabel,likelihoodLabel, spinner,level;
@synthesize operation;
@synthesize closeButton, showResultsButton;
//@synthesize outputMotifSetPath;

-(void) awakeFromNib {
    PCLog(@"Awakening from NIB");
    [spinner startAnimation: self];
}
-(void) dealloc {
    [operation release];
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
    //PCLog(@"Replacing window %@ title %@ with %@", self.window, self.window.title, str);
    [self.window setTitle:str];
}

-(void) _stop:(id) sender {
    ddfprintf(stderr, @"Stopping NMICA...\n");
    if ([operation isExecuting]) {
        [operation cancel];
    }
    [spinner stopAnimation: self];    
}

-(IBAction) stop:(id) sender {
    [self _stop:self];
    [self close];

}

-(IBAction) motifDiscoveryDone:(id) sender {
    [spinner stopAnimation: self];
    [closeButton setEnabled: NO];
    //[showResultsButton setHidden: NO];
}
-(IBAction) showResults:(id) sender {
    [self close];
    PCLog(@"Getting motifs from %@", [operation outputMotifSetPath]);
    MotifSetDocument *doc = [[MotifSetDocument alloc] 
                             initWithContentsOfFile:
                             [NSURL fileURLWithPath: operation.outputMotifSetPath] 
                             ofType:@"Motif set"];
    [doc showWindows];
    //try setting the motif set by hand?
}


- (void)windowWillClose:(NSNotification *)notification {
    [self _stop: self];
}
     
@end
