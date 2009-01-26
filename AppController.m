//
//  AppController.m
//  iMotifs
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <ApplicationServices/ApplicationServices.h>
#import <AppController.h>

@implementation AppController
@synthesize preferenceController;
@synthesize sharedOperationQueue;

NSString *IMConsensusSearchCutoff = @"IMConsensusSearchDefaultCutoffKey";

- (id) init {
    self = [super init];
    if (self != nil) {
        NSLog(@"AppController: initialising");
        sharedOperationQueue = [[NSOperationQueue alloc] init];
        [sharedOperationQueue setMaxConcurrentOperationCount:1];
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
    
    //#define MAX_DISPLAYS (16)
    //CGDirectDisplayID displays[MAX_DISPLAYS];
    //CGDisplayCount displayCount;
    
    //NSRect screenFrame = [mainWindowBeforeGoingFullScreen screen];
    //NSRect winFrame = [mainWindowBeforeGoingFullScreen.screen frame];
    
    //CGDisplayErr err = CGGetDisplaysWithRect((CGRect){
    //    NSMinX(winFrame), NSMinY(winFrame),NSWidth(winFrame),NSHeight(winFrame)},
    //    MAX_DISPLAYS, displays, &displayCount);
    
    //if (err != kCGErrorSuccess) {
    //    NSLog(@"WARNING! could not determine the display ID!");
    //}
    
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
    
    NSLog(@"Showing content view for : %@ : %@ : %@", 
          mainWindowBeforeGoingFullScreen, 
          mainWindowBeforeGoingFullScreen.contentView,
          fullScreenMainWindow);
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

@end
