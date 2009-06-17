//
//  IMGeneListRetrievalOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 11/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IMRetrieveSequencesOperation : NSObject {
    BOOL isRepeatMasked;
    BOOL excludeTranslations;
    NSInteger featherTranslationsBy;
    NSInteger featherDiscoveryRegionsBy;
    
    BOOL retrieveThreePrimeUTR;
    BOOL retrieveFivePrimeUTR;
    
    NSString *dbUser;
    NSString *dbPassword;
    NSString *dbBaseURL;
    NSString *dbSchemaVersion;
    NSUInteger dbPort;
    
    NSString *geneNameListFilename;
    
    NSInteger threePrimeUTRBeginCoord;
    NSInteger threePrimeUTREndCoord;
    
    NSInteger fivePrimeUTRBeginCoord;
    NSInteger fivePrimeUTREndCoord;
    
    NSString *organismName;
}

@property (readwrite) BOOL isRepeatMasked;
@property (readwrite) BOOL excludeTranslations;
@property (readwrite) NSInteger featherTranslationsBy;
@property (readwrite) NSInteger featherDiscoveryRegionsBy;

@property (readwrite) BOOL retrieveThreePrimeUTR;
@property (readwrite) BOOL retrieveFivePrimeUTR;

@property (readwrite,copy) NSString *dbUser;
@property (readwrite,copy) NSString *dbPassword;
@property (readwrite,copy) NSString *dbBaseURL;
@property (readwrite,copy) NSString *dbSchemaVersion;
@property (readwrite) NSUInteger dbPort;

@property (readwrite,copy) NSString *geneNameListFilename;

@property (readwrite) NSInteger threePrimeUTRBeginCoord;
@property (readwrite) NSInteger threePrimeUTREndCoord;

@property (readwrite) NSInteger fivePrimeUTRBeginCoord;
@property (readwrite) NSInteger fivePrimeUTREndCoord;

@property (readwrite,copy) NSString *organismName;

@end