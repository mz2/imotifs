//
//  NMShuffleOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 03/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NMShuffleOperation.h"
#import "NMOperation.h"

@implementation NMShuffleOperation
@synthesize motifsAFile = _motifsAFile;
@synthesize motifsBFile = _motifsBFile;
@synthesize bootstraps = _bootstraps;
@synthesize threshold = _threshold;

// init
- (id)init
{
    NSString *lp = 
    [[[[NMOperation nmicaExtraPath] 
       stringByAppendingPathComponent:@"bin/nmshuffle"] 
      stringByExpandingTildeInPath] retain];

    if (self = [super init]) {
        [self setMotifsAFile: nil];
        [self setMotifsBFile: nil];
        [self setBootstraps: 10000];
        [self setThreshold: 0.10];
        
        self = [super initWithLaunchPath: lp];
        
        if (self == nil) return nil;
        self.bootstraps = 10000;
        
        return self;
    }
    return self;
}

-(void) initializeArguments:(NSMutableDictionary*) args {
    [args setObject:[NSNull null] forKey:self.motifsAFile];
    [args setObject:[NSNull null] forKey:self.motifsBFile];
    [args setObject:[NSNumber numberWithInt:self.bootstraps] forKey:@"-bootstraps"];
    [args setObject:[NSNumber numberWithDouble:self.threshold] forKey:@"-threshold"];
    
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
    /*
    [_statusDialogController performSelectorOnMainThread: @selector(resultsReady:) 
                                              withObject: self 
                                           waitUntilDone: NO];*/
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [_motifsAFile release], _motifsAFile = nil;
    [_motifsBFile release], _motifsBFile = nil;
    
    [super dealloc];
}
@end
