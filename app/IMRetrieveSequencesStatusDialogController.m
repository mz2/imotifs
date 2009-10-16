//
//  IMRetrieveSequencesStatusDialogController.m
//  iMotifs
//
//  Created by Matias Piipari on 30/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IMRetrieveSequencesStatusDialogController.h"
#import "IMRetrieveSequencesOperation.h"

@interface IMRetrieveSequencesStatusDialogController (private)
-(void) _stop:(id) sender;
@end

@implementation IMRetrieveSequencesStatusDialogController
@synthesize spinner,cancelButton,showResultsButton;
@synthesize operation;
@synthesize lastEntryView;

-(void) _stop:(id) sender {
    ddfprintf(stderr, @"Stopping NMICA...\n");
    if ([self.operation isExecuting]) {
        [self.operation cancel];
    }
    [self.spinner stopAnimation: self];    
}

-(IBAction) stop:(id) sender {
    [self _stop:self];
    [self close];
    
}

-(IBAction) resultsReady:(id) sender {
    [self.showResultsButton setHidden: NO];
    [self.cancelButton setHidden: YES];
}

-(IBAction) showResults:(id) sender {
    
}

@end