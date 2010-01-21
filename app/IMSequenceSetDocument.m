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
//  IMSequenceSetDocument.m
//  iMotifs
//
//  Created by Matias Piipari on 03/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IMSequenceSetDocument.h"

#import <BioCocoa/BCFoundation.h>

#import "IMSequenceSetController.h"
#import "IMSequenceViewCell.h"
#import "IMSequence.h"
#import "IMAnnotationSetPickerTableDelegate.h"
#import "IMAnnotationSetPickerWindow.h"
#import "IMAnnotationSetDocument.h"
#import "IMGFFRecord.h"
#import "IMFeature.h"
#import "IMRangeFeature.h"
#import "IMPointFeature.h"

@implementation IMSequenceSetDocument
@synthesize name = _name;
@synthesize sequences = _sequences;
@synthesize numberOfSequencesLabel = _numberOfSequencesLabel;
@synthesize sequenceSetController = _sequenceSetController;
@synthesize drawer = _drawer;
@synthesize sequenceTable = _sequenceTable;
@synthesize nameColumn = _nameColumn;
@synthesize sequenceColumn = _sequenceColumn;
@synthesize sequenceDetailView = _sequenceDetailView;
@synthesize annotationSetPicker = _annotationSetPicker;
@synthesize annotationSetPickerTableDelegate = _annotationSetPickerTableDelegate;
@synthesize featureTypes = _featureTypes;
@synthesize colorsByFeatureType = _colorsByFeatureType;


- (NSString *)windowNibName {
    // Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
    return @"IMSequenceSetDocument";
}

- (NSString *)displayName {
    if ([self fileURL] == nil) {
        if (self.name.length > 0) {
            return self.name;
        } else {
            return [super displayName];
        }
    } else {
        return [super displayName];
    }
}

-(void) awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(userDefaultsChanged:)
												 name:NSUserDefaultsDidChangeNotification object:nil];
	
    _sequenceCell = [[[IMSequenceViewCell alloc] 
                      initImageCell:[[_sequenceColumn dataCell] image]] autorelease];
    [_sequenceColumn setDataCell: _sequenceCell];
}

- (NSData *)dataOfType:(NSString *)typeName 
                 error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    return nil;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    PCLog(@"Did click table column %@", tableColumn);
	
    [self willChangeValueForKey:@"selectedPositionString"];
    [self didChangeValueForKey:@"selectedPositionString"];
}

-(BOOL)readFromURL:(NSURL*) url 
            ofType:(NSString*)type 
             error:(NSError**) outError {
    
    PCLog(@"Reading document of type %@ from URL %@", type, url);
    if ([type isEqual:@"FASTA sequence set"]) {

        NSString *path = [url path];
        BCSequenceReader *sequenceReader = [[[BCSequenceReader alloc] init] autorelease];
        BCSequenceArray *sequenceArray = [sequenceReader readFileUsingPath: path 
                                                                    format: BCFastaFileFormat];
        
        NSMutableArray *seqs = [NSMutableArray array];
        
        NSUInteger i;
        for (i=0; i < [sequenceArray count]; i++) {
            BCSequence *s = [sequenceArray sequenceAtIndex: i];
            PCLog(@"Sequence:%@\nannotations:%@",s,[[s annotations] allKeys]);

            IMSequence *seq = 
                [[[IMSequence alloc] initWithSymbolArray: [s symbolArray]] autorelease];
            seq.name =  [[[s annotations] objectForKey: @">"] stringValue];
            [seqs addObject: seq];
        }
        self.name = path;
        
        self.sequences = [[seqs copy] autorelease];
        self.featureTypes = [NSMutableSet set];
        PCLog(@"Read %d sequences from file %@", self.sequences.count, path);
        return self.sequences != nil ? YES : NO;
    } else {
        ddfprintf(stderr, @"Trying to read an unsupported type : %@\n", type);
        return NO;
    }
}


-(IBAction) toggleDrawer:(id) sender {
    [self.drawer toggle: sender];
}

-(BOOL) isMotifSetDocument {
    return NO;
}

-(BOOL) isSequenceSetDocument {
    return YES;
}

-(BOOL) isAnnotationSetDocument {
    return NO;
}

-(NSString*) selectedPositionString {
    /*
    PCLog(@"Creating selected position string");
	NSArray *selection = [self.sequenceSetController selectedObjects];
	if (selection.count == 0) return @"No sequence is selected";
	if (selection.count > 1) return @"Multiple sequences selected";
    else {
        PCLog(@"Selection: %@", [selection objectAtIndex:0]);
        IMSequence *seq = (IMSequence*)[[self.sequenceSetController selectedObjects] objectAtIndex:0];
        
        if (seq.focusPosition == NSNotFound) return @"";
        
        return [NSString stringWithFormat:@"Selected position %d",seq.focusPosition];        
    }*/
    
    NSArray *selection = [self.sequenceSetController selectedObjects];
    if (selection.count == 0) return @"";
    if (selection.count > 1) return [NSString stringWithFormat:@"%d sequences selected", selection.count];
    else {
        IMSequence *seq = (IMSequence*)[selection objectAtIndex:0];
        if (seq.focusPosition == NSNotFound) return [NSString stringWithFormat:@"%@",seq.name];
        else {
            return [NSString stringWithFormat:@"%@ (%@)", [seq selectedFeaturesString]];
        }
    }
}

- (IBAction) annotateSequencesWithFeatures: (id)sender {
	[(NSTableView*)self.annotationSetPicker.tableView reloadData];
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
						  @"annotateSequencesWithFeatures",@"action",nil];
	
	[NSApp beginSheet: self.annotationSetPicker
	   modalForWindow: [NSApp mainWindow]
		modalDelegate: self
	   didEndSelector: @selector(didEndAnnotationSetPickerSheet:returnCode:contextInfo:)
		  contextInfo: dict];
}

-(IBAction) closeAnnotationSetPickerSheet: (id) sender {
	PCLog(@"Close annotation set picker sheet %@ (sender: %@", self.annotationSetPicker, sender);
	
	[self.annotationSetPicker orderOut: self];
	[NSApp endSheet: self.annotationSetPicker 
		 returnCode: ([sender tag] == 1) ? NSOKButton : NSCancelButton];
}

- (void)didEndAnnotationSetPickerSheet: (NSWindow*)sheet 
							returnCode: (int)returnCode 
						   contextInfo: (void*)contextInfo {
	IMAnnotationSetPickerWindow *annotationSheet = (IMAnnotationSetPickerWindow*)sheet;
	NSIndexSet *indexes = [annotationSheet.tableView selectedRowIndexes];
	
	[self willChangeValueForKey:@"sequences"];
	if (returnCode == NSCancelButton) { 
		PCLog(@"Pressed cancel in the sheet");
		return;
	}
	else {
		PCLog(@"Pressed ok in sheet %@", sheet);
		NSDictionary *dict = contextInfo;
		NSString *action = [dict objectForKey:@"action"];
		
		if ([action isEqual: @"annotateSequencesWithFeatures"]) {
			PCLog(@"Annotating sequences with features");
            
			NSUInteger curIndex = [indexes firstIndex];
			PCLog(@"First index: %d", curIndex);
			while (curIndex != NSNotFound) {
				PCLog(@"curIndex: %d", curIndex);
				IMAnnotationSetDocument *adoc 
					= [[IMAnnotationSetDocument annotationSetDocuments] 
					   objectAtIndex:curIndex];
				
                [self annotateSequencesWithFeaturesFromAnnotationSetDocument: adoc];
				
                curIndex = [indexes indexGreaterThanIndex: curIndex];
			}
		}
	}
	[self.sequenceTable setNeedsDisplay];
	[self didChangeValueForKey:@"sequences"];
}

-(void) annotateSequencesWithFeaturesFromAnnotationSetDocument:(IMAnnotationSetDocument*) adoc {
    NSMutableDictionary *featuresBySeqName = [NSMutableDictionary dictionary];
    for (IMGFFRecord *a in adoc.annotations) {
        if ([featuresBySeqName objectForKey:a.seqName] == nil) {
            [featuresBySeqName setObject:[NSMutableArray array] forKey: a.seqName];
        }
        [self.featureTypes addObject: a.feature];
        [[featuresBySeqName objectForKey:a.seqName] addObject:a];
    }
    
    self.colorsByFeatureType = [self colorsForFeatureTypes:self.featureTypes];
    
    for (IMSequence *seq in self.sequences) {
        [seq willChangeValueForKey:@"features"];
        NSArray *annotations = [featuresBySeqName objectForKey: seq.name];
        for (IMGFFRecord *a in annotations) {
            IMFeature *feat = [a toFeature];
            feat.color = [self.colorsByFeatureType objectForKey: feat.type];
            [seq.features addObject: feat];
        }
        [seq didChangeValueForKey:@"features"];
    }    
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSTableView *tv = [aNotification object];
    NSIndexSet *indexSet = [tv selectedRowIndexes];
    
    /* Remove focus from positions from unselected sequences */
    NSUInteger i = 0;
    for (i = 0; i < self.sequences.count; i++) {
        if (![indexSet containsIndex:i]) {
            PCLog(@"Deselecting sequence at index %d", i);
			[[self.sequences objectAtIndex:i] setFocusPosition: NSNotFound];
        } 
    }
    PCLog(@"tableview selection changed");
    [self willChangeValueForKey:@"selectedPositionString"];
    [self didChangeValueForKey:@"selectedPositionString"];
	[self.sequenceTable setNeedsDisplay];
}

-(NSMutableDictionary*) colorsForFeatureTypes:(NSSet*) features {
    NSMutableDictionary *colorsForFTs = [NSMutableDictionary dictionary];
    
    NSMutableArray *orderedFeatureTypes = [[features allObjects] mutableCopy];
    [orderedFeatureTypes sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSArray *colors = [NSColor colorRainbowWithAlternatingHueAtDeviceSaturation:1.0 
                                                                      hueOffset:0.2
                                                                     brightness:0.8
                                                                          alpha:1.0
                                                                      numColors:features.count];
    NSUInteger i=0;
    for (NSString *ft in orderedFeatureTypes) {
        [colorsForFTs setObject: [colors objectAtIndex:i++] 
                         forKey: ft];
    }
    return colorsForFTs;
}

+(NSArray*) sequenceSetDocuments {
    NSMutableArray *a = [NSMutableArray array];
	
	for (NSDocument *doc in [[NSDocumentController sharedDocumentController] documents]) {
		if ([doc isKindOfClass:[IMSequenceSetDocument class]]) {
			[a addObject: a];
		}
	}
    return a;
}

+(BOOL) atLeastOneSequenceSetDocumentIsOpen {
	return [[IMSequenceSetDocument sequenceSetDocuments] count] > 0;
}

-(IBAction) increaseWidth: (id) sender {
    NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
    CGFloat newVal = [def floatForKey: IMSymbolWidthKey] + IMSymbolWidthIncrement;
    if (newVal > 0.0) [def setFloat: newVal forKey: IMSymbolWidthKey];
}

-(IBAction) decreaseWidth: (id) sender {
    NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
    CGFloat newVal = [def floatForKey: IMSymbolWidthKey] - IMSymbolWidthIncrement;
    if (newVal > 0.0) [def setFloat: newVal forKey: IMSymbolWidthKey];
}

-(IBAction) moveFocusPositionLeft: (id) sender {
	if ([self.sequenceSetController selectedObjects].count == 0) {
		//alert user or make the whole action disabled in case this is the case
	}
	for (IMSequence *s in [self.sequenceSetController selectedObjects]) {
		if (s.focusPosition == NSNotFound) {
			[s setFocusPosition: 0];
		} else {
			if (s.focusPosition > 0) {
				[s setFocusPosition: s.focusPosition-1];
			}
		}
	}
	[self.sequenceTable setNeedsDisplay];
}

-(IBAction) moveFocusPositionRight: (id) sender {
	if ([self.sequenceSetController selectedObjects].count == 0) {
		//alert user or make the whole action disabled in case this is the case
	}
	for (IMSequence *s in [self.sequenceSetController selectedObjects]) {
		if (s.focusPosition == NSNotFound) {
			[s setFocusPosition: [[s description] length] - 1];
		} else {
			if (s.focusPosition < ([[s description] length] - 1)) {
				[s setFocusPosition: s.focusPosition+1];
			}
		}
	}
	[self.sequenceTable setNeedsDisplay];
}


-(void) userDefaultsChanged:(NSNotification *)notification {
    _sequenceCell.symbolWidth = [[NSUserDefaults standardUserDefaults] floatForKey:IMSymbolWidthKey];
	[self.sequenceTable setNeedsDisplay];
}

-(void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:NSUserDefaultsDidChangeNotification 
												  object:nil];
	
	[_name release];
	[_sequences release];
	[_featureTypes release];
	[_colorsByFeatureType release];
	
	[super dealloc];
}
@end