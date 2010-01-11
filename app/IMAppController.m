//
//  AppController.m
//  iMotifs
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//
#import "stdlib.h"

#import <ApplicationServices/ApplicationServices.h>
#import <IMAppController.h>
#import "MotifViewCell.h"
#import "NMOperation.h"
#import "MotifSetDocumentController.h"
#import "NMOperationConfigDialogController.h"
#import "NMTrainBGOperationConfigController.h"
#import "NMOperationStatusDialogController.h"
#import "NMCutoffController.h"
#import "NMROCAUCController.h"
#import "IMRetrieveSequencesDialogController.h"
#import "IMRetrievePeakSequencesController.h"
#import "MotifSetDocument.h"

@implementation IMAppController
@synthesize preferenceController;
@synthesize sharedOperationQueue;

NSString *IMConsensusSearchCutoff = @"IMConsensusSearchDefaultCutoffKey";

- (id) init {
    self = [super init];
    if (self != nil) {
        PCLog(@"AppController: initialising");
        sharedOperationQueue = [[NSOperationQueue alloc] init];
        [sharedOperationQueue setMaxConcurrentOperationCount:2];
        consensusSearchCutoff = FP_INFINITE;
        //[sharedOperationQueue setMaxConcurrentOperationCount:[NSApplication]];
        
        //[[NSApplication sharedApplication]  
    }
    return self;
}

+ (void) initialize {
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    
    
    [defaultValues setObject: [NSNumber numberWithBool: NO] 
                      forKey: @"IMOpenUntitledDoc"];
    
    [defaultValues setObject: @"~/workspace/nmica/bin" forKey: NMBinPath];
    [defaultValues setObject: @"~/workspace/nmica-extra/bin" forKey: NMExtraBinPath];
    [defaultValues setObject: [NSNumber numberWithDouble: IMConsensusSearchDefaultCutoff] 
                                                 forKey: IMConsensusSearchCutoff];
    
    [defaultValues setObject: [NSNumber numberWithInt: 60] 
                      forKey: IMMotifHeight];
    [defaultValues setObject: [NSNumber numberWithDouble: 1.0] 
                      forKey: IMConsensusSearchDefaultCutoffKey];
    [defaultValues setObject: [NSNumber numberWithFloat: IMMetamotifDefaultConfidenceIntervalCutoff]
                                                 forKey: IMMetamotifDefaultConfidenceIntervalCutoffKey];
    [defaultValues setObject: [NSNumber numberWithInt: IMInfoScaledLogo] 
                      forKey: IMMotifDrawingStyle];
    [defaultValues setObject: [NSNumber numberWithInt: IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol] 
                      forKey: IMMotifColumnPrecisionDrawingStyleKey];
    [defaultValues setObject: [NSNumber numberWithFloat: IMDefaultColWidth] 
                      forKey: IMColumnWidth];
    
    [defaultValues setObject: [NSNumber numberWithBool:YES] forKey:@"IMUseBuiltInNMICA"];
    
    [defaultValues setObject: @"anonymous" forKey:@"IMEnsemblUser"];
    [defaultValues setObject: @"" forKey: @"IMEnsemblPassword"];
    [defaultValues setObject: [NSNumber numberWithInt:5306] forKey: @"IMEnsemblPort"];
    [defaultValues setObject: @"ensembldb.ensembl.org" forKey:@"IMEnsemblBaseURL"];
    
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}
    
-(void) setConsensusSearchCutoff:(double) d {
    PCLog(@"Setting consensus search cutoff: %f",d);
    [[NSUserDefaults standardUserDefaults] 
     setObject:[NSNumber numberWithDouble:d] 
                                   forKey:IMConsensusSearchCutoff];
    consensusSearchCutoff = d;
}

-(double) consensusSearchCutoff {
    if (consensusSearchCutoff == FP_INFINITE) {
        consensusSearchCutoff = [[[NSUserDefaults standardUserDefaults] 
                                  objectForKey:IMConsensusSearchCutoff] doubleValue];
    }
    
    //PCLog(@"Retrieving consensus search cutoff: %f",consensusSearchCutoff);
    return consensusSearchCutoff;
}

- (BOOL) applicationShouldOpenUntitledFile: (NSApplication *)sender {
    //PCLog(@"AppController: application should NOT open untitled file.");
    return [[NSUserDefaults standardUserDefaults] boolForKey:IMOpenUntitledDoc]; 
}


-(void) dealloc {
    [sharedOperationQueue release];
    [preferenceController release];
    //PCLog(@"AppController: deallocating");
    [super dealloc];
}

- (void) awakeFromNib {
    PCLog(@"AppController: awakening from Nib");
}

- (IBAction) showPreferencePanel:(id)sender {
    if (!preferenceController) {
        preferenceController = [[IMPrefsWindowController alloc] init];
    }
    PCLog(@"AppController: showing %@", preferenceController);
    [preferenceController showWindow:self];
}
- (IBAction)openPreferencesWindow:(id)sender {
    
    [[IMPrefsWindowController sharedPrefsWindowController] showWindow:nil];
}

- (IBAction) toggleFullScreenMode:(id) sender {
    if (fullScreenMainWindow != nil) {
        [self goAwayFromFullScreenMode: self];
        return;
    }
    
    mainWindowBeforeGoingFullScreen = [[NSApplication sharedApplication] mainWindow];
    mainWindowBeforeGoingFullScreenRect = mainWindowBeforeGoingFullScreen.frame;
    mainWindowBeforeGoingFullScreenView = mainWindowBeforeGoingFullScreen.contentView;
    
    // Capture the screen that contains the window
    displayID = [[[mainWindowBeforeGoingFullScreen.screen deviceDescription] objectForKey:@"NSScreenNumber"] intValue];
    
    if (CGDisplayCapture(displayID) != kCGErrorSuccess) {
        PCLog(@"WARNING!  could not capture the display!");
        // Note: you'll probably want to display a proper error dialog here
    }
    // Get the shielding window level
    int windowLevel = CGShieldingWindowLevel();
    
    // Get the screen rect of our main display
    NSRect screenRect = mainWindowBeforeGoingFullScreen.screen.frame;
    
    // Put up a new window
    
    fullScreenMainWindow = [[NSWindow alloc] initWithContentRect: screenRect
                                                       styleMask: NSBorderlessWindowMask
                                                         backing: NSBackingStoreBuffered
                                                           defer: NO 
                                                          screen: mainWindowBeforeGoingFullScreen.screen];
    [fullScreenMainWindow setLevel:windowLevel];
    //[fullScreenMainWindow setBackgroundColor:[NSColor blackColor]];
    [fullScreenMainWindow makeKeyAndOrderFront:nil];
    
    //PCLog(@"Showing content view for : %@ : %@ : %@", 
    //      mainWindowBeforeGoingFullScreen, 
    //      mainWindowBeforeGoingFullScreen.contentView,
    //     fullScreenMainWindow);
    [mainWindowBeforeGoingFullScreen setFrame:screenRect display:YES];
    [fullScreenMainWindow setContentView:mainWindowBeforeGoingFullScreen.contentView];
}

- (IBAction) goAwayFromFullScreenMode:(id) sender {
    [fullScreenMainWindow orderOut:self];
    
    // Release the display(s)
    if (CGDisplayRelease(displayID) != kCGErrorSuccess) {
        PCLog( @"Couldn't release the display(s)!" );
    }
    [mainWindowBeforeGoingFullScreen 
     setFrame: mainWindowBeforeGoingFullScreenRect display: YES];
    [mainWindowBeforeGoingFullScreen 
     setContentView: mainWindowBeforeGoingFullScreenView];
    
    [fullScreenMainWindow release];
    fullScreenMainWindow = nil;
}
- (void) applicationWillTerminate:(NSNotification*) notification {
    [self goAwayFromFullScreenMode:self];
}

-(IBAction) runNMICA:(id) sender {
    //MotifSetDocument *doc = [[MotifSetDocument alloc] initWithContentsOfURL: [NSURL fileURLWithPath: @"/Users/mp4/Desktop/example.xms"] 
    //                                                                 ofType: @"Motif set"];
    
    //if (error) {
    //    PCLog(@"Error encountered: %@", [error localizedDescription]);
    //}
    
    //ddfprintf(stderr,@"Running NMICA\n");
    NMOperationConfigDialogController 
    *configDialogController = 
    [[NMOperationConfigDialogController alloc] initWithWindowNibName:@"NMOperationConfigDialog"];
    
    [configDialogController showWindow: self];
    
}

-(IBAction) retrieveSequences:(id) sender {
    IMRetrieveSequencesDialogController *retrieveSequencesController = 
        [[IMRetrieveSequencesDialogController alloc] initWithWindowNibName:@"IMRetrieveSequencesDialog"];
    
    [retrieveSequencesController showWindow: self];
}

-(IBAction) retrievePeakSequences:(id) sender {
	NSLog(@"Retrieving peak sequences");
    IMRetrievePeakSequencesController *retrieveSequencesController = 
	[[IMRetrievePeakSequencesController alloc] initWithWindowNibName:@"IMRetrievePeakSequencesDialog"];
    
    [retrieveSequencesController showWindow: self];
}

- (IBAction) scoreCutoff:(id) sender {
	NSLog(@"Peak sequences");
    NMCutoffController *controller = 
	[[NMCutoffController alloc] initWithWindowNibName:@"IMScoreCutoffDialog"];
    [controller showWindow: self];
}

- (IBAction) overrepresentationScore:(id) sender {
	NSLog(@"Overrepresentation scores");
    NMROCAUCController *controller = 
	[[NMROCAUCController alloc] initWithWindowNibName:@"IMOverRepDialog"];
    [controller showWindow: self];    
}

- (IBAction) trainBackground:(id) sender {
    NSLog(@"Train background");
    NMROCAUCController *controller = 
        [[NMTrainBGOperationConfigController alloc] initWithWindowNibName:
         @"NMTrainBGOperationConfigController"];
    [controller showWindow: self];
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
    //MotifSetDocumentController *msetDocController = [[MotifSetDocumentController alloc] init];
    //this object is set as the shared document controller because it's the first to be loaded, so it can be released.
    //[msetDocController release];
}

/*
- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
    //PCLog(@"Application should OPEN FILE: %@", filename);
    if ([filename hasSuffix:@".fasta"] || [filename hasSuffix:@".fa"] || [filename hasSuffix:@".seq"]) {
        NMOperationConfigDialogController 
        *configDialogController = 
        [[NMOperationConfigDialogController alloc] initWithWindowNibName:@"NMOperationConfigDialog"];
        
        [configDialogController showWindow: self];
        [[configDialogController nminferOperation] setSequenceFilePath: filename];
        
        return YES;
    } else {
        return NO;
    }
    return NO;
}
 */


-(void) showHelp:(id) sender {
    NSLog(@"Showing help");
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://wiki.github.com/mz2/imotifs"]];
}
@end
