//
//  IMRetrievePeakSequencesOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 18/10/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

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
@synthesize outFilename = _outFilename;
@synthesize peakRegionFilename = _peakRegionFilename;
@synthesize retrieveTopRankedPeaks = _retrieveTopRankedPeaks;
@synthesize retrieveAroundPeakMax = _retrieveAroundPeakMax;
@synthesize statusDialogController = _statusDialogController;

@synthesize maxCount = _maxCount;
@synthesize aroundPeak = _aroundPeak;


// init
- (id)init
{
    if (self = [super init]) {
        [self setIsRepeatMasked: NO];
        [self setExcludeTranslations: YES];
		
		self.dbUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblUser"];
		
		NSString *pass = [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblPassword"];
		if (pass.length > 0) {
			self.dbPassword = pass;
		}
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
		[args setObject:[NSNumber numberWithInt:self.retrieveAroundPeakMax] forKey:@"-aroundPeak"];
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

-(void) initializeTask:(NSTask*)t {
    NSPipe *stdErrPipe = [NSPipe pipe];
    readHandle = [[stdErrPipe fileHandleForReading] retain];
    
    [t setStandardOutput: stdErrPipe];
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

-(void) run {
    NSData *inData = nil;
    //NSData *errData = nil;
    NSMutableString *buf = [[NSMutableString alloc] init];
    DebugLog(@"Running");
    while ((inData = [readHandle availableData]) && inData.length) {
        NSString *str = [[NSString alloc] initWithData: inData 
                                              encoding: NSUTF8StringEncoding];
        [buf appendString:str];
        [str release];
        
        NSArray *lines = [buf componentsSeparatedByString: @"\n"];
        if ([lines count] == 1) {
            //either line is not finished or exactly one line was returned
            //either way, we'll wait until some more can be read
            DebugLog(@"Line count : %@", lines);
        } else {
            //init new buffer with the last remnants
            NSMutableString *newBuf = [[NSMutableString alloc] 
                                       initWithString:[lines objectAtIndex: lines.count - 1]];
            DebugLog(@"Buffer: %@", buf);
            [buf release];
            buf = newBuf;
        }
        
    }
    
    DebugLog(@"Done.");
    [_statusDialogController performSelectorOnMainThread: @selector(resultsReady:) 
                                              withObject: self 
                                           waitUntilDone: NO];
}


@end
