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
//  NMCutoffOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"
#import "IMOutputFileProducingOperation.h"
@class IMRetrieveSequencesStatusDialogController;

@interface NMCutoffOperation : IMTaskOperation <IMOutputFileProducingOperation> {
    NSString *_motifsFile;
    NSString *_seqsFile;
    NSString *_bgFile;
    NSString *_outputFile;
    
    double _significanceThreshold;
    double _binSize;
    double _defaultScoreCutoff;
    
    IMRetrieveSequencesStatusDialogController *_statusDialogController;
    
    @protected
    NSFileHandle *_readHandle;
    NSData *_inData;
    
}

@property (copy, readwrite) NSString *motifsFile;
@property (copy, readwrite) NSString *seqsFile;
@property (copy, readwrite) NSString *bgFile;
@property (copy, readwrite) NSString *outputFile;

@property (readwrite) double significanceThreshold;
@property (readwrite) double binSize;
@property (readwrite) double defaultScoreCutoff;

@property (retain, readwrite) IBOutlet IMRetrieveSequencesStatusDialogController *statusDialogController;

-(BOOL) motifsFileExists;
-(BOOL) seqsFileExists;
-(BOOL) bgFileExists;

@end