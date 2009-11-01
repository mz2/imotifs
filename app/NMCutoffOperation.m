//
//  NMCutoffOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NMOperation.h"
#import "NMCutoffOperation.h"


@implementation NMCutoffOperation
@synthesize motifsFile = _motifsFile;
@synthesize seqsFile = _seqsFile;
@synthesize bgFile = _bgFile;
@synthesize outputFile = _outputFile;
@synthesize significanceThreshold = _significanceThreshold;
@synthesize binSize = _binSize;
@synthesize defaultScoreCutoff = _defaultScoreCutoff;

-(id) init {
    NSString *lp = 
    [[[[NMOperation nmicaExtraPath] stringByAppendingPathComponent:@"bin/nmcutoff"] 
      stringByExpandingTildeInPath] retain];
    
    self = [super initWithLaunchPath: lp];
    if (self == nil) return nil;
    
    self.significanceThreshold = 0.05;
    self.binSize = 1.0;
    self.defaultScoreCutoff = -1.0;
    self.launchPath = @"nmcutoff";
    
    return self;
}

-(void) dealloc {
    [_motifsFile release],_motifsFile = nil;
    [_seqsFile release],_seqsFile = nil;
    [_bgFile release],_bgFile = nil;
    [_outputFile release],_outputFile = nil;
    [super dealloc];
}

-(void) initializeTask:(NSTask*) t {
    
    /*
    NSPipe *stdOutPipe = [NSPipe pipe];
    NSPipe *stdErrPipe = [NSPipe pipe];
    readHandle = [[stdOutPipe fileHandleForReading] retain];    
    errorReadHandle = [[stdErrPipe fileHandleForReading] retain];
    [t setStandardOutput: stdOutPipe];
    [t setStandardError: stdErrPipe];*/
}

-(void) initializeArguments:(NSMutableDictionary*) args {
    [args setObject:self.outputFile forKey:@"-motifs"];        
    [args setObject:self.outputFile forKey:@"-seqs"];        
    [args setObject:self.outputFile forKey:@"-backgroundModel"];        
    [args setObject:self.outputFile forKey:@"-out"];
    
    [args setObject:[NSNumber numberWithDouble:_significanceThreshold] forKey:@"-confThreshold"];
    [args setObject:[NSNumber numberWithDouble:_binSize] forKey:@"-binSize"];
    [args setObject:[NSNumber numberWithDouble:_defaultScoreCutoff] forKey:@"-defaultScoreCutoff"];
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

@end