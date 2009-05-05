//
//  NMOperationConfigDialogController.h
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NMOperation.h"

@interface NMOperationConfigDialogController : NSWindowController {
    //IBOutlet NSSlider *expUsageFractionSlider;
    //IBOutlet NSTextField *expUsageFractionTextField;
    
    //NSString *inputSeqFilename;
    //IBOutlet NSTextField *inputSeqFilenameTextField;
    
    //NSString *outputMotifSetFilename;
    //IBOutlet NSTextField *outputMotifSetFilenameTextField;
    
    IBOutlet NMOperation *nminferOperation;
    
}

//@property (retain, readwrite) NSSlider  *expUsageFractionSlider;
//@property (retain, readwrite) NSTextField  *expUsageFractionTextField;

//@property (retain, readwrite) NSString *inputSeqFilename;
//@property (retain, readwrite) NSTextField *inputSeqFilenameTextField;

//@property (retain, readwrite) NSString *outputMotifSetFilename;
//@property (retain, readwrite) NSTextField *outputMotifSetFilenameTextField;

@property (retain, readwrite) NMOperation *nminferOperation;

-(IBAction) browseForSequenceFile:(id) sender;
-(IBAction) browseForOutputFile:(id) sender;
-(IBAction) browseForBGModelFile:(id) sender;
-(IBAction) cancel:(id) sender;
-(IBAction) ok:(id) sender;

@end
