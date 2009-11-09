//
//  IMRetrievePeakSequencesOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 18/10/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "NMOperation.h"
#import "IMRetrievePeakSequencesOperation.h"
#import "IMRetrieveSequencesStatusDialogController.h"

@implementation IMRetrievePeakSequencesOperation
@synthesize isRepeatMasked = _isRepeatMasked;
@synthesize excludeTranslations = _excludeTranslations;
@synthesize dbUser = _dbUser;
@synthesize dbPassword = _dbPassword;
@synthesize dbName = _dbName;
@synthesize dbSchemaVersion = _dbSchemaVersion;
@synthesize organismName = _organismName;

@synthesize dbPort = _dbPort;
@synthesize dbHost = _dbHost;
@synthesize outFilename = _outFilename;
@synthesize peakRegionFilename = _peakRegionFilename;
@synthesize format = _format;

@synthesize retrieveTopRankedPeaks = _retrieveTopRankedPeaks;
@synthesize retrieveAroundPeakMax = _retrieveAroundPeakMax;
@synthesize statusDialogController = _statusDialogController;

@synthesize maxCount = _maxCount;
@synthesize aroundPeak = _aroundPeak;


// init
- (id)init
{
    NSString *lp = 
    [[[[NMOperation nmicaExtraPath] 
       stringByAppendingPathComponent:@"bin/nmensemblpeakseq"] 
      stringByExpandingTildeInPath] retain];
    
    if (self = [super initWithLaunchPath:lp]) {
        [self setIsRepeatMasked: NO];
        [self setExcludeTranslations: YES];
		
        self.dbUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblUser"];
        NSString *pass = [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblPassword"];
        if (pass.length > 0) {
            self.dbPassword = pass;
        }
        self.dbPort = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IMEnsemblPort"] intValue];
        self.dbHost = [[NSUserDefaults standardUserDefaults] objectForKey:@"IMEnsemblBaseURL"];
        
		self.organismName = @"homo_sapiens";
		self.dbSchemaVersion = nil;
		
		
	    [self setRetrieveTopRankedPeaks: NO];
        [self setRetrieveAroundPeakMax: NO];
    }
    return self;
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [_dbUser release], _dbUser = nil;
    [_dbPassword release], _dbPassword = nil;
    [_dbName release], _dbName = nil;
    [_dbSchemaVersion release], _dbSchemaVersion = nil;
    [_organismName release], _organismName = nil;
    [_dbHost release],_dbHost = nil;
    [_peakRegionFilename release], _peakRegionFilename = nil;
    [_outFilename release], _outFilename = nil;
    _statusDialogController = nil;
	[readHandle release], readHandle = nil;
    [errorReadHandle release], errorReadHandle = nil;
    [numFormatter release], numFormatter = nil;
	
    [super dealloc];
}


-(void) initializeArguments:(NSMutableDictionary*) args {
    [args setObject: [NSNull null] forKey:self.isRepeatMasked ? @"-repeatMask" : @"-noRepeatMask"];
    [args setObject: [NSNull null] forKey:self.excludeTranslations ? @"-excludeTranslations" : @"-excludeTranslations"];
	
	if (self.retrieveTopRankedPeaks && (self.maxCount > 0)) {
		[args setObject:[NSNumber numberWithInt:self.maxCount] forKey:@"-maxCount"];
	}
	
	if (self.retrieveAroundPeakMax && (self.aroundPeak > 0)) {
		[args setObject:[NSNumber numberWithInt:self.aroundPeak] forKey:@"-aroundPeak"];
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
        [args setObject:self.dbUser forKey:@"-user"];
    }
    
    if (self.dbPassword != nil) {
        [args setObject:self.dbPassword forKey:@"-password"];
    }
    

    if (self.peakRegionFilename != nil) {
        [args setObject:self.peakRegionFilename forKey:@"-peaks"];
    }
    
    if (self.outFilename != nil) {
        [args setObject:self.outFilename forKey:@"-out"];
    }
    
    if (self.format == IMPeakFileFormatSWEMBL) {
        [args setObject:@"swembl" forKey:@"-inputFormat"];
    } else if (self.format == IMPeakFileFormatMACS) {
        [args setObject:@"macs" forKey:@"-inputFormat"];
    } else if (self.format == IMPeakFileFormatFindPeaks) {
        [args setObject:@"findpeaks" forKey:@"-inputFormat"];
    }
}

-(BOOL) formatIsDefined {
    return self.format != 0;
}

-(void) setPeakRegionFilename:(NSString *)str {
	[self willChangeValueForKey:@"canSubmitOperation"];
	[_peakRegionFilename release];
	_peakRegionFilename = [str copy];
	
	[self didChangeValueForKey:@"canSubmitOperation"];
}

-(void) setOutFilename:(NSString*) str {
	[self willChangeValueForKey:@"canSubmitOperation"];
	[_outFilename release];
	_outFilename = [str copy];
	
	[self didChangeValueForKey:@"canSubmitOperation"];
}

-(BOOL) canSubmitOperation {
	return (self.peakRegionFilename != nil) && (self.outFilename != nil);
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
    [_statusDialogController performSelectorOnMainThread: @selector(resultsReady:) 
                                              withObject: self 
                                           waitUntilDone: NO];
}

-(void) setStatusDialogController:(IMRetrieveSequencesStatusDialogController*) controller {
    //[[controller lastEntryView] setString: 
    _statusDialogController = controller;
    [_statusDialogController.spinner startAnimation:self];
}
@end
