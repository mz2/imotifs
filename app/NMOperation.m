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
#import <BioCocoa/BCSequenceReader.h>
#import <BioCocoa/BCSequenceArray.h>

@interface NMOperation (private)

-(void) parseNMInferLogLines:(NSArray*) lines;
-(void) initializeArguments;
@end


@implementation NMOperation
@synthesize readHandle, errorReadHandle, dialogController;
@synthesize numMotifs, minMotifLength, maxMotifLength,expectedUsageFraction,logInterval,maxCycles,reverseComplement;

@synthesize sequenceFilePath, outputMotifSetPath;
@synthesize backgroundModelPath,backgroundClasses,backgroundOrder;

@synthesize backgroundModelFromFile = backgroundModelFromFile;
@synthesize backgroundModelFromInputSequences = backgroundModelFromInputSequences;

+ (void) initialize 
{
    [[self class] setKeys:
     [NSArray arrayWithObjects: @"numMotifs", nil]
triggerChangeNotificationsForDependentKey: @"motifCountIsAlarminglyLarge"];
    
    [[self class] setKeys:
     [NSArray arrayWithObjects: @"backgroundModelFromFile", @"backgroundModelFromInputSequences", @"backgroundModelPath", nil]
triggerChangeNotificationsForDependentKey: @"backgroundModelParametersOrFileExist"];
    
}



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
    
    PCLog(@"NMICA_DEV_HOME=%@",[self nmicaPath]);
    PCLog(@"NMICA_HOME=%@",[self nmicaPath]);
    PCLog(@"NMICA_EXTRA_HOME=%@",[self nmicaExtraPath]);
}

- (id) init
{
    NSString *lp = 
        [[[[NMOperation nmicaPath] stringByAppendingPathComponent:@"bin/nminfer"] 
          stringByExpandingTildeInPath] retain];
    [NMOperation setupNMICAEnvVars];
    
    self = [super initWithLaunchPath: lp];
    if (self == nil) return nil;
    
    self.backgroundModelFromFile = YES;
    
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
    
    if (self.backgroundModelFromFile) {
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
    PCLog(@"Setting sequence file path to %@",str);
    [self willChangeValueForKey:@"sequenceFilePath"];
    NSString *newSeqFilePath = [str copy];
    [sequenceFilePath release];
    sequenceFilePath = newSeqFilePath;
    
    if ((outputMotifSetPath == nil) || (outputMotifSetPath.length == 0)) {
        NSString *path = [[sequenceFilePath lastPathComponent] 
                            stringByReplacingOccurrencesOfString:[sequenceFilePath pathExtension] 
                            withString:@"xms"];
        
        self.outputMotifSetPath = 
            [[sequenceFilePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:
                path]; 
    }
    [self didChangeValueForKey:@"sequenceFilePath"];
    
    if (self.sequenceFilePath.length > 0 && [[NSFileManager defaultManager] fileExistsAtPath:sequenceFilePath]) {
        BCSequenceReader *sequenceReader = [[[BCSequenceReader alloc] init] autorelease];
        BCSequenceArray *sequenceArray = [sequenceReader readFileUsingPath: sequenceFilePath 
                                                                    format: BCFastaFileFormat];
        
        PCLog(@"Sequence count: %d", [sequenceArray count]);
        if (sequenceArray.count > IMMaxAdvisedSeqCountForNMInfer) {
            NSAlert *alert = [[[NSAlert alloc] init] autorelease];
            [alert addButtonWithTitle:@"OK"];
            [alert setMessageText:[NSString stringWithFormat:@"Large sequence set (%d entries)", sequenceArray.count]];
            [alert setInformativeText:
             @"The sequence set you provided is large \
and consequently the running time required for NestedMICA motif inference can be long. \
It is adviseable to run the task on the command line as a batch job. \
You can use the 'Copy to Clipboard' function and pasting to the Terminal app \
to create a command line batch job easily."];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            [alert beginSheetModalForWindow:[NSApp mainWindow] 
                              modalDelegate:self 
                             didEndSelector:@selector(seqCountAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        }
    } else if (self.sequenceFilePath.length > 0 && ![[NSFileManager defaultManager] fileExistsAtPath:sequenceFilePath]) {
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:[NSString stringWithFormat:@"File doesn't exist"]];
        [alert setInformativeText:
        [NSString stringWithFormat:@"File doesn't exist at %@.",self.sequenceFilePath]];
        [alert setAlertStyle:NSWarningAlertStyle];
        
        [alert beginSheetModalForWindow:[NSApp mainWindow] 
                          modalDelegate:self 
                         didEndSelector:@selector(seqFileDoesntExistAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
}

- (void)seqCountAlertDidEnd:(NSAlert *)alert 
                 returnCode:(NSInteger)returnCode
                contextInfo:(void *)contextInfo {
    
}

- (void)seqFileDoesntExistAlertDidEnd:(NSAlert *)alert 
                 returnCode:(NSInteger)returnCode
                contextInfo:(void *)contextInfo {
    
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
        //PCLog(@"inData: %@", str);
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
        PCLog(@"Warning! could not parse output line (unexpected number of components : %d). line:'%@'", components.count,line);
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
        
        
    //PCLog(@"iterationNo: %d priorMass : %f bestLikelihood: %f accumEvidence : %f iterationTime: %f", 
    //          iterationNo, priorMassShifted, bestLikelihood, accumEvidence, iterationTime);
    }
}

-(void) setMinMotifLength:(NSUInteger) i {
    PCLog(@"Setting minimum motif length to %d", i);
    [self willChangeValueForKey:@"minMotifLength"];
    minMotifLength = i;
}

-(void) setBackgroundModelFromFile:(BOOL) yesno {
    backgroundModelFromFile = yesno;
    if (yesno) {
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"backgroundModelFromInputSequences"];
    }
}

-(void) setBackgroundModelFromInputSequences:(BOOL) yesno {
    backgroundModelFromInputSequences = yesno;
    if (yesno) {
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"backgroundModelFromFile"];
    }
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

-(BOOL) inputSequencesFileExists {
    BOOL yesno = [[NSFileManager defaultManager] fileExistsAtPath: self.sequenceFilePath];
    PCLog(@"Input sequences file exists: %d", yesno);
    return yesno;
}

-(BOOL) backgroundModelFileExists {
    BOOL yesno = [[NSFileManager defaultManager] fileExistsAtPath: self.backgroundModelPath];
    PCLog(@"Background model file exists: %d", yesno);
    return yesno;
}

-(BOOL) backgroundModelParametersOrFileExist {
    PCLog(@"Determining if background model parameters or file exists");
    if (self.backgroundModelFromInputSequences) return YES;
    
    else if (self.backgroundModelFromFile) {
        return [self backgroundModelFileExists];
    }
    return NO;
}

-(BOOL) motifCountIsAlarminglyLarge {
    return self.numMotifs > IMAdviseableNumMotifsForNMInfer;
}
@end
