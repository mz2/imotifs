//
//  NMROCAUCController.m
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NMROCAUCController.h"
#import "NMROCAUCOperation.h"
#import "IMRetrieveSequencesStatusDialogController.h"
#import "IMAppController.h"

@implementation NMROCAUCController
@synthesize operation = _operation;

-(IBAction) cancel:(id) sender {
    [self close];
}

-(IBAction) ok:(id) sender {
    NSLog(@"Submitting ROC-AUC task");
    IMRetrieveSequencesStatusDialogController *operationDialogController = 
    [[IMRetrieveSequencesStatusDialogController alloc] initWithWindowNibName:@"IMRetrieveSequencesStatusDialog"];
    operationDialogController.window.title = @"Determine motif overrepresentation";
    [operationDialogController showWindow: self];
    
    [operationDialogController setOperation: self.operation];
    [self.operation setStatusDialogController: operationDialogController];
    [self.operation.statusDialogController start: self];
    
    [[[[NSApplication sharedApplication] delegate] sharedOperationQueue] addOperation: self.operation];
    [self close];
    [self release];
}

-(IBAction) browseForPositiveSeqsFile:(id) sender {
    NSOpenPanel *seqFilePanel = [NSOpenPanel openPanel];
    [seqFilePanel setAllowsMultipleSelection: NO];
    [seqFilePanel beginSheetForDirectory: nil
                                    file: nil
                          modalForWindow: self.window
                           modalDelegate: self
                          didEndSelector: @selector(browseForPositiveSeqsFileEnded:returnCode:contextInfo:) 
                             contextInfo: NULL];
}

-(IBAction) browseForNegativeSeqsFile:(id) sender {
    NSOpenPanel *seqFilePanel = [NSOpenPanel openPanel];
    [seqFilePanel setAllowsMultipleSelection: NO];
    [seqFilePanel beginSheetForDirectory: nil
                                    file: nil
                          modalForWindow: self.window
                           modalDelegate: self
                          didEndSelector: @selector(browseForNegativeSeqsFileEnded:returnCode:contextInfo:) 
                             contextInfo: NULL];
}

-(void) browseForPositiveSeqsFileEnded: (NSOpenPanel*) sheet 
                    returnCode: (int) returnCode
                   contextInfo: (void*) contextInfo {
	if (returnCode) {
		self.operation.positiveSeqsFile = sheet.filename;
	}
}

-(void) browseForNegativeSeqsFileEnded: (NSOpenPanel*) sheet 
                            returnCode: (int) returnCode
                           contextInfo: (void*) contextInfo {
	if (returnCode) {
		self.operation.negativeSeqsFile = sheet.filename;
	}
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
	if (returnCode) {
		self.operation.motifsFile = sheet.filename;
	}
}

-(IBAction) browseForOutputFile:(id) sender {
    NSString *fileSugg = nil;
    NSString *dirSugg = nil;
    if (self.operation.outputFile == nil) {
        fileSugg = [[[self.operation motifsFile] lastPathComponent] 
                    stringByReplacingOccurrencesOfString:@".xms" 
                    withString:@".overrep"];
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


@end