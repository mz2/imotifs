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

@interface IMSequenceSetDocument : NSDocument <IMotifsDocument> {
    NSString *_name;
    NSArray *_sequences;
    
    IMSequenceView *_sequenceView;
    
    IMSequenceSetController *_sequenceSetController;
    
    NSTextField *_numberOfSequencesLabel;
    
    NSTableView *_sequenceTable;
    NSTableColumn *_nameColumn;
    NSTableColumn *_sequenceColumn;
    
    NSDrawer *_drawer;
    
	NSTextField *_sequenceDetailView;
	
    @protected
    IMSequenceViewCell *_sequenceCell;
}

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) IBOutlet IMSequenceView *sequenceView;
@property(nonatomic,retain) IBOutlet IMSequenceSetController *sequenceSetController;
@property(nonatomic,retain) NSArray *sequences;
@property(nonatomic,retain) IBOutlet NSTextField *numberOfSequencesLabel;
@property(nonatomic,retain) IBOutlet NSTableView *sequenceTable;
@property(nonatomic,retain) IBOutlet NSTableColumn *nameColumn;
@property(nonatomic,retain) IBOutlet NSTableColumn *sequenceColumn;

@property(nonatomic,retain) IBOutlet NSDrawer *drawer;

@property(nonatomic,retain) IBOutlet NSTextField *sequenceDetailView;

-(IBAction) toggleDrawer:(id) sender;

@end
