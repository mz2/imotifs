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
    NMOperationStatusDialogController *dialogController;
    
    NSString *sequenceFilePath;
    NSString *outputMotifSetPath;
    NSString *backgroundModelPath;
    
    BOOL receivedOutputData;
    BOOL receivedErrorData;
    NSUInteger numMotifs;
    NSUInteger minMotifLength;
    NSUInteger maxMotifLength;
    double expectedUsageFraction;
    NSUInteger logInterval;
    NSUInteger maxCycles;
    BOOL reverseComplement;
    
    BOOL backgroundModelFromFile;
    BOOL backgroundModelFromInputSequences;
    
    NSUInteger backgroundClasses;
    NSUInteger backgroundOrder;
    
    //BOOL needsRepeatMasking;

    @private 
    //NSMutableString *buf;
    NSFileHandle *readHandle;
    NSFileHandle *errorReadHandle;
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

@property(nonatomic,assign)BOOL backgroundModelFromFile;
@property(nonatomic,assign)BOOL backgroundModelFromInputSequences;

@property(readonly) BOOL inputSequencesFileExists;
@property(readonly) BOOL backgroundModelFileExists;
@property(readonly) BOOL backgroundModelParametersOrFileExist;

//@property (readwrite) BOOL needsRepeatMasking;

+(NSString*) nmicaPath;
+(NSString*) nmicaExtraPath;
+(void) setupNMICAEnvVars;

-(BOOL) inputSequencesFileExists;
-(BOOL) backgroundModelFileExists;
-(BOOL) backgroundModelParametersOrFileExist;

@end