//
//  NMCutoffOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"

@interface NMCutoffOperation : IMTaskOperation {
    NSString *_motifsFile;
    NSString *_seqsFile;
    NSString *_bgFile;
    NSString *_outputFile;
    
    double _significanceThreshold;
    double _binSize;
    double _defaultScoreCutoff;
}

@property (copy, readwrite) NSString *motifsFile;
@property (copy, readwrite) NSString *seqsFile;
@property (copy, readwrite) NSString *bgFile;
@property (copy, readwrite) NSString *outputFile;

@property (readwrite) double significanceThreshold;
@property (readwrite) double binSize;
@property (readwrite) double defaultScoreCutoff;

-(BOOL) motifsFileExists;
-(BOOL) seqsFileExists;
-(BOOL) bgFileExists;

@end