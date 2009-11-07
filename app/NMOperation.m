//
//  NMOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "stdlib.h"
#import "NMOperation.h"
#import "IMAppController.h"

@interface NMOperation (private)

-(void) parseNMInferLogLines:(NSArray*) lines;
-(void) initializeArguments;
@end


@implementation NMOperation
@synthesize readHandle, errorReadHandle, dialogController;
@synthesize numMotifs, minMotifLength, maxMotifLength,expectedUsageFraction,logInterval,maxCycles,reverseComplement;

@synthesize sequenceFilePath, outputMotifSetPath;
@synthesize backgroundModelPath,backgroundClasses,backgroundOrder;

+(NSString*) nmicaPath {
    NSString *nmicaPath;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IMUseBuiltInNMICA"]) {
        nmicaPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Java/nmica"];
    } else {
        nmicaPath = [[[NSUserDefaults standardUserDefaults] stringForKey:NMBinPath] stringByExpandingTildeInPath];
    }
    
    return nmicaPath;
}

+(NSString*) nmicaExtraPath {
    NSString *nmicaExtraPath;
    
    [self nmicaPath]; //both need to be set for nmica-extra tools to work
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IMUseBuiltInNMICA"]) {
        nmicaExtraPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Java/nmica-extra"];
    } else {
        nmicaExtraPath = [[[NSUserDefaults standardUserDefaults] stringForKey:NMExtraBinPath] stringByExpandingTildeInPath];
    }
    
    return nmicaExtraPath;
}

+(void) setupNMICAEnvVars {
    setenv("NMICA_DEV_HOME", [[self nmicaPath] cStringUsingEncoding:NSUTF8StringEncoding], YES);
    setenv("NMICA_HOME", [[self nmicaPath] cStringUsingEncoding:NSUTF8StringEncoding], YES);
    setenv("NMICA_EXTRA_HOME", [[self nmicaExtraPath] cStringUsingEncoding:NSUTF8StringEncoding], YES);
    
    DebugLog(@"NMICA_DEV_HOME=%@",[self nmicaPath]);
    DebugLog(@"NMICA_HOME=%@",[self nmicaPath]);
    DebugLog(@"NMICA_EXTRA_HOME=%@",[self nmicaExtraPath]);
}

- (id) init
{
    NSString *lp = 
        [[[[NMOperation nmicaPath] stringByAppendingPathComponent:@"bin/nminfer"] 
          stringByExpandingTildeInPath] retain];
    [NMOperation setupNMICAEnvVars];
    
    self = [super initWithLaunchPath: lp];
    if (self == nil) return nil;
    
    logInterval = 100;
    maxCycles = 100000;
    NSLog(@"nminfer is at %@", launchPath);
    numMotifs = 1;
    minMotifLength = 6;
    maxMotifLength = 14;
    expectedUsageFraction = 0.5;
    reverseComplement = YES;
    backgroundClasses = 4;
    backgroundOrder = 1;
    
    return self;
}

-(void) initializeArguments:(NSMutableDictionary*) args {
    [args setObject:sequenceFilePath forKey:@"-seqs"];
    if (outputMotifSetPath != nil) {[args setObject:outputMotifSetPath forKey:@"-out"];}
    [args setObject:[NSString stringWithFormat:@"%d",logInterval] forKey:@"-logInterval"];
    [args setObject:[NSString stringWithFormat:@"%d",maxCycles] forKey:@"-maxCycles"];
    [args setObject:[NSString stringWithFormat:@"%d",numMotifs] forKey:@"-numMotifs"];
    [args setObject:[NSString stringWithFormat:@"%d",minMotifLength] forKey:@"-minLength"];
    [args setObject:[NSString stringWithFormat:@"%d",maxMotifLength] forKey:@"-maxLength"];
    [args setObject:[NSString stringWithFormat:@"%f",expectedUsageFraction] forKey:@"-expectedUsageFraction"];
    if (reverseComplement) {[args setObject:[NSNull null] forKey:@"-revComp"];}
    
    if (backgroundModelPath != nil) {
        [args setObject:self.backgroundModelPath forKey:@"-backgroundModel"];
    } else {
        [args setObject:[NSString stringWithFormat:@"%d",backgroundOrder] forKey:@"-backgroundOrder"];
        [args setObject:[NSString stringWithFormat:@"%d",backgroundClasses] forKey:@"-backgroundClasses"];
    }
}


-(void) initializeTask:(NSTask*) t {
    numFormatter = [[NSNumberFormatter alloc] init];
    [self initializeArguments:self.arguments];
    
    NSPipe *stdOutPipe = [NSPipe pipe];
    readHandle = [[stdOutPipe fileHandleForReading] retain];
    
    [t setStandardOutput: stdOutPipe];
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
