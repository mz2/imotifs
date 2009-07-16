//
//  IMRetrieveSequencesDialogController.h
//  iMotifs
//
//  Created by Matias Piipari on 11/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMRetrieveSequencesOperation;

@interface IMRetrieveSequencesDialogController : NSWindowController {
    IBOutlet NSSearchField *searchField;
    
    NSMutableArray *_foundGeneList;
    //NSMutableArray *_selectedSchemas;
    NSArray *_organismList;
    NSArray *_schemaVersionList;
    //NSString *_organism;
    //NSString *_schemaVersion;
    NSDictionary *_schemaVersionsForOrganisms;

    IBOutlet NSArrayController *foundGeneListController;
    IBOutlet NSArrayController *selectedGeneListController;
    IBOutlet NSArrayController *organismListController;
    IBOutlet NSArrayController *schemaVersionListController;
    
    IBOutlet NSPopUpButton *organismPopup;
    IBOutlet NSPopUpButton *schemaVersionPopup;
    
    NSString *searchString;
    
    BOOL specifyGenesBySearching;
    BOOL specifyGenesFromFile;
    
    IBOutlet IMRetrieveSequencesOperation *retrieveSequencesOperation;
    
}

@property (readwrite, retain) NSSearchField *searchField;
//@property (copy,readwrite) NSString *geneNamePatternString;

@property (copy,readonly) NSString *organism;
@property (copy,readonly) NSString *schemaVersion;
@property (retain,readonly) NSMutableArray *foundGeneList;
@property (retain,readonly) NSArray *organismList;
@property (retain,readonly) NSArray *schemaVersionList;
//@property (retain,readwrite) NSMutableArray *selectedSchemas;
@property (retain,readonly) NSDictionary *schemaVersionsForOrganisms;

@property (retain,readonly) NSArrayController *foundGeneListController;
@property (retain,readonly) NSArrayController *selectedGeneListController;
@property (retain,readonly) NSArrayController *organismListController;
@property (retain,readonly) NSArrayController *schemaVersionListController;

@property (retain,readwrite) NSString *searchString;
@property (retain,readwrite) NSPopUpButton *organismPopup;
@property (retain,readwrite) NSPopUpButton *schemaVersionPopup;

@property (readonly) BOOL enableGeneNameBySearchingCheckbox;
@property (readonly) BOOL enableGeneNameFromInputFileCheckbox;

@property (readwrite) BOOL specifyGenesBySearching;
@property (readwrite) BOOL specifyGenesFromFile;

@property (retain, readwrite) IMRetrieveSequencesOperation *retrieveSequencesOperation;

-(NSString*) activeEnsemblDatabaseName;

-(IBAction) addToSelectedGenes:(id) sender;
-(IBAction) removeFromSelectedGenes:(id) sender;

-(IBAction) cancel:(id) sender;
-(IBAction) submit:(id) sender;

-(IBAction) browseForOutputFile:(id) sender;

@end
