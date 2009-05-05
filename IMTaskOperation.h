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
    @protected
    NSTask* task;
    
    NSMutableDictionary *arguments;
    
    NSString *launchPath;
}

@property (retain, readwrite) NSTask *task;
@property (retain, readwrite) NSMutableDictionary *arguments;
@property (retain, readwrite) NSString *launchPath;

-(void) initializeTask; //the task is allocated and initialised here, and input/output pipes connected
- (void)handleTaskExitedNotification:(NSNotification*)aNotification;

+(NSArray*) argumentArrayFromDictionary:(NSMutableDictionary*) dict;
@end
