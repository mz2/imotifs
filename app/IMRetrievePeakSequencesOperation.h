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
//  IMRetrievePeakSequencesOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 18/10/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMOutputFileProducingOperation.h"
@class IMRetrieveSequencesStatusDialogController;

typedef enum IMPeakFileFormat {
    IMPeakFileFormatSWEMBL = 1,
    IMPeakFileFormatMACS = 2,
    IMPeakFileFormatFindPeaks = 3,
    IMPeakFileFormatGFF = 4
} IMPeakFileFormat;

@interface IMRetrievePeakSequencesOperation : IMTaskOperation <IMOutputFileProducingOperation> {
	BOOL _isRepeatMasked;
    BOOL _excludeTranslations;
    
	NSString *_dbUser;
    NSString *_dbPassword;
    NSString *_dbName;
    NSString *_dbHost;
    NSString *_dbSchemaVersion;
    NSUInteger _dbPort;
    
	NSString *_organismName;
	NSString *_peakRegionFilename;
	NSString *_outFilename;
    
	BOOL _retrieveTopRankedPeaks;
	BOOL _retrieveAroundPeakMax;
	
	NSInteger _maxCount;
	NSInteger _aroundPeak;
    
    IMPeakFileFormat _format;
	
	IMRetrieveSequencesStatusDialogController *_statusDialogController;
	
	@protected 
	
	//NSMutableString *buf;
    NSFileHandle *readHandle;
    NSFileHandle *errorReadHandle;
    NSNumberFormatter *numFormatter;
}

@property(nonatomic,assign)BOOL isRepeatMasked;
@property(nonatomic,assign)BOOL excludeTranslations;
@property(nonatomic,copy)NSString *dbUser;
@property(nonatomic,copy)NSString *dbPassword;
@property(nonatomic,copy)NSString *dbName;
@property(nonatomic,copy)NSString *dbHost;
@property(nonatomic,copy)NSString *dbSchemaVersion;
@property(nonatomic,copy)NSString *organismName;
@property(nonatomic,assign)NSUInteger dbPort;
@property(nonatomic,copy)NSString *outFilename;
@property(nonatomic,copy)NSString *peakRegionFilename;
@property(nonatomic,assign)BOOL retrieveTopRankedPeaks;
@property(nonatomic,assign)BOOL retrieveAroundPeakMax;
@property(nonatomic,readonly)BOOL canSubmitOperation;

@property(assign) IMPeakFileFormat format;
@property(readonly) BOOL formatIsGFF;

@property(nonatomic,assign)NSInteger maxCount;
@property(nonatomic,assign)NSInteger aroundPeak;

@property(nonatomic,retain) IBOutlet IMRetrieveSequencesStatusDialogController *statusDialogController;

-(BOOL) formatIsDefined;
@end
