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
    self.organismName = @"homo_sapiens";
    self.dbSchemaVersion = nil;
    
    self.outFilename;
    
    return self;
}

- (void) dealloc {
    [selectedGeneList release];
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
        [args setObject: [NSString stringWithFormat:@"%d %d",-self.threePrimeUTRBeginCoord,self.threePrimeUTREndCoord] 
                 forKey: @"-threePrimeUTR"];
    }
    if (self.retrieveFivePrimeUTR) {
        [args setObject: [NSString stringWithFormat:@"%d %d",-self.fivePrimeUTRBeginCoord,self.fivePrimeUTREndCoord] 
                 forKey: @"-fivePrimeUTR"];
    }
    
    if (self.selectedGeneList.count > 0) {
        [args setObject: [self.selectedGeneList componentsJoinedByString:@" "] forKey: @"-filterByIds"];
    }
    
    if (self.geneNameListFilename) {
        [args setObject: self.geneNameListFilename forKey: @"-filterByIdsInFile"];
    }
    
    if (self.dbName == nil) {
        @throw [NSException exceptionWithName:@"IMNullPointerException" reason:@"Database name should not be nil! It needs to be specified." userInfo:nil];
    } else {
        [args setObject:self.dbName forKey:@"-database"];
    }
    
    if (self.outFilename != nil) {
        [args setObject:self.outFilename forKey:@"-out"];
    }
    
}
-(void) initializeTask:(NSTask*)t withArguments:(NSMutableDictionary*) args {
    NSPipe *stdOutPipe = [NSPipe pipe];
    readHandle = [[stdOutPipe fileHandleForReading] retain];
    
    [t setStandardOutput: stdOutPipe];
}

-(void) run {
    NSData *inData = nil;
    //NSData *errData = nil;
    NSMutableString *buf = [[NSMutableString alloc] init];
    NSLog(@"Running");
    while ((inData = [readHandle availableData]) && inData.length) {
        NSString *str = [[NSString alloc] initWithData: inData 
                                              encoding: NSUTF8StringEncoding];
        [buf appendString:str];
        [str release];
        
        NSArray *lines = [buf componentsSeparatedByString: @"\n"];
        if ([lines count] == 1) {
            //either line is not finished or exactly one line was returned
            //either way, we'll wait until some more can be read
        } else {
            //init new buffer with the last remnants
            NSMutableString *newBuf = [[NSMutableString alloc] 
                                       initWithString:[lines objectAtIndex: lines.count - 1]];
            NSLog(@"Buffer: %@", buf);
            [buf release];
            buf = newBuf;
        }
        
    }
    
    NSLog(@"Done");
    
    [statusDialogController performSelectorOnMainThread: @selector(resultsReady:) 
                                             withObject: self 
                                          waitUntilDone: NO];
}

-(void) setStatusDialogController:(IMRetrieveSequencesStatusDialogController*) controller {
    //[[controller lastEntryView] setString: 
}
        
@end
