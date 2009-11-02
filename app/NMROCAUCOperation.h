//
//  NMROCAUCOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"
#import "IMOutputFileProducingOperation.h"
@class IMRetrieveSequencesStatusDialogController;

@interface NMROCAUCOperation : IMTaskOperation <IMOutputFileProducingOperation> {

    NSString *_motifsFile;
    NSString *_positiveSeqsFile;
    NSString *_negativeSeqsFile;
    NSString *_outputFile;
    
    NSUInteger _bootstraps;
    
    IMRetrieveSequencesStatusDialogController *_statusDialogController;
    
@protected
    NSFileHandle *_readHandle;
    NSData *_inData;
}

@property (retain, readwrite) NSString *motifsFile;
@property (retain, readwrite) NSString *positiveSeqsFile;
@property (retain, readwrite) NSString *negativeSeqsFile;
@property (retain, readwrite) NSString *outputFile;

@property (readwrite) NSUInteger bootstraps;

@property (retain, readwrite) IBOutlet IMRetrieveSequencesStatusDialogController *statusDialogController;

-(BOOL) motifsFileExists;
-(BOOL) positiveSeqsFileExists;
-(BOOL) negativeSeqsFileExists;

@end