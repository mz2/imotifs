//
//  NMROCAUCOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NMROCAUCOperation.h"


@implementation NMROCAUCOperation
@synthesize motifsFile = _motifsFile;
@synthesize positiveSeqsFile = _positiveSeqsFile;
@synthesize negativeSeqsFile = _negativeSeqsFile;
@synthesize outputFile = _outputFile;
@synthesize bootstraps = _bootstraps;

-(id) init {
    self = [super init];
    if (self == nil) return nil;
    
    self.bootstraps = 10000;
    
    return self;
}

-(void) dealloc {
    [_motifsFile release],_motifsFile = nil;
    [_positiveSeqsFile release],_positiveSeqsFile = nil;
    [_negativeSeqsFile release],_negativeSeqsFile = nil;
    [_outputFile release],_outputFile = nil;
    
    [super dealloc];
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


@end
