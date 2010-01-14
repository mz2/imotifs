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
#import "IMAnnotationSetDocument.h"
#import "IMSequenceSetDocument.h"
#import "RegexKitLite.h"
#import "MotifSet.h"
#import "Motif.h"


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
    
	[defaultValues setObject: [NSNumber numberWithFloat:IMDefaultSymbolWidth] 
					  forKey:IMSymbolWidthKey];
	
	[defaultValues setObject: [NSNumber numberWithInt:IMSequenceFocusAreaHalfLength] 
					  forKey: IMSequenceFocusAreaHalfLengthKey];
	
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

-(IBAction) importTRANSFAC: (id) sender {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
	
    [oPanel setAllowsMultipleSelection:YES];
    NSInteger result = [oPanel runModalForDirectory:NSHomeDirectory()
											   file:nil 
											  types:nil];
    if (result == NSOKButton) {
        NSArray *filesToOpen = [oPanel filenames];
        int i, count = [filesToOpen count];
        for (i=0; i<count; i++) {
            NSString *aFile = [filesToOpen objectAtIndex:i];
			[self openTRANSFACFileAtPath: aFile];
        }
    }
}

-(void) openTRANSFACFileAtPath:(NSString*)infilename {
	MotifSet *mset = [[[MotifSet alloc] init] autorelease];
	
	NSError *readErr = nil;
	NSString *fileContents = [NSString stringWithContentsOfFile:infilename encoding:NSUTF8StringEncoding error:&readErr];
	
	if (readErr != nil) {[NSAlert alertWithError: readErr];}
	
	NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
	
	
	NSString *name = nil;
	NSMutableArray *cols = nil;
	NSMutableArray *motifs = [NSMutableArray array];
	Motif *motif = nil;
	
	PCLog(@"Parsing lines %@", lines);
	
	for (NSString *line in lines) {
		PCLog(@"%@",line);
		NSArray *nameComponents = [line captureComponentsMatchedByRegex:@"NA\\s+(.*)"];
		NSArray *idComponents = [line captureComponentsMatchedByRegex:@"ID\\s+(.*)"];
		//NSLog(@"qComponents:%@ %@ ", qComponents, [qComponents objectAtIndex:1]);
		if (idComponents.count > 1) {
			name = [idComponents objectAtIndex: 1];
		}
		if (nameComponents.count > 1) {
			name = [nameComponents objectAtIndex: 1];
		}
		
		NSArray *colHeaderComponents = [line captureComponentsMatchedByRegex:@"^(P0)"];
		
		if (colHeaderComponents.count > 1) {
			PCLog(@"Column header");
			cols = [NSMutableArray array];
		}
		
		NSArray *colComponents = [line captureComponentsMatchedByRegex:@"^P(\\d+)\\s+(.*)"];
		if (colComponents.count > 2) {
			PCLog(@"Column");
			NSString *colNum = [colComponents objectAtIndex:1];
			NSArray *weights = [[colComponents objectAtIndex: 2] componentsSeparatedByString:@" "];
			PCLog(@"Weights for column %@: %@", colNum, weights);
			
			Multinomial *multi = [[[Multinomial alloc] initWithAlphabet:[Alphabet withName:@"dna"]] autorelease];
			
			[multi symbol: [[Alphabet withName:@"dna"] 
							symbolWithName:@"a"] 
			   withWeight: [[weights objectAtIndex:0] floatValue]];
			[multi symbol: [[Alphabet withName:@"dna"] 
							symbolWithName:@"c"] 
			   withWeight: [[weights objectAtIndex:1] floatValue]];
			[multi symbol: [[Alphabet withName:@"dna"] 
							symbolWithName:@"g"] 
			   withWeight: [[weights objectAtIndex:2] floatValue]];
			[multi symbol: [[Alphabet withName:@"dna"] 
							symbolWithName:@"t"] 
			   withWeight: [[weights objectAtIndex:3] floatValue]];
			
			[cols addObject: multi];
		}
		
		NSArray *endComponents = [line captureComponentsMatchedByRegex:@"(//)"];
		
		if (endComponents.count > 1) {
			motif = [[[Motif alloc] initWithAlphabet: [Alphabet withName:@"dna"] 
										  andColumns: cols] autorelease];
			cols = nil;
			name = nil;
		}
		
		if (colHeaderComponents.count > 1) {
			PCLog(@"Column header");
			cols = [NSMutableArray array];
			if (motif != nil) {
				[motifs addObject: motif];
			} else {
				PCLog(@"Error with parsing TRANSFAC file");
			}
		}
	}
	
	for (Motif *m in motifs) {
		[mset addMotif: m];
	}
	
	NSString *transfacExportTempPath = 
	[[NSTemporaryDirectory() stringByAppendingPathComponent:
	  [NSString stringWithFormat: @"%d%@", rand(), @".xms"]] retain];
	
	NSError *err = nil;
	
	PCLog(@"%@",[[mset toXMS] description]);
	[[[mset toXMS] description] writeToFile:transfacExportTempPath 
								 atomically:YES
								   encoding:NSUTF8StringEncoding 
									  error:&err];
	if (err != nil) {[[NSAlert alertWithError:err] runModal];}
	
	NSError *exportErr = nil;
	MotifSetDocument *doc = [[MotifSetDocument alloc] 
							 initWithContentsOfURL:[NSURL fileURLWithPath:transfacExportTempPath] 
																   ofType:@"Motif set" 
																	error:&exportErr];
	[[NSFileManager defaultManager] removeFileAtPath: transfacExportTempPath 
											 handler: nil];
	[doc makeWindowControllers];
	[doc showWindows];

	
	if (exportErr != nil) {
		[[NSAlert alertWithError:exportErr] runModal];
	}
	[doc showWindows];
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

-(BOOL) atLeastOneAnnotationSetDocumentIsOpen {
	return [[IMAnnotationSetDocument annotationSetDocuments] count] > 0;
}

-(BOOL) atLeastOneSequenceSetDocumentIsOpen {
	return [[IMSequenceSetDocument sequenceSetDocuments] count] > 0;
}

-(BOOL) atLeastOneMotifSetDocumentIsOpen {
	return [[MotifSetDocument motifSetDocuments] count] > 0;
}

@end
