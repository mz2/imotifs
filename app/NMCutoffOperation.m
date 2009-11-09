//
//  NMCutoffOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <math.h>
#import "NMOperation.h"
#import "NMCutoffOperation.h"
#import "IMRetrieveSequencesStatusDialogController.h"

@implementation NMCutoffOperation
@synthesize motifsFile = _motifsFile;
@synthesize seqsFile = _seqsFile;
@synthesize bgFile = _bgFile;
@synthesize outputFile = _outputFile;
@synthesize significanceThreshold = _significanceThreshold;
@synthesize binSize = _binSize;
@synthesize defaultScoreCutoff = _defaultScoreCutoff;
@synthesize statusDialogController = _statusDialogController;

-(id) init {
    NSString *lp = 
    [[[[NMOperation nmicaExtraPath] 
       stringByAppendingPathComponent:@"bin/nmcutoff"] 
      stringByExpandingTildeInPath] retain];
    
    self = [super initWithLaunchPath: lp];
    
    [NMOperation setupNMICAEnvVars];

    if (self == nil) return nil;
    
    self.significanceThreshold = 0.05;
    self.binSize = 1.0;
    self.defaultScoreCutoff = -1.0;
    
    return self;
}

-(void) dealloc {
    [_motifsFile release],_motifsFile = nil;
    [_seqsFile release],_seqsFile = nil;
    [_bgFile release],_bgFile = nil;
    [_outputFile release],_outputFile = nil;
    [super dealloc];
}

-(void) initializeArguments:(NSMutableDictionary*) args {
    [args setObject:self.motifsFile forKey:@"-motifs"];        
    [args setObject:self.seqsFile forKey:@"-seqs"];        
    [args setObject:self.bgFile forKey:@"-backgroundModel"];        
    [args setObject:self.outputFile forKey:@"-out"];
    
    [args setObject:[NSNumber numberWithDouble:_significanceThreshold] forKey:@"-confThreshold"];
    [args setObject:[NSNumber numberWithDouble:_binSize] forKey:@"-bucketSize"];
    [args setObject:[NSNumber numberWithDouble: abs(_defaultScoreCutoff)] forKey:@"-defaultThreshold"]; //negate (nmcutoff assumes pos values)

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
    PCLog(@"Running");
    while ((inData = [_readHandle availableData]) && inData.length) {
        NSString *str = [[NSString alloc] initWithData: inData 
                                              encoding: NSUTF8StringEncoding];
        [buf appendString:str];
        [str release];
        
        NSArray *lines = [buf componentsSeparatedByString: @"\n"];
        if ([lines count] == 1) {
            //either line is not finished or exactly one line was returned
            //either way, we'll wait until some more can be read
            PCLog(@"Line count : %@", lines);
        } else {
            //init new buffer with the last remnants
            NSMutableString *newBuf = [[NSMutableString alloc] 
                                       initWithString:[lines objectAtIndex: lines.count - 1]];
            PCLog(@"Buffer: %@", buf);
            [buf release];
            buf = newBuf;
        }
        
    }
    
    PCLog(@"Done.");
    [_statusDialogController performSelectorOnMainThread: @selector(resultsReady:) 
                                              withObject: self 
                                           waitUntilDone: NO];
}

-(void) setStatusDialogController:(IMRetrieveSequencesStatusDialogController*) controller {
    //[[controller lastEntryView] setString: 
    _statusDialogController = controller;
    [_statusDialogController.spinner startAnimation:self];
}

-(BOOL) motifsFileExists {
    if (self.motifsFile == nil) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:self.motifsFile];
}
-(BOOL) seqsFileExists {
    if (self.seqsFile == nil) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:self.seqsFile];
}
-(BOOL) bgFileExists {
    if (self.bgFile == nil) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:self.bgFile];
}

-(NSString*) outFilename {
    return [self outputFile];
}

@end