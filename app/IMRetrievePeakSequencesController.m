//
//  IMRetrievePeakSequencesController.m
//  iMotifs
//
//  Created by Matias Piipari on 18/10/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "IMRetrievePeakSequencesController.h"
#import "IMRetrievePeakSequencesOperation.h"
#import <ActiveRecord/ActiveRecord.h>
#import "IMRetrieveSequencesStatusDialogController.h"
#import "AppController.h"
#import "IMEnsemblConnection.h"

@interface IMRetrievePeakSequencesController (private) 
@end


@implementation IMRetrievePeakSequencesController
@synthesize organismList = _organismList;
@synthesize schemaVersionList = _schemaVersionList;
@synthesize schemaVersionsForOrganisms = _schemaVersionsForOrganisms;
@synthesize organismPopup;
@synthesize schemaVersionPopup;
@synthesize retrieveSequencesOperation;

- (void)dealloc
{
    [_organismList release], _organismList = nil;
    [_schemaVersionList release], _schemaVersionList = nil;
    [_schemaVersionsForOrganisms release], _schemaVersionsForOrganisms = nil;
    [organismPopup release], organismPopup = nil;
    [schemaVersionPopup release], schemaVersionPopup = nil;
    [retrieveSequencesOperation release], retrieveSequencesOperation = nil;
	
    [super dealloc];
}
-(void) windowWillLoad {
    //_selectedSchemas = [[NSMutableArray alloc] init];
    ensemblConnection = [[IMEnsemblConnection alloc] init];
}

- (void) awakeFromNib {
        
    [self addObserver:self
           forKeyPath:@"organismListController.selectionIndex"
              options:(NSKeyValueObservingOptionNew)
              context:NULL];
    [self addObserver:self
           forKeyPath:@"schemaVersionListController.selectionIndex"
              options:(NSKeyValueObservingOptionNew)
              context:NULL];
    [self addObserver:self
           forKeyPath:@"retrieveSequencesOperation.selectGeneList"
              options:(NSKeyValueObservingOptionNew)
              context:NULL];
    
    NSString *prevOrganism = [[NSUserDefaults standardUserDefaults] objectForKey:@"IMPreviousEnsemblOrganism"];
    NSString *prevSchemaVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"IMPreviousSchemaVersion"];
    NSLog(@"Previous organism : %@", prevOrganism);
    if (prevOrganism != nil) {
        [organismListController setSelectionIndex:[organismListController.arrangedObjects indexOfObject:prevOrganism]];        
        ensemblConnection.organism = prevOrganism;
    } else {
        if ([organismListController.arrangedObjects count] > 0) {
            [organismListController setSelectionIndex:0];
        }
    }
    
    if (prevSchemaVersion != nil) {
        [schemaVersionListController setSelectionIndex:[schemaVersionListController.arrangedObjects indexOfObject:prevSchemaVersion]];
        ensemblConnection.version = prevSchemaVersion;
    } else {
        if ([schemaVersionListController.arrangedObjects count] > 0) {
            [schemaVersionListController setSelectionIndex:0];
        }
    }
        
}


-(NSString*) organism {
    if (organismListController.selectedObjects.count > 0) {
        return [[organismListController selectedObjects] objectAtIndex: 0];
    }
    
    return nil;
}

-(NSString*) schemaVersion {
    if (schemaVersionListController.selectedObjects.count > 0) {
        return [[schemaVersionListController selectedObjects] objectAtIndex: 0];
    }
    
    return nil;
}

- (void)observeValueForKeyPath: (NSString *)keyPath
                      ofObject: (id)object
                        change: (NSDictionary *)change
                       context: (void *)context {
    //NSLog(@"Selection index changed");
    NSLog(@"Observed value changed (%@) for key %@",change, keyPath);
    if ([keyPath isEqual:@"organismListController.selectionIndex"]) {
        [self willChangeValueForKey:@"schemaVersionList"];
        [_schemaVersionList release];
        _schemaVersionList = nil;
		[self schemaVersionList];
        [self didChangeValueForKey:@"schemaVersionList"];
        
        if ([organismListController selectedObjects].count > 0) {
            NSString *selectedOrganism = [[organismListController selectedObjects] objectAtIndex:0];
            
            //NSLog(@"Saving IMPreviousEnsemblOrganism = %@", selectedOrganism);
            [[NSUserDefaults standardUserDefaults] 
             setObject: selectedOrganism 
             forKey: @"IMPreviousEnsemblOrganism"];
            [[NSUserDefaults standardUserDefaults] synchronize];            
        } else {
            //NSLog(@"No organism chosen");
        }
        
		ensemblConnection.organism = [self organism];
        
		[self.retrieveSequencesOperation setDbName: [ensemblConnection activeEnsemblDatabaseName]];
        
    } 
    else if ([keyPath isEqual:@"schemaVersionListController.selectionIndex"]) {
        if ([schemaVersionListController selectedObjects].count > 0) {
            NSString *selectedSchemaVersion = [[schemaVersionListController selectedObjects] objectAtIndex:0];
            
            //NSLog(@"Saving IMPreviousSchemaVersion = %@", selectedSchemaVersion);
            [[NSUserDefaults standardUserDefaults]
             setObject: selectedSchemaVersion forKey:@"IMPreviousSchemaVersion"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            //NSLog(@"No schema chosen");
        }
        
    }
    else {
        [super observeValueForKeyPath: keyPath 
                             ofObject: object 
                               change: change 
                              context: context];
    }
    
}

-(NSString*) activeEnsemblDatabaseName {
    return [NSString stringWithFormat:@"%@_core_%@",self.organism,self.schemaVersion];
}


-(NSArray*) organismList {
    //NSLog(@"Getting organism list");
    if (_organismList == nil) {
        //NSLog(@"Building organism list");
        _organismList = [[[self.schemaVersionsForOrganisms allKeys] 
                          sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] retain];
        //NSLog(@"Retrieved %d entries", _organismList.count);
    } else {
        //NSLog(@"Retrieving existing organism list");
    }
	
    return _organismList;
}

-(NSArray*) schemaVersionList {
    //NSLog(@"Getting schema version list");
    if (_schemaVersionList == nil) {
        if (self.organism == nil) {
            NSLog(@"Organism is nil. Will return an empty list of schema versions.");
            _schemaVersionList == [[NSArray alloc] init];
        }
        else {
            //NSLog(@"Retrieving schema versions");
            _schemaVersionList = [[[self.schemaVersionsForOrganisms objectForKey:self.organism] 
                                   sortedArrayUsingSelector:@selector(reverseCaseInsensitiveCompare:)] retain];
        }
    } else {
        //NSLog(@"Getting existing schema versions.");
    }
    
    //NSLog(@"%d versions available", _schemaVersionList.count);
    return _schemaVersionList;
}

-(NSDictionary*) schemaVersionsForOrganisms  {
    //NSLog(@"Getting schema versions for all organisms");
    if (_schemaVersionsForOrganisms == nil) {
        //NSLog(@"Retrieving schema versions from database");
        NSMutableDictionary *versions = [[NSMutableDictionary alloc] init];
        
        NSArray *results = [[ARBase defaultConnection] executeSQL:@"SHOW DATABASES;" substitutions:nil];
        for (NSDictionary *dict in results) {
            NSString *dbName = [dict objectForKey: @"Database"];
            NSRange rangeToCore = [dbName rangeOfString: @"_core_"];
            
            if (rangeToCore.location != NSNotFound) {
                NSString *organismName = [dbName substringToIndex: rangeToCore.location];
                NSRange substrRange = NSMakeRange(rangeToCore.location + rangeToCore.length, dbName.length - rangeToCore.location - rangeToCore.length);
                NSString *schemaVersion = [dbName substringWithRange:substrRange];
                if ([versions objectForKey: organismName] == nil) {
                    [versions setObject:[NSMutableArray array] forKey: organismName];
                }
                NSMutableArray *vs = [versions objectForKey: organismName];
                if ([vs indexOfObject: schemaVersion] == NSNotFound) {
                    [vs addObject: schemaVersion];
                }
            }
        }
        
        for (NSString *org in [versions allKeys]) {
            [versions setObject:
			 [[versions objectForKey: org] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] forKey: org];
        } 
        
        _schemaVersionsForOrganisms = [versions retain];
    } else {
        //NSLog(@"Retrieving existing schema versions");
    }
	
    return _schemaVersionsForOrganisms;
}

-(IBAction) cancel:(id) sender {
    DebugLog(@"Cancelling sequence retrieval");
    [self close];
    [self release];
}

-(IBAction) submit:(id) sender {
    NSLog(@"Submitting sequence retrieval task");
    IMRetrieveSequencesStatusDialogController *operationDialogController = 
    [[IMRetrieveSequencesStatusDialogController alloc] initWithWindowNibName:@"IMRetrieveSequencesStatusDialog"];
    [operationDialogController showWindow: self];
    
    [operationDialogController setOperation: self.retrieveSequencesOperation];
    [self.retrieveSequencesOperation setStatusDialogController: operationDialogController];
    
    [[[[NSApplication sharedApplication] delegate] 
      sharedOperationQueue] 
	 addOperation: self.retrieveSequencesOperation];
    [self.retrieveSequencesOperation release];
    [self close];
    [self release];
}

-(IBAction) browseForOutputFile:(id) sender {
    NSString *fileSugg = nil;
    NSString *dirSugg = nil;
    if (retrieveSequencesOperation.outFilename != nil) {
        fileSugg = [[self.retrieveSequencesOperation outFilename] lastPathComponent];
        dirSugg = [[self.retrieveSequencesOperation outFilename] stringByDeletingLastPathComponent];
    }
    
    NSSavePanel *seqFilePanel = [[NSSavePanel savePanel] retain];
    
    [seqFilePanel beginSheetForDirectory: nil
                                    file: nil
                          modalForWindow: self.window 
                           modalDelegate: self 
                          didEndSelector: @selector(browseForOutputFile:returnCode:contextInfo:) 
                             contextInfo: nil];
}

-(void) browseForOutputFile: (NSOpenPanel*) sheet 
                 returnCode: (int) returnCode
                contextInfo: (void*) contextInfo {
    if (returnCode) {
        self.retrieveSequencesOperation.outFilename = sheet.filename;                
    }
    [sheet release];
}

-(IBAction) browseForPeakRegionFile:(id) sender {
    NSString *fileSugg = nil;
    NSString *dirSugg = nil;
    if (retrieveSequencesOperation.peakRegionFilename != nil) {
        fileSugg = [[self.retrieveSequencesOperation peakRegionFilename] lastPathComponent];
        dirSugg = [[self.retrieveSequencesOperation peakRegionFilename] stringByDeletingLastPathComponent];
    }
    
    NSSavePanel *seqFilePanel = [[NSSavePanel savePanel] retain];
    
    [seqFilePanel beginSheetForDirectory: nil
                                    file: nil
                          modalForWindow: self.window 
                           modalDelegate: self 
                          didEndSelector: @selector(browseForOutputFile:returnCode:contextInfo:) 
                             contextInfo: nil];
}

-(void) browseForPeakRegionFile: (NSOpenPanel*) sheet 
                 returnCode: (int) returnCode
                contextInfo: (void*) contextInfo {
    if (returnCode) {
        self.retrieveSequencesOperation.peakRegionFilename = sheet.filename;                
    }
    [sheet release];
}

-(IBAction) copyToClipboard:(id) sender{
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
    [pb declareTypes:types owner:self];
    NSLog(@"Operation: %@ (args:%@)",self.retrieveSequencesOperation, [self.retrieveSequencesOperation argumentsString]);
    [pb setString: [self.retrieveSequencesOperation argumentsString] forType:NSStringPboardType];
}

@end

