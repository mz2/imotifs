//
//  NMTrainBGModelOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 1/29/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "IMTaskOperation.h"
#import "NMTrainBGModelOperation.h"
#import "IMRetrieveSequencesStatusDialogController.h"
#import "NMOperation.h"

@implementation NMTrainBGModelOperation
@synthesize inputSequencePath = _inputSequencePath;
@synthesize outputBackgroundModelFilePath = _outputBackgroundModelFilePath;
@synthesize classes=_classes;
@synthesize order=_order;
@synthesize statusDialogController = _statusDialogController;

- (id) init
{
    NSString *lp = 
    [[[[NMOperation nmicaPath] 
       stringByAppendingPathComponent:@"bin/nmmakebg"] 
      stringByExpandingTildeInPath] retain];
    
    self = [super initWithLaunchPath: lp];
    
    [NMOperation setupNMICAEnvVars];

    
    if (self != nil) {
        self.classes = 4;
        self.order = 1;
    }
    return self;
}

-(void) dealloc {
    [_inputSequencePath release], _inputSequencePath = nil;
    [_outputBackgroundModelFilePath release], _outputBackgroundModelFilePath = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark IMTaskOperation

-(void) initializeArguments:(NSMutableDictionary*)args {
    [args setObject:[self.inputSequencePath stringBySurroundingWithSingleQuotes] forKey:@"-seqs"];
    [args setObject:[self.outputBackgroundModelFilePath stringBySurroundingWithSingleQuotes] forKey:@"-out"];
    [args setObject:[NSString stringWithFormat:@"%d",self.classes] forKey:@"-classes"];
    [args setObject:[NSString stringWithFormat:@"%d",self.order] forKey:@"-order"];
}

-(void) initializeTask:(NSTask*) t {    
    
    NSPipe *stdOutPipe = [NSPipe pipe];
    _readHandle = [[stdOutPipe fileHandleForReading] retain];
    
    [t setStandardOutput: stdOutPipe];
}

-(void) run {
    [_statusDialogController performSelectorOnMainThread: @selector(start:) 
                                              withObject: self 
                                           waitUntilDone: NO];
    NSData *inData = nil;
    //NSData *errData = nil;
    NSMutableString *buf = [[NSMutableString alloc] init];
    PCLog(@"Running (%@)", _statusDialogController);
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

#pragma mark -
#pragma mark IMOutputFileProducingOperation
-(NSString*) outFilename {
    return [self outputBackgroundModelFilePath];
}

@end
