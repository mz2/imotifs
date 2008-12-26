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

- (id) init {
    self = [super init];
    if (self != nil) {
        NSLog(@"AppController: initialising");
        sharedOperationQueue = [[NSOperationQueue alloc] init];
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
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (BOOL) applicationShouldOpenUntitledFile: (NSApplication *)sender {
    NSLog(@"AppController: application should NOT open untitled file.");
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
