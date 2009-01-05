//
//  AppController.m
//  iMotifs
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

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

@end
