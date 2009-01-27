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
    NSData *outputData;
    NSData *errorData;
@private 
    NSNumberFormatter *numFormatter;
}

@property (retain, readonly) NSFileHandle *readHandle;
@property (retain, readonly) NSFileHandle *errorReadHandle;
@property (nonatomic, retain, readwrite) NMOperationStatusDialogController *dialogController;

-(id) initMotifDiscoveryTaskWithSequences: (NSString*) seqfpath
                                 outputPath: (NSString*) outputpath;

@end
