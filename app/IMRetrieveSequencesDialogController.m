//
//  IMRetrieveSequencesDialogController.m
//  iMotifs
//
//  Created by Matias Piipari on 11/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IMRetrieveSequencesDialogController.h"
#import "IMRetrieveSequencesOperation.h"
#import "IMRetrieveSequencesStatusDialogController.h"
#import "AppController.h"
#import "IMEnsemblConnection.h"

@interface IMRetrieveSequencesDialogController (private) 

- (void) selectLatestSchemaVersion;
- (void) refreshGeneNameLists;
- (void) refreshFoundGeneNameList;
@end


@implementation IMRetrieveSequencesDialogController
//@synthesize geneNamePatternString;
@synthesize specifyGenesBySearching, specifyGenesFromFile;

//@synthesize searchString;
@synthesize searchField;
@synthesize foundGeneListController;
@synthesize selectedGeneListController;
@synthesize organismListController;
@synthesize schemaVersionListController;
@synthesize selectedGeneIDList,selectedGeneIDType;

//@synthesize selectedSchemas;

@synthesize organismPopup, schemaVersionPopup;

//@synthesize selectedSchemas = _selectedSchemas;
//@synthesize organism; // = _organism;
//@synthesize schemaVersion; // = _schemaVersion;

@synthesize foundGeneList = _foundGeneList;
@synthesize retrieveSequencesOperation;

//This is read before 
-(void) windowWillLoad {
    //_selectedSchemas = [[NSMutableArray alloc] init];
    ensemblConnection = [[IMEnsemblConnection alloc] init];
}

- (void) awakeFromNib {
    //NSLog(@"Awakening IMRetrieveSequencesDialogController from Nib");
    self.specifyGenesBySearching = NO;
    self.specifyGenesFromFile = NO;
        
    
    geneStableIDs = [[NSMutableArray alloc] init];
    geneDisplayLabels = [[NSMutableArray alloc] init];
    genePrimaryAccs = [[NSMutableArray alloc] init];
    
    
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
	
	[self addObserver:self
			forKeyPath:@"retrieveSequencesOperation.selectGeneListFromFile"
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
    
    //if ([self.organismPopup.itemArray indexOfObject: prevOrganism] != NSNotFound) {
        //[self.organismPopup selected
    //}
    
    [self selectLatestSchemaVersion];
    
    if (self.selectedGeneIDList == nil) {
        //this will set the selected gene id list too
        self.selectedGeneIDType = IMRetrieveSequencesSearchTypeDisplayLabel;
    }
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
    BOOL geneNamesNeedUpdating = NO;
    //NSLog(@"Selection index changed");
    NSLog(@"Observed value changed (%@) for key %@",change, keyPath);
    if ([keyPath isEqual:@"organismListController.selectionIndex"]) {
        ensemblConnection.organism = [self organism];

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
        
        self.retrieveSequencesOperation.dbName = [ensemblConnection activeEnsemblDatabaseName];
		//geneNamesNeedUpdating = YES;
		//[self refreshGeneNameLists];
    } 
    else if ([keyPath isEqual:@"schemaVersionListController.selectionIndex"]) {
		ensemblConnection.version = [self schemaVersion];
        
        if ([schemaVersionListController selectedObjects].count > 0) {
            NSString *selectedSchemaVersion = [[schemaVersionListController selectedObjects] objectAtIndex:0];
            
            //NSLog(@"Saving IMPreviousSchemaVersion = %@", selectedSchemaVersion);
            [[NSUserDefaults standardUserDefaults]
             setObject: selectedSchemaVersion forKey:@"IMPreviousSchemaVersion"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            //NSLog(@"No schema chosen");
        }
        
        //[ensemblConnection updateActiveOrganismAndVersion];
		self.retrieveSequencesOperation.dbName = [ensemblConnection activeEnsemblDatabaseName];

        geneNamesNeedUpdating = YES;
        //[self refreshGeneNameLists];
    }
    else if ([keyPath isEqual:@"retrieveSequencesOperation.selectGeneList"]) {
		if (self.retrieveSequencesOperation.selectGeneList) {
			self.retrieveSequencesOperation.selectGeneListFromFile = NO;
		}
        NSLog(@"Changing %i (selectGeneList)", retrieveSequencesOperation.selectGeneList);
    } else if ([keyPath isEqual:@"retrieveSequencesOperation.selectGeneListFromFile"]) {
        NSLog(@"Changing %i (selectGeneListFromFile)", retrieveSequencesOperation.selectGeneListFromFile);
		if (self.retrieveSequencesOperation.selectGeneListFromFile) {
			self.retrieveSequencesOperation.selectGeneList = NO;
		}
    }
    else {
        [super observeValueForKeyPath: keyPath 
                             ofObject: object 
                               change: change 
                              context: context];
    }
    
    if (geneNamesNeedUpdating) {
        [self refreshGeneNameLists];
    }
    
}

- (void) refreshGeneNameLists {
    //NSLog(@"Refreshing gene name list");
    
    [geneStableIDs removeAllObjects];
    [geneDisplayLabels removeAllObjects];
    [genePrimaryAccs removeAllObjects];
    
    NSMutableArray *gids = [NSMutableArray array];
    NSMutableArray *gdls = [NSMutableArray array];
    NSMutableArray *gpaccs = [NSMutableArray array];
    
    //NSLog(@"Purged existing ones");
    NSArray *results = [ensemblConnection stableIDDisplayLabelDBPrimaryAccessionTuples];
    
    for (NSDictionary *res in results) {
        //NSLog(@"%@",res);
        [gids addObject: [res objectForKey:@"stable_id"]];
        [gdls addObject: [res objectForKey:@"display_label"]];
        [gpaccs addObject: [res objectForKey:@"dbprimary_acc"]];
    }
    
    geneStableIDs = [[[gids uniqueObjectsSortedUsingSelector:@selector(compare:)] mutableCopy] retain];
    geneDisplayLabels = [[[gdls uniqueObjectsSortedUsingSelector:@selector(compare:)] mutableCopy] retain];
    genePrimaryAccs = [[[gpaccs uniqueObjectsSortedUsingSelector:@selector(compare:)] mutableCopy] retain];
    
    
    [self setSelectedGeneIDType:self.selectedGeneIDType];
    [self refreshFoundGeneNameList];
	/*
    NSLog(@"stable ids: %i\n\n\ndisplay labels: %i\n\n\nprimary accs: %i",
          [geneStableIDs count],
          [geneDisplayLabels count],
          [genePrimaryAccs count]);*/
}

- (void) refreshFoundGeneNameList {
    //NSLog(@"Refreshing found gene name list");
    NSArray *foundGenes;
    if (self.searchString.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", self.searchString];
        foundGenes = [selectedGeneIDList filteredArrayUsingPredicate: predicate];        
    } else {
        foundGenes = [[selectedGeneIDList copy] autorelease];
    }
    
    [self willChangeValueForKey:@"foundGeneList"];
    _foundGeneList = [[foundGenes uniqueObjectsSortedUsingSelector:@selector(compare:)] retain];
    [self didChangeValueForKey:@"foundGeneList"];
    //NSLog(@"Found genes: %@ (%@)",_foundGeneList,[foundGeneListController arrangedObjects]);
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
			NSLog(@"Organism is set to %@. Will return schema versions.", self.organism);
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
        
        NSArray *results = [ensemblConnection databases];
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

-(void) setSelectedGeneIDType:(NSUInteger) i {

    [self willChangeValueForKey:@"selectedGeneIDType"];
    selectedGeneIDType = i;
    [self didChangeValueForKey:@"selectedGeneIDType"];
    
    self.retrieveSequencesOperation.searchType = selectedGeneIDType;
    
    if (i == IMRetrieveSequencesSearchTypeDisplayLabel) {
        self.selectedGeneIDList = geneDisplayLabels;
    } else if (i == IMRetrieveSequencesSearchTypePrimaryAccession) {
        self.selectedGeneIDList = genePrimaryAccs;
    } else if (i == IMRetrieveSequencesSearchTypeStableID) {
        self.selectedGeneIDList = geneStableIDs;
    }
    
    NSLog(@"Setting selected gene ID type to %i:#%d",i, self.selectedGeneIDList.count);
    
    [self willChangeValueForKey:@"foundGeneList"];
    [self.selectedGeneIDList retain];
    [_foundGeneList release];
    _foundGeneList = self.selectedGeneIDList;
    [self didChangeValueForKey:@"foundGeneList"];
    //NSLog(@"%@\n\n\n%@",self.selectedGeneIDList,[_foundGeneList lastObject]);
}

-(IBAction) addToSelectedGenes:(id) sender {
    [retrieveSequencesOperation.selectedGeneList addObjectsFromArray:[foundGeneListController selectedObjects]];
    NSMutableSet *set = [[NSMutableSet alloc] init];
    [set addObjectsFromArray: retrieveSequencesOperation.selectedGeneList];
    [retrieveSequencesOperation setSelectedGeneList: 
        [[[set allObjects] sortedArrayUsingSelector:@selector(compare:)] mutableCopy]];
    [set release];
}

-(IBAction) removeFromSelectedGenes:(id) sender {
    NSArray *remObjs = [selectedGeneListController selectedObjects];
    [retrieveSequencesOperation willChangeValueForKey:@"selectedGeneList"];
    [retrieveSequencesOperation.selectedGeneList removeObjectsInArray:remObjs];
    [selectedGeneListController setSelectionIndexes: nil];
    [retrieveSequencesOperation didChangeValueForKey:@"selectedGeneList"];
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

-(IBAction) browseForGeneNameFile:(id) sender {
    NSString *fileSugg = nil;
    NSString *dirSugg = nil;
    if (retrieveSequencesOperation.geneNameListFilename != nil) {
        fileSugg = [[self.retrieveSequencesOperation geneNameListFilename] lastPathComponent];
        dirSugg = [[self.retrieveSequencesOperation geneNameListFilename] stringByDeletingLastPathComponent];
    }
    
    NSOpenPanel *seqFilePanel = [[NSOpenPanel openPanel] retain];
    
    [seqFilePanel beginSheetForDirectory: nil
                                    file: nil
                          modalForWindow: self.window 
                           modalDelegate: self 
                          didEndSelector: @selector(browseForGeneNameFile:returnCode:contextInfo:) 
                             contextInfo: nil];
}

-(void) browseForGeneNameFile: (NSOpenPanel*) sheet
                   returnCode: (int) returnCode
                  contextInfo: (void*) contextInfo {
    if (returnCode) {
        self.retrieveSequencesOperation.geneNameListFilename = sheet.filename;                
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

-(NSString*) searchString {
    return searchString;
}

-(void) setSearchString:(NSString*) str {
    NSString *oldVal = searchString;
    searchString = [str copy];
    [oldVal release];
    
    [self refreshFoundGeneNameList];
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