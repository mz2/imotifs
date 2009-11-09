//
//  NMTrainBGOperationConfigController.m
//  iMotifs
//
//  Created by Matias Piipari on 1/29/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "NMTrainBGOperationConfigController.h"
#import "NMTrainBGModelOperation.h"
#import "IMRetrieveSequencesStatusDialogController.h"
#import "IMAppController.h"

@implementation NMTrainBGOperationConfigController
@synthesize operation=_operation;

- (id)init
{
    if (self = [super init]) {
        [self setOperation: nil];
    }
    return self;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [_operation release], _operation = nil;
    [super dealloc];
}

-(IBAction) browseForSequenceFile:(id) sender {
    NSOpenPanel *seqFilePanel = [NSOpenPanel openPanel];
    [seqFilePanel setAllowsMultipleSelection: NO];
    [seqFilePanel beginSheetForDirectory: nil
                                    file: nil
                          modalForWindow: self.window
                           modalDelegate: self
                          didEndSelector: @selector(browseForSequenceFileEnded:returnCode:contextInfo:) 
                             contextInfo: NULL];
}

-(void) browseForSequenceFileEnded: (NSOpenPanel*) sheet 
                        returnCode: (int) returnCode
                       contextInfo: (void*) contextInfo {
    self.operation.inputSequencePath = sheet.filename;
}

-(IBAction) browseForOutputFile:(id) sender {
    NSString *fileSugg = nil;
    NSString *dirSugg = nil;
    if (self.operation.outputBackgroundModelFilePath == nil) {
        fileSugg = [[[self.operation inputSequencePath] lastPathComponent] 
                    stringByReplacingOccurrencesOfString: @".fasta" 
                    withString:@".xms"];
        dirSugg = [[self.operation inputSequencePath] stringByDeletingLastPathComponent];
    } else {
        fileSugg = [[self.operation outputBackgroundModelFilePath] lastPathComponent];
        dirSugg = [self.operation.outputBackgroundModelFilePath stringByDeletingLastPathComponent];
    }
    
    NSSavePanel *seqFilePanel = [NSSavePanel savePanel];
    [seqFilePanel beginSheetForDirectory: dirSugg
                                    file: fileSugg
                          modalForWindow: self.window 
                           modalDelegate: self 
                          didEndSelector: @selector(browseForMotifSetDirectory:returnCode:contextInfo:) 
                             contextInfo: nil];
    
}

-(void) browseForMotifSetDirectory: (NSOpenPanel*) sheet 
                        returnCode: (int) returnCode
                       contextInfo: (void*) contextInfo {
    if (returnCode) {
        self.operation.outputBackgroundModelFilePath = sheet.filename;                
    }
}

-(IBAction) submit:(id) sender {
    NSLog(@"Submitting background training task");
    IMRetrieveSequencesStatusDialogController *operationDialogController = 
        [[IMRetrieveSequencesStatusDialogController alloc] 
         initWithWindowNibName:@"IMRetrieveSequencesStatusDialog"];
    
    operationDialogController.window.title = @"Train NMICA background model";
    [operationDialogController showWindow: self];
    
    [operationDialogController setOperation: self.operation];
    [self.operation setStatusDialogController: operationDialogController];
    
    [[[[NSApplication sharedApplication] delegate] sharedOperationQueue] addOperation: self.operation];
    [self close];
    [self release];
}

-(IBAction) cancel:(id) sender {
    [self close];
}

@end
