//
//  NMTrainBGModelOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 1/29/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "IMTaskOperation.h"
#import "NMTrainBGModelOperation.h"


@implementation NMTrainBGModelOperation
@synthesize inputSequencePath = _inputSequencePath;
@synthesize outputBackgroundModelFilePath = _outputBackgroundModelFilePath;
@synthesize classes=_classes;
@synthesize order=_order;
@synthesize statusDialogController = _statusDialogController;

- (id) init
{
    self = [super init];
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
    [args setObject:self.inputSequencePath forKey:@"-seqs"];
    [args setObject:self.outputBackgroundModelFilePath forKey:@"-out"];
    [args setObject:[NSString stringWithFormat:@"%d",self.classes] forKey:@"-classes"];
    [args setObject:[NSString stringWithFormat:@"%d",self.order] forKey:@"-order"];
}

-(void) initializeTask:(NSTask*) t {
    t = [[NSTask alloc] init];
    
    NSPipe *stdOutPipe = [NSPipe pipe];
    _readHandle = [[stdOutPipe fileHandleForReading] retain];
    [t setStandardOutput: stdOutPipe];
}

-(void) run {
    [self.statusDialogController performSelectorOnMainThread: @selector(resultsReady:) 
                                              withObject: self 
                                           waitUntilDone: NO];
}

#pragma mark -
#pragma mark IMOutputFileProducingOperation
-(NSString*) outFilename {
    return [self outputBackgroundModelFilePath];
}

@end
