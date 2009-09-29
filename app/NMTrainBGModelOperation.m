//
//  NMTrainBGModelOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 1/29/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "IMTaskOperation.h"
#import "NMTrainBGModelOperation.h"


@implementation NMTrainBGModelOperation
@synthesize inputSequencePath, outputBackgroundModelFilePath;
@synthesize classes,order;

- (id) init
{
    self = [super init];
    if (self != nil) {
        classes = 4;
        order = 1;
    }
    return self;
}

-(void) dealloc {
    [inputSequencePath release];
    [outputBackgroundModelFilePath release];
    [super dealloc];
}

-(void) initializeArguments:(NSMutableDictionary*)args {
    [args setObject:inputSequencePath forKey:@"-seqs"];
    [args setObject:outputBackgroundModelFilePath forKey:@"-out"];
    [args setObject:[NSString stringWithFormat:@"%d",classes] forKey:@"-classes"];
    [args setObject:[NSString stringWithFormat:@"%d",order] forKey:@"-order"];
}

-(void) initializeTask:(NSTask*) t {
    t = [[NSTask alloc] init];
    
    NSPipe *stdOutPipe = [NSPipe pipe];
    //NSPipe *stdErrPipe = [NSPipe pipe];
    readHandle = [[stdOutPipe fileHandleForReading] retain];
    //errorReadHandle = [[stdErrPipe fileHandleForReading] retain];
    
    [t setStandardOutput: stdOutPipe];
    //[task setStandardError: stdErrPipe];
    //[self setLaunchPath:launchPath];
}


@end
