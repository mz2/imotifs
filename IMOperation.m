//
//  IMOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 12/9/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "IMOperation.h"


@implementation IMOperation
@synthesize isExecuting, isFinished;

- (id) init {
    self = [super init];
    if (self != nil) {
        isExecuting = NO;
        isFinished = NO;
    }
    return self;
}

- (BOOL)isConcurrent {
    return NO;
}

- (void) run {
    
}

- (void) start {
    //[[[NSApplication sharedApplication] delegate] registerNotifications];
    if (![self isCancelled]) {
        [self willChangeValueForKey:@"isExecuting"];
        isExecuting = YES;
        [self didChangeValueForKey:@"isExecuting"];
        [self run];
    }
}
@end