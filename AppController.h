//
//  AppController.h
//  iMotifs
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PreferencesDialogController.h>

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

extern NSString *IMConsensusSearchCutoff;

@interface AppController : NSObject {
    PreferencesDialogController *preferenceController;
    NSOperationQueue *sharedOperationQueue;
    
    double consensusSearchCutoff;
}

@property (readonly) PreferencesDialogController *preferenceController;
@property (retain,readonly) NSOperationQueue *sharedOperationQueue;
@property (readwrite) double consensusSearchCutoff;

- (IBAction) showPreferencePanel:(id)sender;
@end
