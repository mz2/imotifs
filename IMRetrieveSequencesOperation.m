//
//  IMGeneListRetrievalOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 11/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IMRetrieveSequencesOperation.h"


@implementation IMRetrieveSequencesOperation
@synthesize isRepeatMasked;
@synthesize excludeTranslations;
@synthesize featherTranslationsBy;
@synthesize featherDiscoveryRegionsBy;
@synthesize retrieveThreePrimeUTR;
@synthesize retrieveFivePrimeUTR;
@synthesize dbUser;
@synthesize dbPassword;
@synthesize dbBaseURL;
@synthesize dbPort;
@synthesize dbSchemaVersion;
@synthesize geneNameListFilename;
@synthesize threePrimeUTRBeginCoord;
@synthesize threePrimeUTREndCoord;
@synthesize fivePrimeUTRBeginCoord;
@synthesize fivePrimeUTREndCoord;
@synthesize organismName;

- (id) init
{
    self = [super init];
    if (self != nil) {
        self.isRepeatMasked = YES;
        self.excludeTranslations = YES;
        self.featherTranslationsBy = 10;
        self.featherDiscoveryRegionsBy = 0;
        self.retrieveThreePrimeUTR = NO;
        self.retrieveFivePrimeUTR = YES;
        
        self.dbUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblUser"];
        
        NSString *pass = [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblPassword"];
        if (pass.length > 0) {
            self.dbPassword = pass;
        }
        self.organismName = @"homo_sapiens";
        self.dbSchemaVersion = nil;
        
    }
    return self;
}

@end
