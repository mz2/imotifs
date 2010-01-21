/*
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the
Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
Boston, MA  02110-1301, USA.
*/
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

-(IBAction) copyToClipboard:(id) sender;

-(NSString*) argumentsString;

@end
