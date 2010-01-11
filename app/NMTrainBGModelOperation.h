//
//  NMTrainBGModelOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 1/29/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"
#import "IMOutputFileProducingOperation.h"
@class IMRetrieveSequencesStatusDialogController;

@interface NMTrainBGModelOperation : IMTaskOperation <IMOutputFileProducingOperation> {
    NSString *_inputSequencePath;
    NSString *_outputBackgroundModelFilePath;
    NSUInteger _classes;
    NSUInteger _order;
    
    IMRetrieveSequencesStatusDialogController *_statusDialogController;
    @private
    NSFileHandle *_readHandle;
    NSFileHandle *_errorReadHandle;
}

@property (copy,readwrite) NSString *inputSequencePath;
@property (copy,readwrite) NSString *outputBackgroundModelFilePath;

@property (readwrite) NSUInteger classes;
@property (readwrite) NSUInteger order;

@property (assign, readwrite) IMRetrieveSequencesStatusDialogController *statusDialogController;

@end
