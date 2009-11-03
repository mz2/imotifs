//
//  NMROCAUCOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NMROCAUCOperation.h"
#import "NMOperation.h"

@implementation NMROCAUCOperation
@synthesize motifsFile = _motifsFile;
@synthesize positiveSeqsFile = _positiveSeqsFile;
@synthesize negativeSeqsFile = _negativeSeqsFile;
@synthesize outputFile = _outputFile;
@synthesize bootstraps = _bootstraps;
@synthesize statusDialogController = _statusDialogController;

-(id) init {
    NSString *lp = 
    [[[[NMOperation nmicaExtraPath] 
       stringByAppendingPathComponent:@"bin/nmrocauc"] 
      stringByExpandingTildeInPath] retain];
    
    self = [super initWithLaunchPath: lp];
    
    if (self == nil) return nil;
    
    self.bootstraps = 10000;
    
    return self;
}

-(void) dealloc {
    [_motifsFile release],_motifsFile = nil;
    [_positiveSeqsFile release],_positiveSeqsFile = nil;
    [_negativeSeqsFile release],_negativeSeqsFile = nil;
    [_outputFile release],_outputFile = nil;
    
    [super dealloc];
}


-(void) initializeArguments:(NSMutableDictionary*) args {
    [args setObject:self.motifsFile forKey:@"-motifs"];        
    [args setObject:self.positiveSeqsFile forKey:@"-positiveSeqs"];        
    [args setObject:self.negativeSeqsFile forKey:@"-negativeSeqs"];        
    [args setObject:self.outputFile forKey:@"-out"];
    
    [args setObject:[NSNumber numberWithInt:_bootstraps] forKey:@"-bootstraps"];
    
}

-(void) initializeTask:(NSTask*)t {
    NSPipe *stdOutPipe = [NSPipe pipe];
    _readHandle = [[stdOutPipe fileHandleForReading] retain];
    
    [t setStandardOutput: stdOutPipe];
}

-(void) run {
    NSData *inData = nil;
    //NSData *errData = nil;
    NSMutableString *buf = [[NSMutableString alloc] init];
    DebugLog(@"Running");
    while ((inData = [_readHandle availableData]) && inData.length) {
        NSString *str = [[NSString alloc] initWithData: inData 
                                              encoding: NSUTF8StringEncoding];
        [buf appendString:str];
        [str release];
        
        NSArray *lines = [buf componentsSeparatedByString: @"\n"];
        if ([lines count] == 1) {
            //either line is not finished or exactly one line was returned
            //either way, we'll wait until some more can be read
            DebugLog(@"Line count : %@", lines);
        } else {
            //init new buffer with the last remnants
            NSMutableString *newBuf = [[NSMutableString alloc] 
                                       initWithString:[lines objectAtIndex: lines.count - 1]];
            DebugLog(@"Buffer: %@", buf);
            [buf release];
            buf = newBuf;
        }
        
    }
    
    DebugLog(@"Done.");
    [_statusDialogController performSelectorOnMainThread: @selector(resultsReady:) 
                                              withObject: self 
                                           waitUntilDone: NO];
}


-(BOOL) motifsFileExists {
    if (self.motifsFile == nil) return NO;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:self.motifsFile];
}

-(BOOL) positiveSeqsFileExists {
    if (self.positiveSeqsFile == nil) return NO;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:self.positiveSeqsFile];
}

-(BOOL) negativeSeqsFileExists {
    if (self.negativeSeqsFile == nil) return NO;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:self.negativeSeqsFile];
}

-(NSString*) outFilename {
    return self.outputFile;
}

@end
