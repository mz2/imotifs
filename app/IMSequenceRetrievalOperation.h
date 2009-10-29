//
//  IMSequenceRetrievalOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 18/10/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"

@protocol IMSequenceRetrievalOperation <NSObject>

-(BOOL) isExecuting;
-(void) cancel;

-(NSString*) outFilename;

@end
