//
//  NMShuffleOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 03/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NMShuffleOperation.h"
#import "NMOperation.h"
#import "MotifSetDocument.h"
#import "MotifSet.h"

@implementation NMShuffleOperation
@synthesize motifsAFile = _motifsAFile;
@synthesize motifsBFile = _motifsBFile;
@synthesize outputFile = _outputFile;
@synthesize bootstraps = _bootstraps;
@synthesize threshold = _threshold;

-(id) initWithMotifs:(MotifSet*) motifsA 
             against:(MotifSet*) motifsB
          outputFile:(NSString*) outputFile {
    NSString *motifsATempPath = 
        [[NSTemporaryDirectory() stringByAppendingPathComponent:
          [NSString stringWithFormat: @"%d%@", rand(), @".xms"]] retain];
        
    NSString *motifsBTempPath = 
        [[NSTemporaryDirectory() stringByAppendingPathComponent:
          [NSString stringWithFormat: @"%d%@", rand(), @".xms"]] retain];
    
    NSError *errA = nil;
    [[motifsA stringValue] writeToFile:motifsATempPath 
                            atomically:YES 
                              encoding:NSUTF8StringEncoding error:&errA];
    
    if (errA != nil) {
        NSLog(@"Error: %@", [errA localizedDescription]);
        [NSApp presentError:errA];

    }
    
    NSError *errB = nil;
    [[motifsA stringValue] writeToFile:motifsBTempPath 
                            atomically:YES 
                              encoding:NSUTF8StringEncoding error:&errB];
    if (errB != nil) {
        [NSApp presentError:errB];
    }
    
    [self initWithMotifsFromFile: motifsATempPath 
           againstMotifsFromFile: motifsBTempPath 
                      outputFile: outputFile 
               deleteSourceFiles: YES];

    return self;
}

-(id) initWithMotifsFromFile: (NSString*) motifsAPath 
       againstMotifsFromFile: (NSString*) motifsBPath
                  outputFile: (NSString*) outputFile
           deleteSourceFiles: (BOOL) deleteSourceFiles {
    _temporaryFiles = deleteSourceFiles;
      
      NSString *lp = 
      [[[[NMOperation nmicaExtraPath] 
         stringByAppendingPathComponent:@"bin/nmshuffle"] 
        stringByExpandingTildeInPath] retain];
      
      if (self = [super init]) {
          [self setMotifsAFile: motifsAPath];
          [self setMotifsBFile: motifsBPath];
          [self setOutputFile: outputFile];
          if (outputFile == nil) {
              _temporaryOutputFile = YES;
          }
          [self setBootstraps: 10];
          [self setThreshold: 0.10];
          
          self = [super initWithLaunchPath: lp];
          
          if (self == nil) return nil;
          
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
    
    if (self.outputFile == nil) {
        NSString *outputTempFile = 
            [[NSTemporaryDirectory() stringByAppendingPathComponent:
                [NSString stringWithFormat: @"%d%@", rand(), @".xms"]] retain];
        
        self.outputFile = outputTempFile;
    }
    
    [args setObject: self.outputFile forKey:@"-out"];
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
    PCLog(@"Running NMShuffleOperation");
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
    
    if (_temporaryFiles) {
        NSError *errA = nil;
        NSError *errB = nil;
        [[NSFileManager defaultManager] removeItemAtPath:_motifsAFile error:&errA];
        if (errA != nil) {
            PCLog(@"Error occurred when removing temporary file A: %@", [errA description]);
        }
        
        [[NSFileManager defaultManager] removeItemAtPath:_motifsBFile error:&errB];
        
        if (errB != nil) {
            PCLog(@"Error occurred when removing temporary file B: %@", [errB description]);
        }
    }
    
    NSError *err = nil;
    NSDocumentController *sharedDocController = [NSDocumentController sharedDocumentController];
    MotifSetDocument *mdoc = [sharedDocController makeDocumentWithContentsOfURL: [NSURL fileURLWithPath:self.outputFile] 
                                                                         ofType: @"Motif set" 
                                                                          error: &err];
    
    [[NSDocumentController sharedDocumentController] addDocument: mdoc];
    [mdoc makeWindowControllers];
    [mdoc showWindows];
    
    if (_temporaryOutputFile) {
        NSError *err;
        [[NSFileManager defaultManager] removeItemAtPath:self.outputFile error:&err];
        
        if (err != nil) {
            NSLog(@"Error when removing temporary output file %@", self.outputFile);
        }
    }
    
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
