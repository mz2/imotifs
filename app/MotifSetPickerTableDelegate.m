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
//  MotifSetPickerTableDelegate.m
//  iMotifs
//
//  Created by Matias Piipari on 12/3/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "MotifSetPickerTableDelegate.h"
#import "MotifSet.h"
#import "MotifSetDocument.h"

@interface MotifSetPickerTableDelegate (private)
- (NSUInteger) motifSetCount;
@end


@implementation MotifSetPickerTableDelegate
@synthesize otherMotifSets,otherMotifSetDocuments;

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
    return fmax(0,[self motifSetCount] - 1);
}

- (NSUInteger) motifSetCount {
	NSUInteger count = [[NSDocumentController sharedDocumentController] documents].count;
	//PCLog(@"MotifSetPickerTableDelegate: picker motif set count: %d", count);
	return count;
}

- (id)tableView:(NSTableView*)aTableView
objectValueForTableColumn:(NSTableColumn*)aTableColumn
            row:(int)rowIndex {
	NSParameterAssert(rowIndex >= 0 && rowIndex < [self motifSetCount]);
	//NSArray *otherMotifSetDocuments = [[NSMutableArray alloc] 
    MotifSet *motifSet = [otherMotifSets objectAtIndex:rowIndex];
    if ([aTableColumn.identifier isEqual:@"motifcount"]) {
		return [NSString stringWithFormat: @"%d",[motifSet count]];
    } else if ([[aTableColumn identifier] isEqual:@"name"]) {
        if (motifSet.name.length > 0) {
            return motifSet.name;
        } else {
            return [motifSet.motifSetDocument displayName];
        }
    } else {
        @throw [NSException exceptionWithName:@"IMUnexpectedTableColumnIdentifier" 
                                       reason:
                [NSString stringWithFormat:
                 @"Unexpected table column identifier %@",
                 aTableColumn.identifier] userInfo:nil];
    }
}

-(BOOL)tableView:(NSTableView*) 
shouldEditTableColumn:(NSTableColumn *)tableColumn 
			 row:(int)row {
	return NO;
}

- (void) setMotifSetDocument:(MotifSetDocument*)msetdoc {
	PCLog(@"Setting motif set document");
	[msetdoc retain];
	[motifSetDocument release];
	motifSetDocument = msetdoc;
	[otherMotifSetDocuments release];
	otherMotifSetDocuments = [[NSMutableArray alloc] initWithArray: 
							  [[NSDocumentController sharedDocumentController] documents]];
	if (motifSetDocument != nil) [otherMotifSetDocuments removeObject: motifSetDocument];
	[otherMotifSets release];
	otherMotifSets = [[NSMutableArray alloc] init];
	for (NSDocument* msdoc in otherMotifSetDocuments) {
        if ([msdoc isKindOfClass:[MotifSetDocument class]]) {
            [otherMotifSets addObject: [(MotifSetDocument*)msdoc motifSet]];            
        } else {
            
        }
	}
    [otherMotifSets sortUsingSelector:@selector(compare:)];
}

- (MotifSetDocument*) motifSetDocument {
	return motifSetDocument;
}

-(void) dealloc {
    [otherMotifSetDocuments release];
	[otherMotifSets release];
    [super dealloc];
}
@end
