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

@interface AppController : NSObject {
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
- (IBAction) retrieveSequences:(id) sender;
@end
