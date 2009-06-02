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
@synthesize task, arguments, launchPath;

-(id) init {
    self = [super init];
    if (self) {
        arguments = [[NSMutableDictionary alloc] init];
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

//this method here needs to initialize  the task
- (void) initializeTask {
    @throw [NSException exceptionWithName:@"IMInitializeTaskNotOverridenException" 
                                   reason:@"-initializeTask should be overridden in the subclasses of IMTaskOperation" 
                                 userInfo:nil];
    
}

- (void)start {
    // Create the NSTask object.
    //task = [[NSTask alloc] init];
    
    //[[[NSApplication sharedApplication] delegate] registerNotifications];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self initializeTask];
    [task setArguments:[IMTaskOperation argumentArrayFromDictionary:arguments]];
    [task setLaunchPath:launchPath];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(handleTaskExitedNotification:) 
                                                 name: NSTaskDidTerminateNotification 
                                               object: task];
    
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
        DebugLog(@"IMTaskOperation done.");
    }
    
    [pool drain];
    [pool release];
}

- (void)handleTaskExitedNotification:(NSNotification*)aNotification {
    DebugLog(@"IMTaskOperation: terminating...");
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    isFinished = YES;
    isExecuting = NO;
    
    // Clean up.
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: NSTaskDidTerminateNotification
                                                  object: task];
    //[task release]; //handled by dealloc
    
    DebugLog(@"Task exit notification received successfully.\n");
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

+(NSArray*) argumentArrayFromDictionary:(NSMutableDictionary*) dict {
    NSMutableArray *args = [NSMutableArray array];
    for (NSString *key in [dict allKeys]) {
        NSString *value = [dict objectForKey:key];
        [args addObject: key];
        if ((id)value != [NSNull null]) {
            [args addObject:value];
        }
    }
    ddfprintf(stderr, @"%@",args);
    return args;
}
@end