//
//  IMRetrievePeakSequencesController.h
//  iMotifs
//
//  Created by Matias Piipari on 18/10/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMRetrieveSequencesDialogController.h"
@class IMRetrievePeakSequencesOperation;


@interface IMRetrievePeakSequencesController : NSWindowController {
    NSArray *_organismList;
    NSArray *_schemaVersionList;
	
    NSDictionary *_schemaVersionsForOrganisms;
	
	IBOutlet NSPopUpButton *organismPopup;
    IBOutlet NSPopUpButton *schemaVersionPopup;
    
	IBOutlet NSArrayController *organismListController;
    IBOutlet NSArrayController *schemaVersionListController;
	
	
	
    IBOutlet IMRetrievePeakSequencesOperation *retrieveSequencesOperation;
    
	
}

@property(nonatomic,retain)NSArray *organismList;
@property(nonatomic,retain)NSArray *schemaVersionList;
@property(nonatomic,retain)NSDictionary *schemaVersionsForOrganisms;
@property(nonatomic,retain)IBOutlet NSPopUpButton *organismPopup;
@property(nonatomic,retain)IBOutlet NSPopUpButton *schemaVersionPopup;
@property(nonatomic,retain)IBOutlet IMRetrievePeakSequencesOperation *retrieveSequencesOperation;

@end
