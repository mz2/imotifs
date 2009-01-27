//
//  NMOperationConfigDialogController.m
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "NMOperationConfigDialogController.h"


@implementation NMOperationConfigDialogController
@synthesize expUsageFractionSlider, expUsageFractionTextField;
@synthesize inputSeqFilename, outputMotifSetFilename;
@synthesize inputSeqFilenameTextField, outputMotifSetFilenameTextField;

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
    self.inputSeqFilename = [filename copy];
    
}

-(void) setInputSeqFilename:(NSString*) str {
    self.inputSeqFilenameTextField.objectValue = str;
}

-(IBAction) browseForOutputFile:(id) sender {
    
}

-(IBAction) cancel:(id) sender {
    [self close];
}

-(IBAction) ok:(id) sender {
    [self close];
}

@end
