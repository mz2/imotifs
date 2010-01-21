/*
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the
Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
Boston, MA  02110-1301, USA.
*/
//
//  IMRetrieveSequencesDialogController.h
//  iMotifs
//
//  Created by Matias Piipari on 11/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMEnsemblConnection;

@class IMRetrieveSequencesOperation;

@interface IMRetrieveSequencesDialogController : NSWindowController {
    IBOutlet NSSearchField *searchField;
    
    NSArray *_foundGeneList;
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
    
    NSMutableArray *geneStableIDs;
    NSMutableArray *genePrimaryAccs;
    NSMutableArray *geneDisplayLabels;
    NSArray *selectedGeneIDList;
    NSUInteger selectedGeneIDType;
    
    IMEnsemblConnection *ensemblConnection;
}

@property (readwrite, retain) NSSearchField *searchField;
//@property (copy,readwrite) NSString *geneNamePatternString;

@property (copy,readonly) NSString *organism;
@property (copy,readonly) NSString *schemaVersion;
@property (retain,readonly) NSArray *foundGeneList;
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

@property (retain,readwrite) NSArray* selectedGeneIDList;
@property (readwrite) NSUInteger selectedGeneIDType;

@property (retain, readwrite) IMRetrieveSequencesOperation *retrieveSequencesOperation;

-(IBAction) addToSelectedGenes:(id) sender;
-(IBAction) removeFromSelectedGenes:(id) sender;

-(IBAction) cancel:(id) sender;
-(IBAction) submit:(id) sender;

-(IBAction) browseForOutputFile:(id) sender;
-(IBAction) browseForGeneNameFile:(id) sender;
-(IBAction) copyToClipboard: (id) sender;
@end
