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

-(IBAction) cancel:(id) sender;
-(IBAction) ok:(id) sender;
@end
