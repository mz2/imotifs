//
//  IMGeneListRetrievalOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 11/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IMRetrieveSequencesOperation.h"
#import "IMRetrieveSequencesStatusDialogController.h"
#import "NMOperation.h"


@implementation IMRetrieveSequencesOperation
@synthesize isRepeatMasked;
@synthesize excludeTranslations;
@synthesize featherTranslationsBy;
@synthesize featherDiscoveryRegionsBy;
@synthesize retrieveThreePrimeUTR;
@synthesize retrieveFivePrimeUTR;
@synthesize dbUser;
@synthesize dbHost;
@synthesize dbPassword;
@synthesize dbName;
@synthesize dbPort;
@synthesize dbSchemaVersion;
@synthesize geneNameListFilename;
@synthesize threePrimeUTRBeginCoord;
@synthesize threePrimeUTREndCoord;
@synthesize fivePrimeUTRBeginCoord;
@synthesize fivePrimeUTREndCoord;
@synthesize organismName;
@synthesize selectGeneList,selectGeneListFromFile,selectedGeneList;
@synthesize searchType;
@synthesize outFilename;

@synthesize statusDialogController;

- (id) init
{
    NSString *lp = 
    [[[[NMOperation nmicaExtraPath] 
       stringByAppendingPathComponent:@"bin/nmensemblseq"] 
      stringByExpandingTildeInPath] retain];
 
    self = [super initWithLaunchPath: lp];
    [NMOperation setupNMICAEnvVars];
    
    
    NSLog(@"Set the launch path to %@", self.launchPath);
    if (self == nil) return nil;
    
    self.isRepeatMasked = YES;
    self.excludeTranslations = YES;
    self.featherTranslationsBy = 10;
    self.featherDiscoveryRegionsBy = 0;
    
    self.retrieveThreePrimeUTR = NO;
    self.threePrimeUTRBeginCoord = -200;
    self.threePrimeUTREndCoord = 200;
    
    self.retrieveFivePrimeUTR = YES;
    self.fivePrimeUTRBeginCoord = -200;
    self.fivePrimeUTREndCoord = 200;
    
    self.selectedGeneList = [[NSMutableArray alloc] init];
    
    self.dbUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblUser"];
    NSString *pass = [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblPassword"];
    if (pass.length > 0) {
        self.dbPassword = pass;
    }
    self.dbPort = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IMEnsemblPort"] intValue];
    self.dbHost = [[NSUserDefaults standardUserDefaults] objectForKey:@"IMEnsemblBaseURL"];
    
    self.organismName = @"homo_sapiens";
    self.dbSchemaVersion = nil;
    
    
    return self;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [dbUser release], dbUser = nil;
    [dbPassword release], dbPassword = nil;
    [dbName release], dbName = nil;
    [dbSchemaVersion release], dbSchemaVersion = nil;
    [selectedGeneList release], selectedGeneList = nil;
    [geneNameListFilename release], geneNameListFilename = nil;
    [organismName release], organismName = nil;
    [outFilename release], outFilename = nil;
    statusDialogController = nil; /* weak ref */
    [readHandle release], readHandle = nil;
    [errorReadHandle release], errorReadHandle = nil;
    [numFormatter release], numFormatter = nil;
	
    [super dealloc];
}



-(void) initializeArguments:(NSMutableDictionary*) args {
    [args setObject: self.isRepeatMasked ? @"true" : @"false" forKey:@"-repeatMask"];
    if (self.excludeTranslations) {
        [args setObject: [NSNull null] forKey:@"-excludeTranslations"];
    }
    if (self.excludeTranslations) {
        [args setObject: [NSNull null] forKey:@"-featherTranslationsBy"];
    }
    if (self.featherTranslationsBy > 0) {
        [args setObject: [[NSNumber numberWithInt:self.featherDiscoveryRegionsBy] stringValue] forKey:@"-featherTranslationsBy"];        
    }
    if (self.featherDiscoveryRegionsBy > 0) {
        [args setObject: [[NSNumber numberWithInt:self.featherDiscoveryRegionsBy] stringValue] forKey:@"-featherRegionsBy"];        
    }
    if (self.retrieveThreePrimeUTR) {
        [args setObject: [NSArray arrayWithObjects:
                          [NSString stringWithFormat:@"%d",-self.threePrimeUTRBeginCoord],
                          [NSString stringWithFormat:@"%d",self.threePrimeUTREndCoord], nil] 
                 forKey: @"-threePrimeUTR"];
    }
    if (self.retrieveFivePrimeUTR) {
        [args setObject: [NSArray arrayWithObjects:
                          [NSString stringWithFormat:@"%d",-self.fivePrimeUTRBeginCoord],
                          [NSString stringWithFormat:@"%d",self.fivePrimeUTREndCoord], nil] 
                 forKey: @"-fivePrimeUTR"];
    }
    
    if (self.selectGeneList && self.selectedGeneList.count > 0) {
        [args setObject: self.selectedGeneList forKey: @"-filterByIds"];
    }
    
    if (self.selectGeneListFromFile && self.geneNameListFilename) {
        [args setObject: [self.geneNameListFilename stringBySurroundingWithSingleQuotes] forKey: @"-filterByIdsInFile"];
    }
	
	if (self.searchType == IMRetrieveSequencesSearchTypeStableID) {
		[args setObject: @"stable_id" forKey:@"-idType"];
	} else if (self.searchType == IMRetrieveSequencesSearchTypeDisplayLabel) {
		[args setObject: @"display_label" forKey:@"-idType"];
	}
    
    if (self.dbName == nil) {
        @throw [NSException exceptionWithName:@"IMNullPointerException" reason:@"Database name should not be nil! It needs to be specified." userInfo:nil];
    } else {
        [args setObject:self.dbName forKey:@"-database"];
    }
    
    if (self.dbPort > 0) {
        [args setObject:[NSNumber numberWithInt:self.dbPort] forKey:@"-port"];
    }
    
    if (self.dbHost != nil) {
        [args setObject:self.dbHost forKey:@"-host"];
    }
    
    if (self.dbUser != nil) {
        [args setObject:[self.dbUser stringBySurroundingWithSingleQuotes] forKey:@"-user"];
    }
    
    if (self.dbPassword != nil) {
        [args setObject:self.dbPassword forKey:@"-password"];
    }
        
    if (self.outFilename != nil) {
        [args setObject:[self.outFilename stringBySurroundingWithSingleQuotes] forKey:@"-out"];
    }
    
}
-(void) initializeTask:(NSTask*)t {
    NSPipe *stdOutPipe = [NSPipe pipe];
    readHandle = [[stdOutPipe fileHandleForReading] retain];
    
    [t setStandardOutput: stdOutPipe];
}

-(void) run {
    NSData *inData = nil;
    //NSData *errData = nil;
    NSMutableString *buf = [[NSMutableString alloc] init];
    PCLog(@"Running");
    while ((inData = [readHandle availableData]) && inData.length) {
        NSString *str = [[NSString alloc] initWithData: inData 
                                              encoding: NSUTF8StringEncoding];
        [buf appendString:str];
        [str release];
        
        NSArray *lines = [buf componentsSeparatedByString: @"\n"];
        if ([lines count] == 1) {
            //either line is not finished or exactly one line was returned
            //either way, we'll wait until some more can be read
            PCLog(@"Line count : %@", lines);
        } else {
            //init new buffer with the last remnants
            NSMutableString *newBuf = [[NSMutableString alloc] 
                                       initWithString:[lines objectAtIndex: lines.count - 1]];
            PCLog(@"Buffer: %@", buf);
            [buf release];
            buf = newBuf;
        }
        
    }
    
    PCLog(@"Done.");
    [statusDialogController performSelectorOnMainThread: @selector(resultsReady:) 
                                             withObject: self 
                                          waitUntilDone: NO];
}

-(void) setStatusDialogController:(IMRetrieveSequencesStatusDialogController*) controller {
    //[[controller lastEntryView] setString: 
    statusDialogController = controller;
    [statusDialogController start: self];
}

-(BOOL) enableChoosingGeneIDListBySearching {
    if (!self.selectGeneList &! self.selectGeneListFromFile) {
        return YES;
    } else {
        return !self.selectGeneListFromFile;
    }
}

-(BOOL) enableRetrievingGeneIDListFromFile {
    if (!self.selectGeneList &! self.selectGeneListFromFile) {
        return YES;
    } else {
        return !self.selectGeneList;
    }
}

/*
-(void) setSelectGeneList:(BOOL) b {

    [self willChangeValueForKey:@"selectGeneList"];
    selectGeneList = b;
    [self didChangeValueForKey:@"selectGeneList"];
    
    
	if (selectGeneList) {
		[self willChangeValueForKey:@"selectGeneListFromFile"];
		[self setSelectGeneListFromFile: NO];
		[self didChangeValueForKey:@"selectGeneListFromFile"];	
    }
}

-(void) selectGeneListFromFile:(BOOL) b {
    [self willChangeValueForKey:@"selectGeneListFromFile"];
    selectGeneListFromFile = b;
    [self didChangeValueForKey:@"selectGeneListFromFile"];
    
	if (selectGeneListFromFile) {
		[self willChangeValueForKey:@"selectGeneList"];
        [self setSelectGeneList: NO];
		[self didChangeValueForKey:@"selectGeneList"];
    }
}*/

@end