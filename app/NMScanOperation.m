//
//  NMScanOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 14/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "NMScanOperation.h"
#import "NMOperation.h"
#import "IMRetrieveSequencesStatusDialogController.h"

@implementation NMScanOperation
@synthesize motifPath = _motifPath;
@synthesize seqPath = _seqPath;
@synthesize outputPath = _outputPath;
@synthesize statusDialogController = _statusDialogController;

// init
- (id)init
{
    NSString *lp = 
    [[[[NMOperation nmicaPath] 
       stringByAppendingPathComponent:@"bin/nmscan"] 
      stringByExpandingTildeInPath] autorelease];
    
    self = [super initWithLaunchPath: lp];
    if (self == nil) return nil;
    
    return self;
}

-(void) initializeArguments:(NSMutableDictionary*) args {
    [args setObject:self.motifPath forKey:@"-motifs"];        
    [args setObject:self.seqPath forKey:@"-seqs"];
    [args setObject:self.outputPath forKey:@"-out"]; //TODO: add -out option to nmscan
    
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

-(BOOL) motifsFileExists {
    if (self.motifPath == nil) return NO;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:self.motifPath];
}

-(BOOL) seqsFileExists {
    if (self.seqPath == nil) return NO;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:self.seqPath];
}

-(NSString*) outFilename {
	return self.outputPath;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [_motifPath release], _motifPath = nil;
    [_seqPath release], _seqPath = nil;
	[_outputPath release], _outputPath = nil;
	[_readHandle release], _readHandle = nil;
    [_inData release],_inData = nil;
    [super dealloc];
}

@end
