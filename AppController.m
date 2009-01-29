//
//  AppController.m
//  iMotifs
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//
#import "stdlib.h"

#import <ApplicationServices/ApplicationServices.h>
#import <AppController.h>
#import "JavaLauncher.h"
#import "JavaLauncherUtils.h"
#import "NMOperation.h"
#import "NMOperationStatusDialogController.h"
#import "MotifSetDocumentController.h"
#import "NMOperationConfigDialogController.h"
#import "MotifSetDocument.h"

@implementation AppController
@synthesize preferenceController;
@synthesize sharedOperationQueue;

NSString *IMConsensusSearchCutoff = @"IMConsensusSearchDefaultCutoffKey";

- (id) init {
    self = [super init];
    if (self != nil) {
        NSLog(@"AppController: initialising");
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
    
    
    [defaultValues setObject:[NSNumber numberWithBool: NO] 
                      forKey:@"IMOpenUntitledDoc"];
    
    [defaultValues setObject:@"~/workspace/nmica/bin" forKey:NMBinPath];
    [defaultValues setObject:@"~/workspace/nmica-extra/bin" forKey:NMExtraBinPath];
    [defaultValues setObject:[NSNumber numberWithDouble:IMConsensusSearchDefaultCutoff] 
                                                 forKey:IMConsensusSearchCutoff];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}
    
-(void) setConsensusSearchCutoff:(double) d {
    NSLog(@"Setting consensus search cutoff: %f",d);
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
    
    //NSLog(@"Retrieving consensus search cutoff: %f",consensusSearchCutoff);
    return consensusSearchCutoff;
}

- (BOOL) applicationShouldOpenUntitledFile: (NSApplication *)sender {
    //NSLog(@"AppController: application should NOT open untitled file.");
    return [[NSUserDefaults standardUserDefaults] boolForKey:IMOpenUntitledDoc]; 
}


-(void) dealloc {
    [sharedOperationQueue release];
    [preferenceController release];
    //NSLog(@"AppController: deallocating");
    [super dealloc];
}

- (void) awakeFromNib {
    NSLog(@"AppController: awakening from Nib");
}

- (IBAction) showPreferencePanel:(id)sender {
    if (!preferenceController) {
        preferenceController = [[PreferencesDialogController alloc] init];
    }
    NSLog(@"AppController: showing %@", preferenceController);
    [preferenceController showWindow:self];
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
        NSLog(@"WARNING!  could not capture the display!");
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
    
    //NSLog(@"Showing content view for : %@ : %@ : %@", 
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
        NSLog( @"Couldn't release the display(s)!" );
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
    //    NSLog(@"Error encountered: %@", [error localizedDescription]);
    //}
    
    //ddfprintf(stderr,@"Running NMICA\n");
    NMOperationConfigDialogController 
    *configDialogController = 
    [[NMOperationConfigDialogController alloc] initWithWindowNibName:@"NMOperationConfigDialog"];
    
    [configDialogController showWindow: self];
    
    
    /*
    NMOperationStatusDialogController *operationDialogController = 
    [[NMOperationStatusDialogController alloc] initWithWindowNibName:@"NMOperationStatusDialog"];
    [operationDialogController showWindow: self];
    
    NMOperation *nminferOperation = [[NMOperation alloc] initMotifDiscoveryTaskWithSequences:@"/Users/mp4/Desktop/example.fasta" 
                                                                                  outputPath:@"/Users/mp4/Desktop/output.xms"];
    [operationDialogController setOperation: nminferOperation];
    [nminferOperation setDialogController: operationDialogController];
    
    [[self sharedOperationQueue] addOperation:nminferOperation];
    [nminferOperation release];
    */
    /*
    char *argv[5];
    argv[0] = "foobar"; //this is never used
    argv[1] = "-Djava.class.path=\
/Users/mp4/workspace/nmica-dev/lib/changeless.jar:\
/Users/mp4/workspace/nmica-dev/lib/biojava.jar:\
/Users/mp4/workspace/nmica-dev/lib/bytecode.jar:\
/Users/mp4/workspace/nmica-dev/lib/bjv2-core-0.1.jar:\
/Users/mp4/workspace/nmica-dev/lib/stax-api-1.0.1.jar:\
/Users/mp4/workspace/nmica-dev/lib/wstx-lgpl-3.0.2.jar:\
/Users/mp4/workspace/nmica-dev/lib/nmica.jar";
    argv[2] = "-Djava.library.path=\
/Users/mp4/workspace/nmica-dev/native";
    argv[3] = "-Dchangeless.no_dire_warning=\
true";
    argv[4] = "net.derkholm.nmica.apps.MotifFinderApplication";
    
    
    
    VMLaunchOptions *launchOpts = NewVMLaunchOptions(5,(const char**)&argv);
    startupJava(launchOpts);
     */
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
    //MotifSetDocumentController *msetDocController = [[MotifSetDocumentController alloc] init];
    //this object is set as the shared document controller because it's the first to be loaded, so it can be released.
    //[msetDocController release];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
    //NSLog(@"Application should OPEN FILE: %@", filename);
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
}
@end
