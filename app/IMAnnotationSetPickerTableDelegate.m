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

#import "IMAnnotationSetPickerTableDelegate.h"
#import "MotifSet.h"
#import "MotifSetDocument.h"
#import "IMAnnotationSetDocument.h"


@implementation IMAnnotationSetPickerTableDelegate

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [[IMAnnotationSetDocument annotationSetDocuments] count];
}

- (id)tableView:(NSTableView*)aTableView objectValueForTableColumn:(NSTableColumn*)aTableColumn
            row:(int)rowIndex {
    IMAnnotationSetDocument *annotationSet = 
        [[IMAnnotationSetDocument annotationSetDocuments] objectAtIndex: rowIndex];
    if ([aTableColumn.identifier isEqual:@"seqcount"]) {
		return [NSString stringWithFormat: @"%d",[[annotationSet annotations] count]];
    } else if ([[aTableColumn identifier] isEqual:@"name"]) {
        return [annotationSet displayName];
    } else {
        @throw [NSException exceptionWithName:@"IMUnexpectedTableColumnIdentifier" 
                                       reason:
                                            [NSString stringWithFormat:
                                             @"Unexpected table column identifier %@",
                                             aTableColumn.identifier] userInfo:nil];
    }
    return nil;
}

-(BOOL)tableView:(NSTableView*) 
shouldEditTableColumn:(NSTableColumn *)tableColumn 
			 row:(int)row {
	return NO;
}

-(void) dealloc {
    [super dealloc];
}
@end
