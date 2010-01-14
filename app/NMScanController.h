//
//  NMROCAUCController.h
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NMScanOperation.h";

@interface NMScanController : NSWindowController {
    NMScanOperation *_operation;
    
}

@property (retain, readwrite) IBOutlet NMScanOperation *operation;


-(IBAction) browseForSeqsFile:(id) sender;
-(IBAction) browseForMotifsFile:(id) sender;
-(IBAction) browseForOutputFile:(id) sender;

-(IBAction) cancel:(id) sender;
-(IBAction) ok:(id) sender;
@end
