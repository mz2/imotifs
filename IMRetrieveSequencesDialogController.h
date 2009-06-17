//
//  IMRetrieveSequencesDialogController.h
//  iMotifs
//
//  Created by Matias Piipari on 11/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum IMRetrieveSequencesSearchType {
    IMRetrieveSequencesSearchTypeStableID = 0,
    IMRetrieveSequencesSearchTypeGeneName = 1
} IMRetrieveSequencesSearchType;

@interface IMRetrieveSequencesDialogController : NSWindowController {
    IBOutlet NSSearchField *searchField;
    
    NSMutableArray *_foundGeneList;
    NSMutableArray *_selectedGeneList;
    NSArray *_organismList;
    NSArray *_schemaVersionList;
    NSString *organism;
    NSDictionary *_schemaVersionsForOrganisms;

    IBOutlet NSArrayController *foundGeneListController;
    IBOutlet NSArrayController *selectedGeneListController;
    IBOutlet NSArrayController *organismListController;
    IBOutlet NSArrayController *schemaVersionListController;
    
    IMRetrieveSequencesSearchType searchType;
    
    BOOL specifyGenesBySearching;
    BOOL specifyGenesFromFile;
    
}

@property (readwrite, retain) NSSearchField *searchField;
//@property (copy,readwrite) NSString *geneNamePatternString;

@property (copy,readwrite) NSString *organism; 
@property (retain,readonly) NSMutableArray *foundGeneList;
@property (retain,readonly) NSMutableArray *selectedGeneList;
@property (retain,readonly) NSArray *organismList;
@property (retain,readonly) NSArray *schemaVersionList;
@property (retain,readonly) NSDictionary *schemaVersionsForOrganisms;

@property (retain,readonly) NSArrayController *foundGeneListController;
@property (retain,readonly) NSArrayController *selectedGeneListController;
@property (retain,readonly) NSArrayController *organismListController;
@property (retain,readonly) NSArrayController *schemaVersionListController;

@property (readonly) BOOL enableGeneNameBySearchingCheckbox;
@property (readonly) BOOL enableGeneNameFromInputFileCheckbox;

@property (readwrite) BOOL specifyGenesBySearching;
@property (readwrite) BOOL specifyGenesFromFile;

@property (readwrite) IMRetrieveSequencesSearchType searchType;

-(IBAction) addToSelectedGenes:(id) sender;
-(IBAction) removeFromSelectedGenes:(id) sender;



@end
