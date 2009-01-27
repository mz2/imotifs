//
//  IMTaskOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMOperation.h"

@interface IMTaskOperation : IMOperation {
    NSTask* task;
    NSArray *arguments;
}

@property (retain, readonly) NSTask *task;
@property (retain, readonly) NSArray *arguments;

-(id) initWithTask:(NSTask*) task arguments:(NSArray*) arguments;
- (void)handleTaskExitedNotification:(NSNotification*)aNotification;

@end
