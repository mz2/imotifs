//
//  NMOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "NMOperation.h"

@interface NMOperation (private)

-(void) parseNMInferLogLines:(NSArray*) lines;

@end


@implementation NMOperation
@synthesize readHandle, errorReadHandle, dialogController;

-(void) run {
    NSLog(@"Running NMOperation");
    [dialogController performSelectorOnMainThread: @selector(setStatus:) 
                                       withObject: @"Discovering motifs..." 
                                    waitUntilDone: NO];
    
    NSData *inData = nil;
    ddfprintf(stderr,@"Reading data from NMICA\n");
    NSMutableString *buf = [[NSMutableString alloc] init];
    while ((inData = [readHandle availableData]) && inData.length) {
        NSString *str = [[NSString alloc] initWithData: inData 
                                              encoding: NSUTF8StringEncoding];
        //NSLog(@"inData: %@", str);
        [buf appendString:str];
        [str release];
        
        NSArray *lines = [buf componentsSeparatedByString: @"\n"];
        if ([lines count] == 1) {
            //either line is not finished or exactly one line was returned
            //either way, we'll wait until some more can be read
        } else {
            //NSUInteger i,cnt;
            //for (i = 0,cnt=lines.count; i < cnt - 1;i++) {
                //NSLog(@"%@", [lines objectAtIndex:i]);
            //}
            //init new buffer with the last remnants
            NSMutableString *newBuf = [[NSMutableString alloc] initWithString:[lines objectAtIndex: lines.count - 1]];
            [buf release];
            buf = newBuf;
            [self parseNMInferLogLines: lines];
            //NSLog(@"Last, incomplete line: '%@'", [lines objectAtIndex:lines.count - 1]);
        }
    }
    
    [dialogController performSelectorOnMainThread: @selector(stopAnimatingSpinner:) 
                                       withObject: self 
                                    waitUntilDone: NO];
    
    NSLog(@"NMOperation Done.");
}

-(void) parseNMInferLogLines:(NSArray*) lines {
    //only last line actually ever used
    NSString *line = nil;
    if (lines.count == 0) return;
    else if (lines.count == 1) line = [lines objectAtIndex:0];
    else {
        //last line assumed to be blank.
        line = [lines objectAtIndex:lines.count - 2];
    }
    NSArray *components = [line componentsSeparatedByString:@"\t"];
    if (components.count != 5) {
        NSLog(@"Warning! could not parse output line (unexpected number of components : %d). line:'%@'", components.count,line);
    } else {
        NSNumber *iterationNo = [numFormatter numberFromString:[components objectAtIndex:0]];
        NSNumber *priorMassShifted = [numFormatter numberFromString:[components objectAtIndex:1]];
        NSNumber *bestLikelihood = [numFormatter numberFromString:[components objectAtIndex:2]];
        NSNumber *accumEvidence = [numFormatter numberFromString:[components objectAtIndex:3]];
        NSNumber *iterationTime = [numFormatter numberFromString:[components objectAtIndex:4]];
        [dialogController performSelectorOnMainThread: @selector(setIterationNumber:)
                                               withObject: iterationNo waitUntilDone: NO];
        [dialogController performSelectorOnMainThread: @selector(setPriorMassShifted:)
                                           withObject: priorMassShifted waitUntilDone: NO];
        [dialogController performSelectorOnMainThread: @selector(setBestLikelihood:)
                                           withObject: bestLikelihood waitUntilDone: NO];
        [dialogController performSelectorOnMainThread: @selector(setAccummulatedEvidence:)
                                           withObject: accumEvidence waitUntilDone: NO];
        [dialogController performSelectorOnMainThread: @selector(setIterationTime:)
                                           withObject: iterationTime waitUntilDone: NO];            
    //NSLog(@"iterationNo: %d priorMass : %f bestLikelihood: %f accumEvidence : %f iterationTime: %f", 
    //          iterationNo, priorMassShifted, bestLikelihood, accumEvidence, iterationTime);
    }
}

-(id) initMotifDiscoveryTaskWithSequences: (NSString*) seqfpath
                                 outputPath: (NSString*) outputpath {
    NSTask *t = [[NSTask alloc] init];
    NSMutableArray *args = [NSMutableArray array];
    numFormatter = [[NSNumberFormatter alloc] init];
    [args addObject:@"-seqs"];
    [args addObject:seqfpath];
    [args addObject:@"-out"];
    [args addObject:outputpath];
    [args addObject:@"-logInterval"];
    [args addObject:[NSString stringWithFormat:@"%d",100]];
    [args addObject:@"-maxCycles"];
    [args addObject:[NSString stringWithFormat:@"%d",10000]];
    
    NSPipe *stdOutPipe = [NSPipe pipe];
    NSPipe *stdErrPipe = [NSPipe pipe];
    readHandle = [[stdOutPipe fileHandleForReading] retain];
    errorReadHandle = [[stdErrPipe fileHandleForReading] retain];
    
    // write handle is closed to this process
    [t setArguments: args];
    //[t setStandardOutput: [NSFileHandle fileHandleWithNullDevice]];
    [t setStandardOutput: stdOutPipe];
    [t setStandardError: [NSFileHandle fileHandleWithNullDevice]];
    
    //TODO: Make configurable from user defaults
    [t setLaunchPath:@"/Users/mp4/workspace/nmica-dev/bin/nminfer"];
    [t setArguments:args];
    
    
    self = [super initWithTask: t arguments:args];
    [t release]; //t is retained by the superclass constructor
    return self;
}
-(void) cancel {
    NSLog(@"About to terminate NMICA...");
    [task terminate];
    NSLog(@"NMICA terminated");
    [super cancel];
}

- (void) dealloc {
    [readHandle release];
    [errorReadHandle release];
    [super dealloc];
}
@end
