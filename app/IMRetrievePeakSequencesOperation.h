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
