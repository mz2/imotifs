/*
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the
Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
Boston, MA  02110-1301, USA.
*/
//
//  NMROCAUCOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <BioCocoa/BCSequenceReader.h>

#import "NMROCAUCOperation.h"
#import "NMOperation.h"
#import "IMRetrieveSequencesStatusDialogController.h"

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
    [_motifsFile release], _motifsFile = nil;
    [_positiveSeqsFile release], _positiveSeqsFile = nil;
    [_negativeSeqsFile release], _negativeSeqsFile = nil;
    [_outputFile release], _outputFile = nil;
    
    [super dealloc];
}


-(void) initializeArguments:(NSMutableDictionary*) args {
    [args setObject:[self.motifsFile stringBySurroundingWithSingleQuotes] forKey:@"-motifs"];        
    [args setObject:[self.positiveSeqsFile stringBySurroundingWithSingleQuotes] forKey:@"-positiveSeqs"];        
    [args setObject:[self.negativeSeqsFile stringBySurroundingWithSingleQuotes] forKey:@"-negativeSeqs"];        
    [args setObject:[self.outputFile stringBySurroundingWithSingleQuotes] forKey:@"-out"];
    
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


-(void) setPositiveSeqsFile:(NSString*) str {
    [self willChangeValueForKey:@"positiveSeqsFile"];
    [_positiveSeqsFile autorelease];
    _positiveSeqsFile = [str copy];
    @try {
        BCSequenceReader *sequenceReader = [[[BCSequenceReader alloc] init] autorelease];
        BCSequenceArray *seqs = [sequenceReader readFileUsingPath: str format: BCFastaFileFormat];
        
        if (seqs == nil) {
            [[NSAlert alertWithError:[NSError errorWithCode:5 description:[NSString stringWithFormat:@"Could not parse FASTA formatted sequence from file", str]]] runModal];
        }
    } @catch (NSException *exception) {
        _positiveSeqsFile = nil;
        [[NSAlert alertWithError:[NSError errorWithCode:5 description:[exception reason]]] runModal];
    } @finally {
        [self didChangeValueForKey:@"positiveSeqsFile"];
    }
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
