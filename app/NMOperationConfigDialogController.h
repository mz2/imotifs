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
    IBOutlet NMOperation *nminferOperation;
}

@property (retain, readwrite) NMOperation *nminferOperation;

-(IBAction) browseForSequenceFile:(id) sender;
-(IBAction) browseForOutputFile:(id) sender;
-(IBAction) browseForBGModelFile:(id) sender;
-(IBAction) cancel:(id) sender;
-(IBAction) ok:(id) sender;

@end
