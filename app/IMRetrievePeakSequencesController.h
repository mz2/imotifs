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
	
	@protected
	IMEnsemblConnection *ensemblConnection;
	
}

@property(nonatomic,retain)NSArray *organismList;
@property(nonatomic,retain)NSArray *schemaVersionList;
@property(nonatomic,retain)NSDictionary *schemaVersionsForOrganisms;
@property(nonatomic,retain)IBOutlet NSPopUpButton *organismPopup;
@property(nonatomic,retain)IBOutlet NSPopUpButton *schemaVersionPopup;
@property(nonatomic,retain)IBOutlet IMRetrievePeakSequencesOperation *retrieveSequencesOperation;

-(IBAction) browseForOutputFile:(id) sender;
-(IBAction) browseForPeakRegionFile:(id) sender;
-(IBAction) copyToClipboard: (id) sender;

-(IBAction) cancel:(id) sender;
-(IBAction) submit:(id) sender;

@end
