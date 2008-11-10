//
//  MyDocument.h
//  iMotif
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright Matias Piipari 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <MotifSet.h>
#import <Motif.h>
#import <MotifView.h>
#import <MotifViewCell.h>
#import <MotifSetController.h>
#import <MotifNameCell.h>

typedef enum IMMotifSetSearchType {
    IMMotifSetSearchByName = 0,
    IMMotifSetSearchByConsensusString = 1,
    IMMotifSetSearchByConsensusScoring = 2
} IMMotifSetSearchType;

static NSString *IMMotifSetPboardType = @"net.piipari.motifset.pasteboard";
static NSString *IMMotifSetIndicesPboardType = @"net.piipari.motifset.indices.pasteboard";

@interface MotifSetDocument : NSDocument {
    MotifSet *motifSet;
    IBOutlet MotifView *motifView;
    MotifNameCell *motifNameCell;
    MotifViewCell *motifViewCell;
    
    IBOutlet NSTableView *motifTable;
    IBOutlet NSTableColumn *nameColumn;
    IBOutlet NSTableColumn *motifColumn;
    
    IBOutlet MotifSetController *motifSetController;
    IBOutlet NSSearchField *searchField;
    
    IBOutlet NSMenuItem *searchTypeNameItem;
    IBOutlet NSMenuItem *searchTypeConsensusItem;
    IBOutlet NSMenuItem *searchTypeConsensusScoringItem;
    
    NSTask *task;
    NSPipe *pipe;
    
    NSUInteger searchType;
    
    @private 
    NSArray *pboardMotifs;
    NSArray *pboardMotifsOriginals;
}


-(IBAction) searchMotifs:(id) sender;
-(IBAction) searchTypeToggled:(id) sender;
-(IBAction) selectNone:(id) sender;
-(IBAction) find:(id) sender;
- (IBAction) alignMotifs: (id) sender;

-(BOOL) searchingByName;
-(BOOL) searchingByConsensusMatching;
-(BOOL) searchingByConsensusScoring;

-(IBAction) exportToPDF:(id) sender;

//-(IBAction) openMotifSet:(id)sender;
//-(void) 
@property (retain,readwrite) MotifSet *motifSet;
@property (retain,readwrite) MotifView *motifView;
@property (readonly) MotifViewCell *motifViewCell;
@property (readonly) MotifNameCell *motifNameCell;

@property (retain,readwrite) NSTableView *motifTable;
@property (retain,readwrite) NSTableColumn *nameColumn;
@property (retain,readwrite) NSTableColumn *motifColumn;
@property (retain,readwrite) NSSearchField *searchField;

@property (retain,readwrite) NSMenuItem *searchTypeNameItem;
@property (retain,readwrite) NSMenuItem *searchTypeConsensusItem;
@property (retain,readwrite) NSMenuItem *searchTypeConsensusScoringItem;

@property (readwrite) NSUInteger searchType;

@property (retain,readwrite) MotifSetController *motifSetController;
@end
