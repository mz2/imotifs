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
    NSString *launchPath;    
@private
    NSTask* task;
    NSMutableDictionary *arguments;
    
}

@property (retain, readonly) NSTask *task;
@property (retain, readwrite) NSMutableDictionary *arguments;
@property (copy, readwrite) NSString *launchPath;


-(id) initWithLaunchPath:(NSString*)launchPath;

-(void) initializeArguments:(NSDictionary*) args;
//the task is allocated and initialised here, and input/output pipes connected
-(void) initializeTask:(NSTask*) task;

- (void)handleTaskExitedNotification:(NSNotification*)aNotification;


+(NSArray*) argumentArrayFromDictionary:(NSMutableDictionary*) dict;



-(NSString*) argumentsString;

@end
