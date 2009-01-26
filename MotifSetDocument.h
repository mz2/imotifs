//
//  MyDocument.h
//  iMotif
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright Matias Piipari 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <MotifSetPickerWindow.h>
@class MotifSet;
@class Motif;
@class MotifView;
@class MotifViewCell;
@class MotifSetController;
@class MotifNameCell;
@class MotifSetDocument;
@class MotifSetPickerTableDelegate;
@class MotifComparitor;
@class MotifSetDrawerTableDelegate;
@class MotifNamePickerWindow;
@class MotifNamePickerController;

#ifndef IMMotifSetConsensusScoringSearchMinLength
#define IMMotifSetConsensusScoringSearchMinLength 4
#endif

typedef enum IMMotifSetSearchType {
    IMMotifSetSearchByName = 0,
    IMMotifSetSearchByConsensusString = 1,
    IMMotifSetSearchByConsensusScoring = 2
} IMMotifSetSearchType;

extern NSString *IMMotifSetPboardType;
extern NSString *IMMotifSetIndicesPboardType;

@interface MotifSetDocument : NSDocument {
    MotifSet *motifSet;
    MotifNameCell *motifNameCell;
    MotifViewCell *motifViewCell;

    MotifComparitor *motifComparitor;
    
    IBOutlet MotifView *motifView; //TODO: Remove this.

    IBOutlet NSTableView *motifTable;
    IBOutlet NSTableColumn *nameColumn;
    IBOutlet NSTableColumn *motifColumn;
    
    IBOutlet MotifSetController *motifSetController;
    IBOutlet NSSearchField *searchField;
    
    IBOutlet NSMenuItem *searchTypeNameItem;
    IBOutlet NSMenuItem *searchTypeConsensusItem;
    IBOutlet NSMenuItem *searchTypeConsensusScoringItem;
    
	IBOutlet MotifSetPickerWindow *motifSetPickerSheet;
	IBOutlet MotifSetPickerTableDelegate *motifSetPickerTableDelegate;
	IBOutlet NSButton *motifSetPickerOkButton;
	IBOutlet NSTableView *motifSetPickerTableView;
    
    IBOutlet NSWindow *motifNamePickerSheet;
    IBOutlet NSTextField *motifNamePickerTextField;
    IBOutlet NSTextField *motifNamePickerLabel;
	
    IBOutlet MotifSetDrawerTableDelegate *drawerTableDelegate;
    IBOutlet NSDrawer *drawer;
    
    IBOutlet NSProgressIndicator *progressIndicator;
	//MotifComparitor *motifComparitor;
	
    NSTask *task;
    NSPipe *pipe;
    
    IMMotifSetSearchType searchType;
    
    @private 
    NSArray *pboardMotifs;
    NSArray *pboardMotifsOriginals;
}


-(IBAction) searchMotifs:(id) sender;
-(IBAction) searchTypeToggled:(id) sender;
-(IBAction) selectNone:(id) sender;
-(IBAction) find:(id) sender;

-(IBAction) alignMotifs: (id) sender;
-(IBAction) bestHitsWith: (id) sender;
-(IBAction) bestReciprocalHitsWith: (id) sender;

-(IBAction) closeMotifSetPickerSheet: (id) sender;

- (IBAction) addPrefixToMotifNames: (id) sender;
- (IBAction) addSuffixToMotifNames: (id) sender;
-(IBAction) closeMotifNamePickerSheet: (id) sender;

-(IBAction) toggleDrawer: (id) sender;
//-(IBAction) newAnnotation: (id) sender;
//-(IBAction) removeAnnotation: (id) sender;

-(BOOL) searchingByName;
-(BOOL) searchingByConsensusMatching;
-(BOOL) searchingByConsensusScoring;

-(IBAction) exportToPDF:(id) sender;

//-(IBAction) openMotifSet:(id)sender;
//-(void) 
@property (retain,readwrite) MotifSet *motifSet;
@property (readonly) MotifViewCell *motifViewCell;
@property (readonly) MotifNameCell *motifNameCell;
@property (retain, readonly) MotifComparitor *motifComparitor;

@property (retain,readwrite) MotifView *motifView;

@property (retain,readwrite) NSTableView *motifTable;
@property (retain,readwrite) NSTableColumn *nameColumn;
@property (retain,readwrite) NSTableColumn *motifColumn;
@property (retain,readwrite) NSSearchField *searchField;

@property (retain,readwrite) NSMenuItem *searchTypeNameItem;
@property (retain,readwrite) NSMenuItem *searchTypeConsensusItem;
@property (retain,readwrite) NSMenuItem *searchTypeConsensusScoringItem;

@property (readwrite) IMMotifSetSearchType searchType;
@property (retain,readwrite) MotifSetPickerWindow *motifSetPickerSheet;
@property (retain,readwrite) MotifSetPickerTableDelegate *motifSetPickerTableDelegate;
@property (retain,readwrite) NSTableView *motifSetPickerTableView;
@property (retain,readwrite) MotifSetController *motifSetController;
@property (retain,readwrite) NSButton *motifSetPickerOkButton;

@property (retain,readwrite) NSWindow *motifNamePickerSheet;
@property (retain,readwrite) NSTextField *motifNamePickerTextField;
@property (retain,readwrite) NSTextField *motifNamePickerLabel;

@property (retain,readwrite) MotifSetDrawerTableDelegate *drawerTableDelegate;

@property (retain,readwrite) NSProgressIndicator *progressIndicator;

@property (retain,readwrite) NSDrawer *drawer;
@end