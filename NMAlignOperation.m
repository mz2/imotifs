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
    self = [super init];
    if (self != nil) {
        self.launchPath = [[[[[NSUserDefaults standardUserDefaults] stringForKey:NMExtraBinPath] 
                           stringByAppendingPathComponent:@"bin/nmalign"] stringByExpandingTildeInPath] retain];
        NSLog(@"nmalign launch path: %@", self.launchPath);
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
        NSLog(@"Input motifs written to temporary file %@", inputTempPath);
        NSLog(@"Output motifs will be written to temporary file at %@", outputTempPath);
    }
    return self;    
}

-(void) initializeTask {
    NSLog(@"Initializing task");
    setenv("NMICA_DEV_HOME", [[[[NSUserDefaults standardUserDefaults] stringForKey:NMBinPath] stringByExpandingTildeInPath] cStringUsingEncoding:NSUTF8StringEncoding], YES);
    setenv("NMICA_HOME", [[[[NSUserDefaults standardUserDefaults] stringForKey:NMBinPath] stringByExpandingTildeInPath] cStringUsingEncoding:NSUTF8StringEncoding], YES);
    //setenv("FOOBAR", "FOOBARRR!", YES);
    
    task = [[NSTask alloc] init];
    //[[task environment] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:NMBinPath] forKey:@"NMICA_DEV_HOME"];
    //[[task environment] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:NMBinPath] forKey:@"NMICA_HOME"];
    //[[task environment] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:NMExtraBinPath] forKey:@"NMICA_EXTRA_HOME"];
    
    
    if (inputTempPath == nil) {
        for (NSString *inPath in inputPaths) {
            [arguments setObject:[NSNull null] forKey: inPath];
        }
    } else {
        [arguments setObject:[NSNull null] forKey: inputTempPath]; 
    }
    
    if (outputTempPath == nil) {
        if (outputPath != nil) {
            [arguments setObject:self.outputPath forKey:@"-out"];
        }        
    } else {
        [arguments setObject:outputTempPath forKey:@"-out"];
    }

    if (self.maxPrecision > 0.0) {
        [arguments setObject:[NSString stringWithFormat:@"%f",maxPrecision] forKey:@"-maxPrecision"];        
    }
    
    if (self.minColWeight > 0.0) {
        [arguments setObject:[NSString stringWithFormat:@"%f",minColWeight] forKey:@"-minColWeight"];
    }
    
    if (self.minCols > 0) {
        [arguments setObject:[NSString stringWithFormat:@"%d",minCols] forKey:@"-minCols"];        
    }
    
    if (self.outputType == NMAlignOutputTypeAll) {
        [arguments setObject:@"all" forKey:@"-outputType"];
    } else if (self.outputType == NMAlignOutputTypeAverage) {
        [arguments setObject:@"avg" forKey:@"-outputType"];
    } else if (self.outputType == NMAlignOutputTypeMetamotif) {
        [arguments setObject:@"metamotif" forKey:@"-outputType"];
    }
    
    NSPipe *stdOutPipe = [NSPipe pipe];
    NSPipe *stdErrPipe = [NSPipe pipe];
    readHandle = [[stdOutPipe fileHandleForReading] retain];    
    errorReadHandle = [[stdErrPipe fileHandleForReading] retain];
    [task setStandardOutput: stdOutPipe];
    [task setStandardError: stdErrPipe];
}

-(void) run {
    NSLog(@"Running task");
    
    [motifSetDocument performSelectorOnMainThread: @selector(motifAlignmentStarted:) 
                                       withObject: self 
                                    waitUntilDone: YES];    
    
    NSData *inData = nil;
    NSData *errData = nil;
    NSMutableString *buf = [[NSMutableString alloc] init];
    
    //NSLog(@"Initialised buffer");
    while (((inData = [readHandle availableData]) && inData.length) 
           ||
           ((errData = [errorReadHandle availableData]) && errData.length)) {
        //NSLog(@"About to read");
        NSString *str = [[NSString alloc] initWithData: inData 
                                              encoding: NSUTF8StringEncoding];
        NSString *errStr = [[NSString alloc] initWithData: errData 
                                              encoding: NSUTF8StringEncoding];
        
        NSLog(@"%@",str);
        NSLog(@"%@",errStr);
        //DebugLog(@"inData: %@", str);
        
        
        [buf appendString:str];
        [str release];
        //[errStr release];
        
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

    ddfprintf(stderr,@"NMOperation Done.\n");
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

-(void) cancel {
    ddfprintf(stderr,@"Canceling alignment task...\n");
    [task terminate];
    ddfprintf(stderr,@"Alignment task terminated\n");
    [super cancel];
}

- (void) dealloc {
    NSLog(@"Deallocating NMAlignOperation");
    [readHandle release];
    [errorReadHandle release];
    [motifSetDocument release];
    [inputPaths release];
    [outputPath release];
    [namePrefix release];
    [task release];
    [super dealloc];
}

@end
