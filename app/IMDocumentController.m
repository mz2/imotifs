//
//  IMDocumentController.m
//  iMotifs
//
//  Created by Matias Piipari on 04/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IMDocumentController.h"


@implementation IMDocumentController

- (NSString *)defaultType {
    return @"Motif set";
}

/*
 - (IBAction)newDocument:(id)sender {
 
 MotifSetDocument *msetDocument = [[NSDocumentController sharedDocumentController] 
 makeUntitledDocumentOfType:@"Motif set" 
 error:&error];
 
 [self addDocument: msetDocument];
 [msetDocument makeWindowControllers];
 [msetDocument showWindows];
 
 }
 */


@end
