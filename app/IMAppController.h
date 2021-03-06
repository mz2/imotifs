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
//  AppController.h
//  iMotifs
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IMPrefsWindowController.h>

#ifndef IMOpenUntitledDoc
#define IMOpenUntitledDoc @"IMOpenUntitledDoc"
#endif

#ifndef NMBinPath
#define NMBinPath @"NMBinPath"
#endif

#ifndef NMExtraBinPath
#define NMExtraBinPath @"NMExtraBinPath"
#endif

#ifndef IMConsensusSearchDefaultCutoff
#define IMConsensusSearchDefaultCutoff (double)2.0
#endif

#ifndef IMConsensusSearchDefaultCutoffKey
#define IMConsensusSearchDefaultCutoffKey @"IMConsensusSearchDefaultCutoffKey"
#endif

#ifndef IMMotifHeight
#define IMMotifHeight @"IMMotifHeight"
#endif

#ifndef IMColumnWidth
#define IMColumnWidth @"IMColumnWidth"
#endif

#ifndef IMMetamotifDefaultConfidenceIntervalCutoffKey
#define IMMetamotifDefaultConfidenceIntervalCutoffKey @"IMMetamotifDefaultConfidenceIntervalCutoff"
#endif

#ifndef IMMetamotifDefaultConfidenceIntervalCutoff
#define IMMetamotifDefaultConfidenceIntervalCutoff (CGFloat)0.95
#endif

#ifndef IMMotifDrawingStyle
#define IMMotifDrawingStyle (NSString*)@"IMMotifDrawingStyle"
#endif

#ifndef IMMotifColumnPrecisionDrawingStyleKey
#define IMMotifColumnPrecisionDrawingStyleKey (NSString*)@"IMMotifColumnPrecisionDrawingStyle"
#endif

#import "IMPrefsWindowController.h"

extern NSString *IMConsensusSearchCutoff;

@interface IMAppController : NSObject {
    IMPrefsWindowController *preferenceController;
    NSOperationQueue *sharedOperationQueue;
        
    double consensusSearchCutoff;
    @private
    NSWindow *fullScreenMainWindow;
    NSWindow *mainWindowBeforeGoingFullScreen;
    NSView *mainWindowBeforeGoingFullScreenView;
    NSRect mainWindowBeforeGoingFullScreenRect;
    CGDirectDisplayID displayID;
}

@property (readonly) IMPrefsWindowController *preferenceController;
@property (retain,readonly) NSOperationQueue *sharedOperationQueue;
@property (readwrite) double consensusSearchCutoff;

//@property (retain, readwrite) NSWindow *fullScreenMainWindow;
//@property (retain, readwrite) NSWindow *mainWindowBeforeGoingFullScreen;
//@property (retain, readwrite) NSView *mainWindowBeforeGoingFullScreenView;
//@property (readwrite) NSRect mainWindowBeforeGoingFullScreenRect;

- (IBAction) openPreferencesWindow:(id)sender;
- (IBAction) toggleFullScreenMode:(id) sender;
- (IBAction) goAwayFromFullScreenMode:(id) sender;

- (IBAction) runNMICA:(id) sender;
- (IBAction) trainBackground:(id) sender;
- (IBAction) retrieveSequences:(id) sender;

- (IBAction) scoreCutoff:(id) sender;
- (IBAction) overrepresentationScore:(id) sender;

-(IBAction) retrievePeakSequences:(id) sender;
-(IBAction) retrieveSequences:(id) sender;
-(IBAction) showHelp:(id) sender;

-(IBAction) importTRANSFAC: (id) sender;

-(BOOL) atLeastOneAnnotationSetDocumentIsOpen;
-(BOOL) atLeastOneSequenceSetDocumentIsOpen;
-(BOOL) atLeastOneMotifSetDocumentIsOpen;

-(void) openTRANSFACFileAtPath:(NSString*)path;

-(IBAction) scanSequencesWithMotifs:(NSString*) seqs;

-(IBAction) reportIssue:(id) sender;

@end
