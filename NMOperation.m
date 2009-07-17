//
//  NMOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "stdlib.h"
#import "NMOperation.h"
#import "AppController.h"

@interface NMOperation (private)

-(void) parseNMInferLogLines:(NSArray*) lines;
-(void) initializeArguments;
@end


@implementation NMOperation
@synthesize readHandle, errorReadHandle, dialogController;
@synthesize numMotifs, minMotifLength, maxMotifLength,expectedUsageFraction,logInterval,maxCycles,reverseComplement;

@synthesize sequenceFilePath, outputMotifSetPath;
@synthesize backgroundModelPath,backgroundClasses,backgroundOrder;

- (id) init
{
    self = [super init];
    if (self != nil) {
        logInterval = 100;
        maxCycles = 100000;
        launchPath = [[[[[NSUserDefaults standardUserDefaults] 
                        stringForKey:NMBinPath] stringByExpandingTildeInPath] stringByAppendingPathComponent: @"bin/nminfer"] retain];
        NSLog(@"nminfer is at %@", launchPath);
        numMotifs = 1;
        minMotifLength = 6;
        maxMotifLength = 14;
        expectedUsageFraction = 0.5;
        reverseComplement = YES;
        backgroundClasses = 4;
        backgroundOrder = 1;
    }
    return self;
}

-(void) initializeArguments {
    [arguments setObject:sequenceFilePath forKey:@"-seqs"];
    if (outputMotifSetPath != nil) {[arguments setObject:outputMotifSetPath forKey:@"-out"];}
    [arguments setObject:[NSString stringWithFormat:@"%d",logInterval] forKey:@"-logInterval"];
    [arguments setObject:[NSString stringWithFormat:@"%d",maxCycles] forKey:@"-maxCycles"];
    [arguments setObject:[NSString stringWithFormat:@"%d",numMotifs] forKey:@"-numMotifs"];
    [arguments setObject:[NSString stringWithFormat:@"%d",minMotifLength] forKey:@"-minLength"];
    [arguments setObject:[NSString stringWithFormat:@"%d",maxMotifLength] forKey:@"-maxLength"];
    [arguments setObject:[NSString stringWithFormat:@"%f",expectedUsageFraction] forKey:@"-expectedUsageFraction"];
    if (reverseComplement) {[arguments setObject:[NSNull null] forKey:@"-revComp"];}
    
    if (backgroundModelPath != nil) {
        [arguments setObject:self.backgroundModelPath forKey:@"-backgroundModel"];
    } else {
        [arguments setObject:[NSString stringWithFormat:@"%d",backgroundOrder] forKey:@"-backgroundOrder"];
        [arguments setObject:[NSString stringWithFormat:@"%d",backgroundClasses] forKey:@"-backgroundClasses"];
    }
}

-(NSString*) argumentsString {
    [self initializeArguments];
    return [@"nminfer " stringByAppendingString:[[IMTaskOperation argumentArrayFromDictionary:arguments] componentsJoinedByString:@" "]];
}

-(void) initializeTask {
    task = [[NSTask alloc] init];
    numFormatter = [[NSNumberFormatter alloc] init];
    [self initializeArguments];
    
    NSPipe *stdOutPipe = [NSPipe pipe];
    //NSPipe *stdErrPipe = [NSPipe pipe];
    readHandle = [[stdOutPipe fileHandleForReading] retain];
    //errorReadHandle = [[stdErrPipe fileHandleForReading] retain];
    
    [task setStandardOutput: stdOutPipe];
    //[task setStandardError: stdErrPipe];
    //[self setLaunchPath:launchPath];
}

-(void) setSequenceFilePath:(NSString*) str {
    DebugLog(@"Setting sequence file path to %@",str);
    [self willChangeValueForKey:@"sequenceFilePath"];
    sequenceFilePath = str;
    if ((outputMotifSetPath == nil) || (outputMotifSetPath.length == 0)) {
        self.outputMotifSetPath = [[sequenceFilePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:
             [[sequenceFilePath lastPathComponent] 
                        stringByReplacingOccurrencesOfString:@".fasta" 
                                                  withString:@".xms"]]; 
    }
    [self didChangeValueForKey:@"sequenceFilePath"];
    
}

-(void) run {
    [dialogController performSelectorOnMainThread: @selector(setStatus:) 
                                       withObject: @"Discovering sequence motifs..." 
                                    waitUntilDone: NO];    
    
    NSData *inData = nil;
    NSMutableString *buf = [[NSMutableString alloc] init];
    while ((inData = [readHandle availableData]) && inData.length) {
        NSString *str = [[NSString alloc] initWithData: inData 
                                              encoding: NSUTF8StringEncoding];
        //DebugLog(@"inData: %@", str);
        [buf appendString:str];
        [str release];
        
        NSArray *lines = [buf componentsSeparatedByString: @"\n"];
        if ([lines count] == 1) {
            //either line is not finished or exactly one line was returned
            //either way, we'll wait until some more can be read
        } else {
            //init new buffer with the last remnants
            NSMutableString *newBuf = [[NSMutableString alloc] initWithString:[lines objectAtIndex: lines.count - 1]];
            [buf release];
            buf = newBuf;
            [self parseNMInferLogLines: lines];
        }
    }
    
    [dialogController performSelectorOnMainThread: @selector(motifDiscoveryDone:) 
                                       withObject: self 
                                    waitUntilDone: NO];
    
    [dialogController performSelectorOnMainThread: @selector(setStatus:) 
                                       withObject: @"Discover Sequence Motifs : Done." 
                                    waitUntilDone: NO];
    ddfprintf(stderr,@"NMOperation done.\n");
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
        DebugLog(@"Warning! could not parse output line (unexpected number of components : %d). line:'%@'", components.count,line);
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
        
        
    //DebugLog(@"iterationNo: %d priorMass : %f bestLikelihood: %f accumEvidence : %f iterationTime: %f", 
    //          iterationNo, priorMassShifted, bestLikelihood, accumEvidence, iterationTime);
    }
}

-(void) setMinMotifLength:(NSUInteger) i {
    DebugLog(@"Setting minimum motif length to %d", i);
    [self willChangeValueForKey:@"minMotifLength"];
    minMotifLength = i;
}

-(void) cancel {
    ddfprintf(stderr,@"About to terminate NMICA...\n");
    [task terminate];
    ddfprintf(stderr,@"NMICA terminated\n");
    [super cancel];
}

- (void) dealloc {
    [readHandle release];
    [errorReadHandle release];
    [dialogController release];
    
    [sequenceFilePath release];
    [outputMotifSetPath release];
    [backgroundModelPath release];
    
    [numFormatter release];
    [super dealloc];
}
@end
