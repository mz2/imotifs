//
//  IMRetrieveSequencesDialogController.m
//  iMotifs
//
//  Created by Matias Piipari on 11/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IMRetrieveSequencesDialogController.h"
#import "IMRetrieveSequencesOperation.h"
#import <ActiveRecord/ActiveRecord.h>


@interface IMRetrieveSequencesDialogController (private) 
-(void) setUpMySQLConnection;
-(void) selectLatestSchemaVersion;
-(void) connectToActiveEnsemblDatabase;
@end


@implementation IMRetrieveSequencesDialogController
//@synthesize geneNamePatternString;
@synthesize specifyGenesBySearching, specifyGenesFromFile;

@synthesize searchString;
@synthesize searchField;
@synthesize foundGeneListController;
@synthesize selectedGeneListController;
@synthesize organismListController;
@synthesize schemaVersionListController;

//@synthesize selectedSchemas;

@synthesize organismPopup, schemaVersionPopup;

//@synthesize selectedSchemas = _selectedSchemas;
@synthesize organism; // = _organism;
@synthesize schemaVersion; // = _schemaVersion;

@synthesize foundGeneList = _foundGeneList;
@synthesize retrieveSequencesOperation;

//This is read before 
-(void) windowWillLoad {
    //_selectedSchemas = [[NSMutableArray alloc] init];
    [self setUpMySQLConnection];
}

- (void) awakeFromNib {
    NSLog(@"Awakening IMRetrieveSequencesDialogController from Nib");
    self.specifyGenesBySearching = NO;
    self.specifyGenesFromFile = NO;
    
    //[self setUpMySQLConnection];
    
    
    [self addObserver:self
           forKeyPath:@"organismListController.selectionIndex"
              options:(NSKeyValueObservingOptionNew)
              context:NULL];
    [self addObserver:self
           forKeyPath:@"schemaVersionListController.selectionIndex"
              options:(NSKeyValueObservingOptionNew)
              context:NULL];
    
    
    NSString *prevOrganism = [[NSUserDefaults standardUserDefaults] objectForKey:@"IMPreviousEnsemblOrganism"];
    NSString *prevSchemaVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"IMPreviousSchemaVersion"];
    NSLog(@"Previous organism : %@", prevOrganism);
    if (prevOrganism != nil) {
        [organismListController setSelectionIndex:[organismListController.arrangedObjects indexOfObject:prevOrganism]];        
    } else {
        if ([organismListController.arrangedObjects count] > 0) {
            [organismListController setSelectionIndex:0];
        }
    }
    
    if (prevSchemaVersion != nil) {
        [schemaVersionListController setSelectionIndex:[schemaVersionListController.arrangedObjects indexOfObject:prevSchemaVersion]];
    } else {
        if ([schemaVersionListController.arrangedObjects count] > 0) {
            [schemaVersionListController setSelectionIndex:0];
        }
    }
    
    //if ([self.organismPopup.itemArray indexOfObject: prevOrganism] != NSNotFound) {
        //[self.organismPopup selected
    //}
    
    [self selectLatestSchemaVersion];
}

-(void) selectLatestSchemaVersion {
    /*
    if (schemaVersionPopup.itemArray.count > 1) {
        [schemaVersionPopup selectItemAtIndex: schemaVersionPopup.itemArray.count - 2];
    }
     */
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
    if ([keyPath isEqual:@"organismListController.selectionIndex"]) {
        [self willChangeValueForKey:@"schemaVersionList"];
        [_schemaVersionList release];
        _schemaVersionList = nil;
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
        
        [self connectToActiveEnsemblDatabase];
        
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
        
        [self connectToActiveEnsemblDatabase];
    }
    else {
        [super observeValueForKeyPath: keyPath 
                             ofObject: object 
                               change: change 
                              context: context];
    }
    
}

-(void) connectToActiveEnsemblDatabase {
    [[ARBase defaultConnection] executeSQL: [NSString stringWithFormat:@"USE %@",[self activeEnsemblDatabaseName]] 
                             substitutions: nil];
}
-(NSString*) activeEnsemblDatabaseName {
    return [NSString stringWithFormat:@"%@_core_%@",self.organism,self.schemaVersion];
}

- (void) setUpMySQLConnection {
    NSError *err = nil;
    ARMySQLConnection *connection = 
        [ARMySQLConnection openConnectionWithInfo:[NSDictionary dictionaryWithObjectsAndKeys:
               [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblBaseURL"], @"host",
               [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblUser"], @"user",
               [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblPassword"] , @"password",
               [[NSUserDefaults standardUserDefaults] objectForKey:@"IMEnsemblPort"], @"port", nil]
                                            error:&err];
	if(err != nil) {
        NSLog(@"There was an error connecting to MySQL: %@", [err description]);
        return;        
    } else {
        NSLog(@"Connected to MySQL database at %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblBaseURL"]);
    }
	// See if it works
	[ARBase setDefaultConnection:connection];
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
                
                //[versions setValue: schemaVersion forKey: organismName];
            }
        }
        
        for (NSString *org in [versions allKeys]) {
            [versions setObject:
                [[versions objectForKey: org] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] forKey: org];
        } 
        
        _schemaVersionsForOrganisms = [versions retain];
        
        //NSLog(@"Retrieved schema versions for %d organisms", _schemaVersionsForOrganisms.allKeys.count);
    } else {
        //NSLog(@"Retrieving existing schema versions");
    }
        
    return _schemaVersionsForOrganisms;
}



-(IBAction) addToSelectedGenes:(id) sender {
    
}

-(IBAction) removeFromSelectedGenes:(id) sender {
    
}

-(void) setSpecifyGenesBySearching:(BOOL) b {
    [self willChangeValueForKey:@"enableGeneNameBySearchingCheckbox"];
    [self willChangeValueForKey:@"enableGeneNameFromInputFileCheckbox"];
    specifyGenesBySearching = b;
    [self didChangeValueForKey:@"enableGeneNameBySearchingCheckbox"];
    [self willChangeValueForKey:@"enableGeneNameFromInputFileCheckbox"];
}

-(void) setSpecifyGenesFromInputFileCheckbox:(BOOL) b {
    [self willChangeValueForKey:@"enableGeneNameBySearchingCheckbox"];
    [self willChangeValueForKey:@"enableGeneNameFromInputFileCheckbox"];
    specifyGenesFromFile = b;
    [self didChangeValueForKey:@"enableGeneNameBySearchingCheckbox"];
    [self willChangeValueForKey:@"enableGeneNameFromInputFileCheckbox"];
}

-(BOOL) enableGeneNameBySearchingCheckbox {
    if (self.specifyGenesBySearching) {
        return YES;
    } else if (!self.specifyGenesBySearching &! self.specifyGenesFromFile) {
        return YES;
    }
    
    return NO;
}

-(BOOL) enableGeneNameFromInputFileCheckbox {
    if (self.specifyGenesFromFile) {
        return YES;
    } else if (!self.specifyGenesBySearching &! self.specifyGenesFromFile) {
        return YES;
    }
    
    return NO;
}

-(IBAction) cancel:(id) sender {
    NSLog(@"Closing");
    [self.window close];
}

-(IBAction) submit:(id) sender {
    NSLog(@"Submitting");
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

-(void) dealloc {
    [_foundGeneList release];
    [_organismList release];
    [_schemaVersionList release];
    //[_organism release];
    [_schemaVersionsForOrganisms release];
    
    [super dealloc];
}

@end