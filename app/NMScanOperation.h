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
-(BOOL) outputFileIsWriteable;

@end
