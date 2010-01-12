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

@implementation IMSequenceSetDocument
@synthesize name = _name;
@synthesize sequences = _sequences;
@synthesize numberOfSequencesLabel = _numberOfSequencesLabel;
@synthesize sequenceView = _sequenceView;
@synthesize sequenceSetController = _sequenceSetController;
@synthesize drawer = _drawer;
@synthesize sequenceTable = _sequenceTable;
@synthesize nameColumn = _nameColumn;
@synthesize sequenceColumn = _sequenceColumn;
@synthesize sequenceDetailView = _sequenceDetailView;
@synthesize annotationSetPicker = _annotationSetPicker;
@synthesize annotationSetPickerTableDelegate = _annotationSetPickerTableDelegate;


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
        
        PCLog(@"Read %d sequences from file %@", self.sequences.count, path);
        return self.sequences != nil ? YES : NO;
    } else {
        ddfprintf(stderr, @"Trying to read an unsupported type : %@\n", type);
        return NO;
    }
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    PCLog(@"Clicked table %@ column %@", tableView , tableColumn);
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
	NSArray *selection = [self.sequenceSetController selectedObjects];
	if (selection.count == 0) return @"Nothing selected";
	
	PCLog(@"Selection: %@", [selection objectAtIndex:0]);
	IMSequence *seq = (IMSequence*)[[self.sequenceSetController selectedObjects] objectAtIndex:0];
	
	if (seq.focusPosition == NSNotFound) return @"No focus position";
	
	return [NSString stringWithFormat:@"Selected position %d",seq.focusPosition];
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

			NSMutableDictionary *dict = [NSMutableDictionary dictionary];
			
			NSUInteger curIndex = [indexes firstIndex];
			PCLog(@"First index: %d", curIndex);
			while (curIndex != NSNotFound) {
				PCLog(@"curIndex: %d", curIndex);
				IMAnnotationSetDocument *adoc 
					= [[IMAnnotationSetDocument annotationSetDocuments] 
					   objectAtIndex:curIndex];
				
				for (IMGFFRecord *a in adoc.annotations) {
					if ([dict objectForKey:a.seqName] == nil) {
						[dict setObject:[NSMutableArray array] forKey: a.seqName];
					}
					[[dict objectForKey:a.seqName] addObject:a];
				}
				
				for (IMSequence *seq in self.sequences) {
					[seq willChangeValueForKey:@"features"];
					NSArray *annotations = [dict objectForKey: seq.name];
					for (IMGFFRecord *a in annotations) {
						PCLog(@"Adding record \n%@\nto %@",a,seq.name);
						[seq.features addObject: [a toFeature]];
						PCLog(@"Features:%@", seq.features);
					}
					[seq didChangeValueForKey:@"features"];
				}
				
                curIndex = [indexes indexGreaterThanIndex: curIndex];
			}
		}
	}
	[self.sequenceTable reloadData];
	[self didChangeValueForKey:@"sequences"];
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

@end