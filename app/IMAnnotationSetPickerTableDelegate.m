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
