//
//  IMTaskOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "IMTaskOperation.h"
#import "IMOperation.h"

@implementation IMTaskOperation
@synthesize task, arguments;

-(id) initWithTask:(NSTask*) t arguments:(NSArray*)args {
    self = [super init];
    if (self){
        task = [t retain];
        arguments = [args retain];
    }
    
    return self;
}

-(void) dealloc {
    [task release];
    [arguments release];
    [super dealloc];
}

- (BOOL)isConcurrent {
    return NO;
}

- (void)start {
    // Create the NSTask object.
    //task = [[NSTask alloc] init];
    
    //[[[NSApplication sharedApplication] delegate] registerNotifications];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleTaskExitedNotification:) name: NSTaskDidTerminateNotification object: task];
    [task setArguments: arguments];
    // If the operation hasn't already been cancelled, launch it.
    if (![self isCancelled]) {
        [self willChangeValueForKey:@"isExecuting"];
        isExecuting = YES;
        [task launch];
        [self run];
        [self didChangeValueForKey:@"isExecuting"];
        
        [self willChangeValueForKey:@"isFinished"];
        isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        [self willChangeValueForKey:@"isExecuting"];
        isExecuting = NO;
        [self didChangeValueForKey:@"isExecuting"];
    }
    
    [pool drain];
    [pool release];
}

- (void)handleTaskExitedNotification:(NSNotification*)aNotification {
    NSLog(@"IMTaskOperation: terminating...");
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    isFinished = YES;
    isExecuting = NO;
    
    // Clean up.
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: NSTaskDidTerminateNotification
                                                  object: task];
    //[task release]; //handled by dealloc
    
    NSLog(@"Task exit notification received successfully.\n");
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}
@end