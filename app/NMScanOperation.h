//
//  NMScanOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 14/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IMTaskOperation.h"
#import "IMOutputFileProducingOperation.h"

@class IMRetrieveSequencesStatusDialogController;

@interface NMScanOperation : IMTaskOperation <IMOutputFileProducingOperation> {
	NSString *_motifPath;
	NSString *_seqPath;
	NSString *_outputPath;
	
	IMRetrieveSequencesStatusDialogController *_statusDialogController;
	
@protected
    NSFileHandle *_readHandle;
    NSData *_inData;
}

@property (retain, readwrite) IBOutlet IMRetrieveSequencesStatusDialogController *statusDialogController;


@property(nonatomic,copy)NSString *motifPath;
@property(nonatomic,copy)NSString *seqPath;
@property(nonatomic,copy)NSString *outputPath;

-(void) openFiles:(id) sender;
-(BOOL) motifsFileExists;
-(BOOL) seqsFileExists;

@end
