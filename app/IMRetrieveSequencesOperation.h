//
//  IMGeneListRetrievalOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 11/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"
#import "IMOutputFileProducingOperation.h"

@class IMRetrieveSequencesStatusDialogController;

typedef enum IMRetrieveSequencesSearchType {
    IMRetrieveSequencesSearchTypeStableID = 0,
    IMRetrieveSequencesSearchTypeDisplayLabel = 1,
    IMRetrieveSequencesSearchTypePrimaryAccession = 2
} IMRetrieveSequencesSearchType;


@interface IMRetrieveSequencesOperation : IMTaskOperation <IMOutputFileProducingOperation> {
    BOOL isRepeatMasked;
    BOOL excludeTranslations;
    NSInteger featherTranslationsBy;
    NSInteger featherDiscoveryRegionsBy;
    
    BOOL retrieveThreePrimeUTR;
    BOOL retrieveFivePrimeUTR;
    
    NSString *dbUser;
    NSString *dbPassword;
    NSString *dbName;
    NSString *dbSchemaVersion;
    NSUInteger dbPort;
    
    BOOL selectGeneList;
    BOOL selectGeneListFromFile;
    IMRetrieveSequencesSearchType searchType;
    NSMutableArray *selectedGeneList;
    NSString *geneNameListFilename;
    
    NSInteger threePrimeUTRBeginCoord;
    NSInteger threePrimeUTREndCoord;
    
    NSInteger fivePrimeUTRBeginCoord;
    NSInteger fivePrimeUTREndCoord;
    
    NSString *organismName;
    
    NSString *outFilename;
    
    IMRetrieveSequencesStatusDialogController *statusDialogController;
    @private 
    //NSMutableString *buf;
    NSFileHandle *readHandle;
    NSFileHandle *errorReadHandle;
    NSNumberFormatter *numFormatter;
}

@property (readwrite) BOOL isRepeatMasked;
@property (readwrite) BOOL excludeTranslations;
@property (readwrite) NSInteger featherTranslationsBy;
@property (readwrite) NSInteger featherDiscoveryRegionsBy;

@property (readwrite) BOOL retrieveThreePrimeUTR;
@property (readwrite) BOOL retrieveFivePrimeUTR;

@property (readwrite,copy) NSString *dbUser;
@property (readwrite,copy) NSString *dbPassword;
@property (readwrite,copy) NSString *dbName;
@property (readwrite,copy) NSString *dbSchemaVersion;
@property (readwrite) NSUInteger dbPort;

@property (readwrite) BOOL selectGeneList;
@property (readwrite) BOOL selectGeneListFromFile;

@property (retain,readwrite) NSMutableArray *selectedGeneList;
@property (readwrite) IMRetrieveSequencesSearchType searchType;
@property (readwrite,copy) NSString *geneNameListFilename;

@property (readwrite) NSInteger threePrimeUTRBeginCoord;
@property (readwrite) NSInteger threePrimeUTREndCoord;

@property (readwrite) NSInteger fivePrimeUTRBeginCoord;
@property (readwrite) NSInteger fivePrimeUTREndCoord;

@property (readwrite,copy) NSString *organismName;

@property (readwrite,copy) NSString *outFilename;

@property (readonly) BOOL enableChoosingGeneIDListBySearching;
@property (readonly) BOOL enableRetrievingGeneIDListFromFile;

@property (assign, readwrite) IMRetrieveSequencesStatusDialogController *statusDialogController;
@end