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
@synthesize selectGeneList,selectedGeneList;
@synthesize searchType;

@synthesize outFilename;

- (id) init
{
    self = [super init];
    if (self != nil) {
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
        
        self.dbUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblUser"];
        
        NSString *pass = [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblPassword"];
        if (pass.length > 0) {
            self.dbPassword = pass;
        }
        self.organismName = @"homo_sapiens";
        self.dbSchemaVersion = nil;
        
        self.outFilename;
    }
    return self;
}

- (void) dealloc {
    [selectedGeneList release];
    
    [super dealloc];
}

-(void) initializetask {
    task = [[NSTask alloc] init];
    
    [arguments setObject: self.isRepeatMasked ? @"true" : @"false" forKey:@"-repeatMask"];
    if (self.excludeTranslations) {
        [arguments setObject: [NSNull null] forKey:@"-excludeTranslations"];
    }
    if (self.excludeTranslations) {
        [arguments setObject: [NSNull null] forKey:@"-featherTranslationsBy"];
    }
    if (self.featherTranslationsBy > 0) {
        [arguments setObject: [NSNumber numberWithInt:self.featherDiscoveryRegionsBy] forKey:@"-featherTranslationsBy"];        
    }
    if (self.featherDiscoveryRegionsBy > 0) {
        [arguments setObject: [NSNumber numberWithInt:self.featherDiscoveryRegionsBy] forKey:@"-featherRegionsBy"];        
    }
    if (self.retrieveThreePrimeUTR) {
        [arguments setObject: [NSString stringWithFormat:@"%d %d",self.threePrimeUTRBeginCoord,self.threePrimeUTREndCoord] 
                      forKey: @"-threePrimeUTR"];
    }
    if (self.retrieveFivePrimeUTR) {
        [arguments setObject: [NSString stringWithFormat:@"%d %d",self.fivePrimeUTRBeginCoord,self.fivePrimeUTREndCoord] 
                      forKey: @"-fivePrimeUTR"];
    }
    
    NSPipe *stdOutPipe = [NSPipe pipe];
    readHandle = [[stdOutPipe fileHandleForReading] retain];
    
    [task setStandardOutput: stdOutPipe];
}

-(void) run {
    NSData *inData = nil;
    NSData *errData = nil;
    NSMutableString *buf = [[NSMutableString alloc] init];
    
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
            [buf release];
            buf = newBuf;
            [self parseNMAlignLogLines: lines];
        }
        
    }
}

-(void) cancel {
    ddfprintf(stderr,@"Canceling alignment task...\n");
    [task terminate];
    ddfprintf(stderr,@"Alignment task terminated\n");
    [super cancel];
}
        
@end
