//
//  NMOperationConfigDialogController.m
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "NMOperationConfigDialogController.h"
#import "NMOperationStatusDialogController.h"
#import "NMOperation.h"
#import "AppController.h"


@implementation NMOperationConfigDialogController
@synthesize expUsageFractionSlider, expUsageFractionTextField;
@synthesize inputSeqFilenameTextField, outputMotifSetFilenameTextField,nminferOperation;

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
    NSString *filename = [sheet filename];
    self.inputSeqFilenameTextField = [filename copy];
}

-(void) browseForMotifSetDirectory: (NSOpenPanel*) sheet 
                        returnCode: (int) returnCode
                       contextInfo: (void*) contextInfo {
    NSString *filename = [sheet filename];
    if (returnCode) {
        [self.nminferOperation setOutputMotifSetPath:filename];                
    }
}

-(IBAction) browseForOutputFile:(id) sender {
    NSString *fileSugg = nil;
    NSString *dirSugg = nil;
    if (nminferOperation.outputMotifSetPath == nil) {
        fileSugg = [[[self.nminferOperation sequenceFilePath] lastPathComponent] 
         stringByReplacingOccurrencesOfString:@".fasta" 
         withString:@".xms"];
        dirSugg = [[self.nminferOperation sequenceFilePath] stringByDeletingLastPathComponent];
    } else {
        fileSugg = [[self.nminferOperation outputMotifSetPath] lastPathComponent];
        dirSugg = [self.nminferOperation.outputMotifSetPath stringByDeletingLastPathComponent];
    }
    
    NSSavePanel *seqFilePanel = [NSSavePanel savePanel];
    [seqFilePanel beginSheetForDirectory: dirSugg
                                    file: fileSugg
                          modalForWindow: self.window 
                           modalDelegate: self 
                          didEndSelector: @selector(browseForMotifSetDirectory:returnCode:contextInfo:) 
                             contextInfo: nil];
    
}

-(IBAction) cancel:(id) sender {
    [self close];
}

-(IBAction) ok:(id) sender {
    NMOperationStatusDialogController *operationDialogController = 
    [[NMOperationStatusDialogController alloc] initWithWindowNibName:@"NMOperationStatusDialog"];
    [operationDialogController showWindow: self];
    [operationDialogController setOutputMotifSetPath: self.outputMotifSetFilenameTextField.stringValue]; 
    
    [operationDialogController setOperation: nminferOperation];
    [nminferOperation setDialogController: operationDialogController];
    
    [[[[NSApplication sharedApplication] delegate] sharedOperationQueue] addOperation: nminferOperation];
    [nminferOperation release];    
    
    [self close];
    
}

@end
