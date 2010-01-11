//
//  IMTaskOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "NMOperation.h"
#import "IMTaskOperation.h"
#import "IMOperation.h"

@implementation IMTaskOperation
@synthesize task, arguments, launchPath;

-(id) init {
    return [self initWithLaunchPath: nil];
}

-(id) initWithLaunchPath:(NSString*) lp {
    self = [super init];
    [NMOperation setupNMICAEnvVars];
    if (self) {
        arguments = [[NSMutableDictionary alloc] init];
        self.launchPath = lp;
        task = [[NSTask alloc] init];
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
- (void) initializeTask: (NSTask*) task {
    @throw [NSException exceptionWithName:@"IMInitializeTaskNotOverridenException" 
                                   reason:@"-initializeTask: should be overridden in subclasses of IMTaskOperation" 
                                 userInfo:nil];
    
}

-(void) initializeArguments:(NSDictionary*) args {
    @throw [NSException exceptionWithName:@"IMInitializeArgumentsNotOverridenException" 
                                   reason:@"-initializeArguments: should be overridden in subclasses of IMTaskOperation" 
                                 userInfo:nil];
}

- (void)start {
    // Create the NSTask object.
    //task = [[NSTask alloc] init];
    
    //[[[NSApplication sharedApplication] delegate] registerNotifications];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self initializeTask: self.task];
    [self initializeArguments: arguments];
    NSArray *args = [IMTaskOperation argumentArrayFromDictionary:arguments];
    [task setArguments:args];
    
    NSLog(@"Starting task:\n%@ %@", launchPath, [args componentsJoinedByString:@" "]);
    [task setLaunchPath:launchPath];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(handleTaskExitedNotification:) 
                                                 name: NSTaskDidTerminateNotification 
                                               object: task];
    
    // If the operation hasn't already been cancelled, launch it.
    if (![self isCancelled]) {
        [self willChangeValueForKey:@"isExecuting"];
        isExecuting = YES;
        NSLog(@"TASK:%@",task);
        [task launch];
        [self run];
        NSLog(@"Task has now been run.");
        [self didChangeValueForKey:@"isExecuting"];
        
        NSLog(@"Changing isExecuting...");
        [self willChangeValueForKey:@"isExecuting"];
        isExecuting = NO;
        [self didChangeValueForKey:@"isExecuting"];
        
        [self willChangeValueForKey:@"isFinished"];
        isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        PCLog(@"IMTaskOperation done.");
    }
    
    [pool drain];
    [pool release];
}

- (void)handleTaskExitedNotification:(NSNotification*)aNotification {
    PCLog(@"IMTaskOperation: terminating...");
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    isFinished = YES;
    isExecuting = NO;
    
    // Clean up.
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: NSTaskDidTerminateNotification
                                                  object: task];
    //[task release]; //handled by dealloc
    
    PCLog(@"Task exit notification received successfully.\n");
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

+(NSArray*) argumentArrayFromDictionary:(NSMutableDictionary*) dict {
    NSMutableArray *args = [NSMutableArray array];
    
    //TODO: Make valueless keys be output in the end
    for (id key in [dict allKeys]) {
        id value = [dict objectForKey:key];
        [args addObject: key];
        if (value != [NSNull null]) {
            if ([value isKindOfClass:[NSArray class]]) {
                PCLog(@"Value: %@ Class:%@",value, [value class]);
                for (id v in (NSArray*)value) {
                    if (![v isKindOfClass: [NSString class]]) {
                        [args addObject:[v stringValue]];                    
                    } else {
                        [args addObject: v];
                    }
                }
            } else {
                if (![value isKindOfClass: [NSString class]]) {
                    [args addObject:[value stringValue]];                    
                } else {
                    [args addObject: value];
                }
            }
        }
    }
    ddfprintf(stderr, @"%@",args);
    return args;
}


-(NSString*) argumentsString {
    [self initializeArguments: arguments];
    return [NSString stringWithFormat:@"%@ %@",
             self.launchPath,
             [[IMTaskOperation argumentArrayFromDictionary: arguments] componentsJoinedByString: @" "]];
}


-(void) cancel {
    ddfprintf(stderr,@"About to terminate %@...\n",self.launchPath);
    [task terminate];
    ddfprintf(stderr,@"Terminated %@\n",self.launchPath);
    [super cancel];
}

-(IBAction) copyToClipboard:(id) sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
    [pb declareTypes:types owner:self];
    [pb setString: [self argumentsString] forType:NSStringPboardType];
}

@end