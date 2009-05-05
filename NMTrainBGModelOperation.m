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

-(void) initializeTask {
    task = [[NSTask alloc] init];
    numFormatter = [[NSNumberFormatter alloc] init];
    
    [arguments setObject:inputSequencePath forKey:@"-seqs"];
    [arguments setObject:outputBackgroundModelFilePath forKey:@"-out"];
    [arguments setObject:[NSString stringWithFormat:@"%d",classes] forKey:@"-classes"];
    [arguments setObject:[NSString stringWithFormat:@"%d",order] forKey:@"-order"];
    
    NSPipe *stdOutPipe = [NSPipe pipe];
    //NSPipe *stdErrPipe = [NSPipe pipe];
    readHandle = [[stdOutPipe fileHandleForReading] retain];
    //errorReadHandle = [[stdErrPipe fileHandleForReading] retain];
    
    [task setStandardOutput: stdOutPipe];
    //[task setStandardError: stdErrPipe];
    //[self setLaunchPath:launchPath];
}


@end
