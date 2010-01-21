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
