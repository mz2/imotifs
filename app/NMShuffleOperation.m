//
//  NMShuffleOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 03/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NMShuffleOperation.h"
#import "NMOperation.h"
#import "MotifSet.h"

@implementation NMShuffleOperation
@synthesize motifsAFile = _motifsAFile;
@synthesize motifsBFile = _motifsBFile;
@synthesize bootstraps = _bootstraps;
@synthesize threshold = _threshold;

-(id) initWithMotifs:(MotifSet*) motifsA 
             against:(MotifSet*) motifsB {
    NSString *motifsATempPath = 
        [[NSTemporaryDirectory() stringByAppendingPathComponent:
          [NSString stringWithFormat: @"%d%@", rand(), @".xms"]] retain];
        
    NSString *motifsBTempPath = 
        [[NSTemporaryDirectory() stringByAppendingPathComponent:
          [NSString stringWithFormat: @"%d%@", rand(), @".xms"]] retain];
    
    NSError *errA;
    [[motifsA stringValue] writeToFile:motifsATempPath 
                            atomically:YES 
                              encoding:NSUTF8StringEncoding error:&errA];
    
    if (errA != nil) {
        NSLog(@"Error: %@", errA);
    }
    
    NSError *errB;
    [[motifsA stringValue] writeToFile:motifsBTempPath 
                            atomically:YES 
                              encoding:NSUTF8StringEncoding error:&errB];
    if (errB != nil) {
        NSLog(@"Error: %@", errB);
    }
    
    self = [self initWithMotifsFromFile: motifsATempPath 
                  againstMotifsFromFile: motifsBTempPath 
                      deleteSourceFiles: YES];
    return self;
}

-(id) initWithMotifsFromFile: (NSString*) motifsAPath 
       againstMotifsFromFile: (NSString*) motifsBPath
           deleteSourceFiles: (BOOL) deleteSourceFiles {
    _temporaryFiles = deleteSourceFiles;
      
      NSString *lp = 
      [[[[NMOperation nmicaExtraPath] 
         stringByAppendingPathComponent:@"bin/nmshuffle"] 
        stringByExpandingTildeInPath] retain];
      
      if (self = [super init]) {
          [self setMotifsAFile: motifsAPath];
          [self setMotifsBFile: motifsBPath];
          [self setBootstraps: 10000];
          [self setThreshold: 0.10];
          
          self = [super initWithLaunchPath: lp];
          
          if (self == nil) return nil;
          self.bootstraps = 10000;
          
          return self;
      }
      
      return nil;
}

-(void) initializeArguments:(NSMutableDictionary*) args {
    [args setObject: self.motifsAFile 
             forKey: @"-database"];
    [args setObject: self.motifsBFile 
             forKey: @"-motifs"];
    [args setObject: [NSNumber numberWithInt:self.bootstraps] 
             forKey:@"-bootstraps"];
    [args setObject: [NSNumber numberWithDouble:self.threshold] 
             forKey:@"-threshold"];
    [args setObject: [NSNull null] 
             forKey: @"-outputPairedMotifs"];
    [args setObject: outputFile 
             forKey:@"-out"];
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
    DebugLog(@"Running NMShuffleOperation");
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
    
    if (_temporaryFiles) {
        NSError *errA;
        NSError *errB;
        [[NSFileManager defaultManager] removeItemAtPath:_motifsAFile error:&errA];
        if (errA != nil) {
            DebugLog(@"Error occurred when removing temporary file A: %@");
        }
        
        [[NSFileManager defaultManager] removeItemAtPath:_motifsBFile error:&errB];
        
        if (errB != nil) {
            DebugLog(@"Error occurred when removing temporary file B: %@");
        }
    }
    
    NSError *err;
    NSDocumentController *sharedDocController = [NSDocumentController sharedDocumentController];
    MotifSetDocument *mdoc = [sharedDocController makeDocumentWithContentsOfURL: [NSURL fileURLWithPath:outputTempPath] 
                                                                         ofType: @"Motif set" 
                                                                          error: &err];
    
    [[NSDocumentController sharedDocumentController] addDocument: mdoc];
    [mdoc makeWindowControllers];
    [mdoc showWindows];
    [[NSFileManager defaultManager] removeFileAtPath:outputTempPath handler: nil];
    
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
