//
//  NMAlignOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 03/06/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"
@class MotifSetDocument;
@class MotifSet;

typedef enum NMAlignOutputType {
    NMAlignOutputTypeAverage = 0,
    NMAlignOutputTypeMetamotif = 1,
    NMAlignOutputTypeAll = 2
} NMAlignOutputType;

@interface NMAlignOperation : IMTaskOperation {
    NSArray *inputPaths;
    NSString *outputPath;
    NSString *namePrefix;
    
    BOOL addName;
    double maxPrecision;
    double minColWeight;
    NSUInteger minCols;
    
    NMAlignOutputType outputType;
    MotifSetDocument *motifSetDocument;
    //BOOL needsRepeatMasking;
    @protected
    NSMutableString *stdOutOutput;
    NSMutableString *stdErrOutput;
    
    NSString *inputTempPath;
    NSString *outputTempPath;
    
    //NSMutableString *buf;
    NSFileHandle *readHandle;
    NSFileHandle *errorReadHandle;
    
    BOOL receivedOutputData;
    BOOL receivedErrorData;
}

-(id) initWithMotifSet:(MotifSet*) mset;

@property (retain,readwrite) MotifSetDocument *motifSetDocument;
@property (retain,readwrite) NSArray *inputPaths;
@property (copy,readwrite) NSString *outputPath;
@property (copy,readwrite) NSString *namePrefix;

@property (readwrite) BOOL addName;
@property (readwrite) double maxPrecision;
@property (readwrite) double minColWeight;
@property (readwrite) NSUInteger minCols;

@property (readwrite) NMAlignOutputType outputType;

@property (retain, readonly) NSFileHandle *readHandle;
@property (retain, readonly) NSFileHandle *errorReadHandle;
@end
