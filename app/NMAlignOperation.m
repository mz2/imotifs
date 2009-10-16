//
//  NMAlignOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 03/06/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "NMAlignOperation.h"
#import "MotifSet.h"
#import "AppController.h"
#import "MotifSetDocument.h"
#import "NMOperation.h"

@interface NMAlignOperation (private)
-(void) parseNMAlignLogLines:(NSArray*) lines;
@end


@implementation NMAlignOperation
@synthesize inputPaths,outputPath;
@synthesize namePrefix;
@synthesize motifSetDocument;
@synthesize addName;
@synthesize maxPrecision,minColWeight;
@synthesize minCols;
@synthesize outputType;
@synthesize readHandle, errorReadHandle;

-(id) initWithMotifSet:(MotifSet*) mset {
    NSString *lp = 
        [[[[NMOperation nmicaExtraPath] stringByAppendingPathComponent:@"bin/nmalign"] stringByExpandingTildeInPath] retain];
    [NMOperation setupNMICAEnvVars];
    self = [super initWithLaunchPath: lp];
    if (self != nil) {

        
        self.addName = NO;
        self.maxPrecision = 0.0;
        self.minColWeight = 0.0;
        self.minCols = 0;
        self.outputType = NMAlignOutputTypeAll;
        
        inputTempPath = 
            [[NSTemporaryDirectory() stringByAppendingPathComponent:
             [NSString stringWithFormat: @"%d%@", rand(), @".xms"]] retain];
        
        outputTempPath = 
            [[NSTemporaryDirectory() stringByAppendingPathComponent:
             [NSString stringWithFormat: @"%d%@", rand(), @".xms"]] retain];
        
        NSError *err;
        [[[mset toXMS] description] writeToFile:inputTempPath 
                                     atomically:NO 
                                       encoding:NSUTF8StringEncoding error:&err];
        //NSLog(@"Input motifs written to temporary file %@", inputTempPath);
        //NSLog(@"Output motifs will be written to temporary file at %@", outputTempPath);
    }
    return self;    
}

-(void) initializeArguments:(NSMutableDictionary*) args {
    if (inputTempPath == nil) {
        for (NSString *inPath in inputPaths) {
            [args setObject:[NSNull null] forKey: inPath];
        }
    } else {
        [args setObject:[NSNull null] forKey: inputTempPath]; 
    }
    
    if (outputTempPath == nil) {
        if (outputPath != nil) {
            [args setObject:self.outputPath forKey:@"-out"];
        }        
    } else {
        [args setObject:outputTempPath forKey:@"-out"];
    }
    
    if (self.maxPrecision > 0.0) {
        [args setObject:[NSString stringWithFormat:@"%f",maxPrecision] forKey:@"-maxPrecision"];        
    }
    
    if (self.minColWeight > 0.0) {
        [args setObject:[NSString stringWithFormat:@"%f",minColWeight] forKey:@"-minColWeight"];
    }
    
    if (self.minCols > 0) {
        [args setObject:[NSString stringWithFormat:@"%d",minCols] forKey:@"-minCols"];        
    }
    
    if (self.outputType == NMAlignOutputTypeAll) {
        [args setObject:@"all" forKey:@"-outputType"];
    } else if (self.outputType == NMAlignOutputTypeAverage) {
        [args setObject:@"avg" forKey:@"-outputType"];
    } else if (self.outputType == NMAlignOutputTypeMetamotif) {
        [args setObject:@"metamotif" forKey:@"-outputType"];
    }
}

-(void) initializeTask:(NSTask*) t {
    
    NSPipe *stdOutPipe = [NSPipe pipe];
    NSPipe *stdErrPipe = [NSPipe pipe];
    readHandle = [[stdOutPipe fileHandleForReading] retain];    
    errorReadHandle = [[stdErrPipe fileHandleForReading] retain];
    [t setStandardOutput: stdOutPipe];
    [t setStandardError: stdErrPipe];
}

-(void) run {
    NSLog(@"Running task");
    
    [motifSetDocument performSelectorOnMainThread: @selector(motifAlignmentStarted:) 
                                       withObject: self 
                                    waitUntilDone: YES];    
    
    NSData *inData = nil;
    NSData *errData = nil;
    NSMutableString *buf = [[NSMutableString alloc] init];
    
    while (((inData = [readHandle availableData]) && inData.length) 
           ||
           ((errData = [errorReadHandle availableData]) && errData.length)) {
        //NSLog(@"About to read");
        NSString *str = [[NSString alloc] initWithData: inData 
                                              encoding: NSUTF8StringEncoding];
        NSString *errStr = [[NSString alloc] initWithData: errData 
                                              encoding: NSUTF8StringEncoding];
        
        NSLog(@"Align input: %@",str);
        NSLog(@"Align error: %@",errStr);
        
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
            [self parseNMAlignLogLines: lines];
        }
        
    }
    
    [motifSetDocument performSelectorOnMainThread: @selector(motifAlignmentDone:) 
                                       withObject: self 
                                    waitUntilDone: YES];
    
    if (inputTempPath != nil) {
        [[NSFileManager defaultManager] removeFileAtPath:inputTempPath handler: nil];
    }
    if (outputTempPath != nil) {
        NSError *err;
        //NSLog(@"Output motif set");
        //ddfprintf(stderr, @"Outputting motif set to a document.");
        NSDocumentController *sharedDocController = [NSDocumentController sharedDocumentController];
        MotifSetDocument *mdoc = [sharedDocController makeDocumentWithContentsOfURL: [NSURL fileURLWithPath:outputTempPath] 
                                                                             ofType: @"Motif set" 
                                                                              error: &err];
        
        [[NSDocumentController sharedDocumentController] addDocument: mdoc];
        [mdoc makeWindowControllers];
        [mdoc showWindows];
        [[NSFileManager defaultManager] removeFileAtPath:outputTempPath handler: nil];
    }

    ddfprintf(stderr,@"NMAlignOperation done.\n");
}

-(void) parseNMAlignLogLines:(NSArray*) lines {
    //only last line actually ever used
    NSString *line = nil;
    if (lines.count == 0) return;
    else if (lines.count == 1) line = [lines objectAtIndex:0];
    else {
        //last line assumed to be blank/unfinished
        line = [lines objectAtIndex:lines.count - 2];
    }
    //then do something with the lines
}

- (void) dealloc {
    NSLog(@"Deallocating NMAlignOperation");
    [readHandle release];
    [errorReadHandle release];
    [motifSetDocument release];
    [inputPaths release];
    [outputPath release];
    [namePrefix release];
    [super dealloc];
}

@end
