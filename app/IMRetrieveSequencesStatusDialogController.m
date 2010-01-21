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
