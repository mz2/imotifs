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
//  NMScanOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 14/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "NMScanOperation.h"
#import "NMOperation.h"
#import "IMRetrieveSequencesStatusDialogController.h"
#import "IMAnnotationSetDocument.h"
#import "IMSequenceSetDocument.h"

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
      stringByExpandingTildeInPath] retain];
    
    self = [super initWithLaunchPath: lp];
    if (self == nil) return nil;
    
    return self;
}

-(void) initializeArguments:(NSMutableDictionary*) args {
    [args setObject:[self.motifPath stringBySurroundingWithSingleQuotes] forKey:@"-motifs"];        
    [args setObject:[self.seqPath stringBySurroundingWithSingleQuotes] forKey:@"-seqs"];
    [args setObject:[self.outputPath stringBySurroundingWithSingleQuotes] forKey:@"-out"]; //TODO: add -out option to nmscan
    
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
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.outputPath]) {
        NSError *err = nil;
        IMAnnotationSetDocument *doc =
        [[IMAnnotationSetDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.outputPath] 
                                                        ofType:@"GFF annotation set" 
                                                         error:&err];
        if (err != nil) {
            [[NSAlert alertWithError: err] runModal];
        } else {
            [doc makeWindowControllers];
            [doc showWindows];            
        }
        
        NSError *serr = nil;
        IMSequenceSetDocument *sdoc = 
        [[IMSequenceSetDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.seqPath] 
                                                      ofType:@"FASTA sequence set" 
                                                       error:&serr];
        
        if (serr != nil) {
            [[NSAlert alertWithError: serr] runModal];
        } else {
            [sdoc makeWindowControllers];
            [sdoc annotateSequencesWithFeaturesFromAnnotationSetDocument: doc];
            [sdoc showWindows];
            
        }
        
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error occurred with motif scanning" 
                                         defaultButton:@"OK"
                                       alternateButton:nil 
                                           otherButton:nil
                             informativeTextWithFormat:@"Output file has not been generated. Please inspect the commandline generated with 'Copy to Clipboard'."];
        [alert runModal];
    }
    PCLog(@"Done.");
    [_statusDialogController performSelectorOnMainThread: @selector(resultsReady:) 
                                              withObject: self 
                                           waitUntilDone: NO];
}

-(void) openFile:(id) sender {

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

-(BOOL) outputFileIsWriteable {
    return [[NSWorkspace sharedWorkspace] fileAtAPathIsWriteable:self.outputPath];
}

-(void) openFiles:(id) sender {
    
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
