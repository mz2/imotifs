//
//  NMCutoffController.h
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class NMCutoffOperation;

@interface NMCutoffController : NSWindowController {
    NMCutoffOperation *_operation;
}

@property (retain, readwrite) IBOutlet NMCutoffOperation *operation;

-(IBAction) browseForMotifsFile:(id) sender;
-(IBAction) browseForSeqsFile:(id) sender;
-(IBAction) browseForBackgroundModelFile:(id) sender;
-(IBAction) browseForOutputFile:(id) sender;

-(IBAction) cancel:(id) sender;
-(IBAction) ok:(id) sender;

@end
