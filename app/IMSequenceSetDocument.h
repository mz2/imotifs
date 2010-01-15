//
//  IMSequenceSetDocument.h
//  iMotifs
//
//  Created by Matias Piipari on 03/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMotifsDocument.h"

@class IMSequenceSetController;
@class IMSequenceView;
@class BCSequenceArray;
@class IMSequenceViewCell;
@class IMAnnotationSetPickerWindow;
@class IMAnnotationSetPickerTableDelegate;
@class IMAnnotationSetDocument;

@interface IMSequenceSetDocument : NSDocument <IMotifsDocument> {
    NSString *_name;
    NSArray *_sequences;
    
    IMSequenceSetController *_sequenceSetController;
    
    NSTextField *_numberOfSequencesLabel;
    
    NSTableView *_sequenceTable;
    NSTableColumn *_nameColumn;
    NSTableColumn *_sequenceColumn;
    
    NSDrawer *_drawer;
    
	NSTextField *_sequenceDetailView;
    
    IMAnnotationSetPickerWindow *_annotationSetPicker;
    IMAnnotationSetPickerTableDelegate *_annotationSetPickerTableDelegate;

    NSMutableSet *_featureTypes;
    NSMutableDictionary *_colorsByFeatureType;
    
    @protected
    IMSequenceViewCell *_sequenceCell;
}

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) IBOutlet IMSequenceSetController *sequenceSetController;
@property(nonatomic,retain) NSArray *sequences;
@property(nonatomic,retain) IBOutlet NSTextField *numberOfSequencesLabel;
@property(nonatomic,retain) IBOutlet NSTableView *sequenceTable;
@property(nonatomic,retain) IBOutlet NSTableColumn *nameColumn;
@property(nonatomic,retain) IBOutlet NSTableColumn *sequenceColumn;
@property(nonatomic,retain) IBOutlet IMAnnotationSetPickerWindow *annotationSetPicker;
@property(nonatomic,retain) IBOutlet IMAnnotationSetPickerTableDelegate *annotationSetPickerTableDelegate;
@property(nonatomic,retain) IBOutlet NSDrawer *drawer;

@property(nonatomic,readonly) NSString *selectedPositionString;
@property(nonatomic,retain) NSMutableSet *featureTypes;
@property(nonatomic,retain) NSMutableDictionary *colorsByFeatureType;
@property(nonatomic,retain) IBOutlet NSTextField *sequenceDetailView;

-(IBAction) toggleDrawer:(id) sender;
-(IBAction) annotateSequencesWithFeatures: (id)sender;
-(IBAction) closeAnnotationSetPickerSheet: (id) sender;

-(IBAction) increaseWidth: (id) sender;
-(IBAction) decreaseWidth: (id) sender;

-(IBAction) moveFocusPositionLeft: (id) sender;
-(IBAction) moveFocusPositionRight: (id) sender;



+(NSArray*) sequenceSetDocuments;
+(BOOL) atLeastOneSequenceSetDocumentIsOpen;

-(NSMutableDictionary*) colorsForFeatureTypes:(NSSet*) features;

-(void) annotateSequencesWithFeaturesFromAnnotationSetDocument:(IMAnnotationSetDocument*) adoc;
@end
