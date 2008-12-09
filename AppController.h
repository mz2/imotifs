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

@interface AppController : NSObject {
    PreferencesDialogController *preferenceController;
    NSOperationQueue *sharedOperationQueue;
}

@property (readonly) PreferencesDialogController *preferenceController;
@property (retain,readonly) NSOperationQueue *sharedOperationQueue;

- (IBAction) showPreferencePanel:(id)sender;
@end
