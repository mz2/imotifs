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