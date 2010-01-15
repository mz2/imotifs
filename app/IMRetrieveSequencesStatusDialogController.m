//
//  IMRetrieveSequencesStatusDialogController.m
//  iMotifs
//
//  Created by Matias Piipari on 30/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IMRetrieveSequencesStatusDialogController.h"

@interface IMRetrieveSequencesStatusDialogController (private)
-(void) _stop:(id) sender;
@end

@implementation IMRetrieveSequencesStatusDialogController
@synthesize spinner,cancelButton,showResultsButton;
@synthesize operation;
@synthesize lastEntryView;
@synthesize doneLabel = _doneLabel;

-(void) _stop:(id) sender {
    ddfprintf(stderr, @"Stopping sequence retrieval...\n");
    if ([[self operation] isExecuting]) {
        [[self operation] cancel];
    }
    [self.spinner stopAnimation: self];    
    ddfprintf(stderr, @"Sequence retrieval stopped.\n");
}

-(IBAction) start:(id) sender {
    [self.doneLabel setHidden: YES];
    [self.spinner startAnimation: self];
    [self.showResultsButton setHidden: YES];
    [self.cancelButton setHidden: NO];
    
}

-(IBAction) stop:(id) sender {
    [self _stop:self];
    [self close];
}

-(IBAction) resultsReady:(id) sender {
    [self.doneLabel setHidden: NO];
    [self.showResultsButton setHidden: NO];
    [self.cancelButton setHidden: YES];
    [self.spinner stopAnimation: self];

    if ([operation respondsToSelector:@selector(openFile:)]) {
        [operation openFile: self];
    }
}

-(IBAction) showResults:(id) sender {
    PCLog(@"Showing results");
    [[NSWorkspace sharedWorkspace] selectFile:[self.operation outFilename] 
                     inFileViewerRootedAtPath: nil];}

-(void) dealloc {
    [super dealloc];
}

@end
