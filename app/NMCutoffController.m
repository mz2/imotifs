//
//  NMCutoffController.m
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NMCutoffController.h"
#import "NMCutoffOperation.h"
#import "IMRetrieveSequencesStatusDialogController.h"
#import "AppController.h"

@implementation NMCutoffController
@synthesize operation = _operation;

-(IBAction) browseForSeqsFile:(id) sender {
    NSOpenPanel *seqFilePanel = [NSOpenPanel openPanel];
    [seqFilePanel setAllowsMultipleSelection: NO];
    [seqFilePanel beginSheetForDirectory: nil
                                    file: nil
                          modalForWindow: self.window
                           modalDelegate: self
                          didEndSelector: @selector(browseForSeqsFileEnded:returnCode:contextInfo:) 
                             contextInfo: NULL];
}

-(void) browseForSeqsFileEnded: (NSOpenPanel*) sheet 
                        returnCode: (int) returnCode
                       contextInfo: (void*) contextInfo {
    self.operation.seqsFile = sheet.filename;
}

-(IBAction) browseForMotifsFile:(id) sender {
    NSOpenPanel *seqFilePanel = [NSOpenPanel openPanel];
    [seqFilePanel setAllowsMultipleSelection: NO];
    [seqFilePanel beginSheetForDirectory: nil
                                    file: nil
                          modalForWindow: self.window
                           modalDelegate: self
                          didEndSelector: @selector(browseForMotifsFileEnded:returnCode:contextInfo:) 
                             contextInfo: NULL];
}

-(void) browseForMotifsFileEnded: (NSOpenPanel*) sheet 
                      returnCode: (int) returnCode
                     contextInfo: (void*) contextInfo {
    self.operation.motifsFile = sheet.filename;
}

-(IBAction) browseForBackgroundModelFile:(id) sender {
    NSOpenPanel *seqFilePanel = [NSOpenPanel openPanel];
    [seqFilePanel setAllowsMultipleSelection: NO];
    [seqFilePanel beginSheetForDirectory: nil
                                    file: nil
                          modalForWindow: self.window
                           modalDelegate: self
                          didEndSelector: @selector(browseForBackgroundModelFileEnded:returnCode:contextInfo:) 
                             contextInfo: NULL];
}

-(void) browseForBackgroundModelFileEnded: (NSOpenPanel*) sheet 
                      returnCode: (int) returnCode
                     contextInfo: (void*) contextInfo {
    self.operation.bgFile = sheet.filename;
}

-(IBAction) browseForOutputFile:(id) sender {
    NSString *fileSugg = nil;
    NSString *dirSugg = nil;
    if (self.operation.outputFile == nil) {
        fileSugg = [[[self.operation motifsFile] lastPathComponent] 
                        stringByReplacingOccurrencesOfString:@".xms" 
                        withString:@"-with-cutoff.xms"];
        dirSugg = [[self.operation motifsFile] stringByDeletingLastPathComponent];
    } else {
        fileSugg = [[self.operation outputFile] lastPathComponent];
        dirSugg = [self.operation.outputFile stringByDeletingLastPathComponent];
    }

    NSSavePanel *seqFilePanel = [NSSavePanel savePanel];
    [seqFilePanel beginSheetForDirectory: dirSugg
                                    file: fileSugg
                          modalForWindow: self.window 
                           modalDelegate: self 
                          didEndSelector: @selector(browseForOutputFile:returnCode:contextInfo:) 
                             contextInfo: nil];
    
}

-(void) browseForOutputFile: (NSOpenPanel*) sheet 
                 returnCode: (int) returnCode
                contextInfo: (void*) contextInfo {
    if (returnCode) {
        self.operation.outputFile = sheet.filename;                
    }
}

-(IBAction) cancel:(id) sender {
    [self close];
}


-(IBAction) ok:(id) sender {
    NSLog(@"Submitting sequence retrieval task");
    IMRetrieveSequencesStatusDialogController *operationDialogController = 
    [[IMRetrieveSequencesStatusDialogController alloc] initWithWindowNibName:@"IMRetrieveSequencesStatusDialog"];
    operationDialogController.window.title = @"Determine score cutoff";
    [operationDialogController showWindow: self];
    
    [operationDialogController setOperation: self.operation];
    [self.operation setStatusDialogController: operationDialogController];
    
    [[[[NSApplication sharedApplication] delegate] 
      sharedOperationQueue] addOperation: self.operation];
    [self close];
    [self release];
}

@end
