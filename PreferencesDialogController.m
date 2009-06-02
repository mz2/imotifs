//
//  PreferencesDialogController.m
//  iMotifs
//
//  Created by Matias Piipari on 16/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "PreferencesDialogController.h"
#import "AppController.h"

@implementation PreferencesDialogController
- (id)init {
    if (![super initWithWindowNibName:@"PreferencesDialog"]) {
        return nil;
    }
    return self;
}

- (void) windowDidLoad {
    DebugLog(@"PreferencesDialogController: Nib file loaded");
}

- (void) awakeFromNib {
    
    
}

- (IBAction) changeNewEmptyDoc:(id)sender {
    int state = [emptyDocCheckbox state];
    DebugLog(@"PreferencesDialogController: new empty doc state changed:%d",state);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[emptyDocCheckbox state] 
               forKey:IMOpenUntitledDoc];
    
}
@end
