//
//  IMRetrieveSequencesStatusDialogController.h
//  iMotifs
//
//  Created by Matias Piipari on 30/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMOutputFileProducingOperation.h"

@interface IMRetrieveSequencesStatusDialogController : NSWindowController {
    IBOutlet NSButton *showResultsButton;
    IBOutlet NSButton *cancelButton;
    IBOutlet NSProgressIndicator *spinner;
    IBOutlet NSTextView *lastEntryView;
    IBOutlet NSTextField *_doneLabel;
    
    id<IMOutputFileProducingOperation> operation;
}

@property (retain, readwrite) NSProgressIndicator *spinner;

@property (retain, readwrite) NSButton *cancelButton;
@property (retain, readwrite) NSTextField *doneLabel;

@property (retain, readwrite) NSButton *showResultsButton;

@property (nonatomic, retain, readwrite) id<IMOutputFileProducingOperation> operation;
@property (nonatomic, retain, readwrite) NSTextView *lastEntryView;

-(IBAction) resultsReady:(id) sender;
-(IBAction) showResults:(id) sender;

-(IBAction) start:(id) sender;
-(IBAction) stop:(id) sender;
@end
