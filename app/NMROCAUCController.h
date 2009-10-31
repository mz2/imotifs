//
//  NMROCAUCController.h
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NMROCAUCOperation.h";

@interface NMROCAUCController : NSWindowController {
    NMROCAUCOperation *_operation;
}

@property (retain, readwrite) IBOutlet NMROCAUCOperation *operation;


-(IBAction) browseForPositiveSeqsFile:(id) sender;
-(IBAction) browseForNegativeSeqsFile:(id) sender;
-(IBAction) browseForMotifsFile:(id) sender;
-(IBAction) browseForOutputFile:(id) sender;

-(IBAction) cancel:(id) sender;
-(IBAction) ok:(id) sender;
@end
