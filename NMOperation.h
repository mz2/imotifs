//
//  NMOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"

@class NMOperationStatusDialogController;

@interface NMOperation : IMTaskOperation {
    NSFileHandle *readHandle;
    NSFileHandle *errorReadHandle;
    
    BOOL receivedOutputData;
    BOOL receivedErrorData;
    
    NMOperationStatusDialogController *dialogController;

    NSString *sequenceFilePath;
    NSString *outputMotifSetPath;
    
    NSUInteger numMotifs;
    NSUInteger minMotifLength;
    NSUInteger maxMotifLength;
    double expectedUsageFraction;
    NSUInteger logInterval;
    NSUInteger maxCycles;
    
    NSString *backgroundModelPath;
    NSUInteger backgroundClasses;
    NSUInteger backgroundOrder;
    
    BOOL reverseComplement;
    
    //BOOL needsRepeatMasking;

@private 
    //NSMutableString *buf;
    NSNumberFormatter *numFormatter;
}

@property (retain, readonly) NSFileHandle *readHandle;
@property (retain, readonly) NSFileHandle *errorReadHandle;
@property (nonatomic, retain, readwrite) NMOperationStatusDialogController *dialogController;

@property (copy, readwrite) NSString *sequenceFilePath;
@property (copy, readwrite) NSString *outputMotifSetPath;

@property (readwrite) NSUInteger numMotifs;
@property (readwrite) NSUInteger minMotifLength;
@property (readwrite) NSUInteger maxMotifLength;
@property (readwrite) double expectedUsageFraction;
@property (readwrite) NSUInteger logInterval;
@property (readwrite) NSUInteger maxCycles;

@property (copy,readwrite) NSString *backgroundModelPath;
@property (readwrite) NSUInteger backgroundClasses;
@property (readwrite) NSUInteger backgroundOrder;

@property (readwrite) BOOL reverseComplement;
//@property (readwrite) BOOL needsRepeatMasking;
@end
