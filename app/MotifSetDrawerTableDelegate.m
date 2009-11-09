//
//  MotifSetDrawerTableDelegate.m
//  iMotifs
//
//  Created by Matias Piipari on 12/4/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "MotifSetDrawerTableDelegate.h"
#import "MotifSetDocument.h"
#import "MotifSetController.h"
#import "Motif.h"

@interface MotifSetDrawerTableDelegate (private)
-(BOOL) singleMotifSelected;
@end

@implementation MotifSetDrawerTableDelegate
@synthesize table, tableLabel;
@synthesize addButton, removeButton, lockToggleButton;

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
    //PCLog(@"controller:%@ selectedObjects:%@",
    //      motifSetDocument.motifSetController,[motifSetDocument.motifSetController selectedObjects]);
    if ([self singleMotifSelected]) {
        //PCLog(@"DrawerDelegate: 1 motif selected");
        return [[[[[motifSetDocument motifSetController] selectedObjects] objectAtIndex:0] annotations] count];
    } else {
        //PCLog(@"DrawerDelegate: more than 1 selected");
        return [[[motifSetDocument motifSet] annotations] count];
    }
}

-(BOOL) singleMotifSelected {
    return [[[motifSetDocument motifSetController] selectedObjects] count] == 1;
}

-(NSArray*) sortedAnnotationKeys {
    NSDictionary *annotations;
    if ([self singleMotifSelected]) {
        annotations =  [[[[motifSetDocument motifSetController] selectedObjects] objectAtIndex:0] annotations];
    } else {
        annotations = [[motifSetDocument motifSet] annotations];
    }
    return [annotations.allKeys sortedArrayUsingSelector:@selector(compare:)];
}

-(NSMutableDictionary*) annotations {
    if ([self singleMotifSelected]) {
        return [[[[motifSetDocument motifSetController] selectedObjects] objectAtIndex:0] annotations];
    } else {
        return [[motifSetDocument motifSet] annotations];
    }
}

- (id)tableView:(NSTableView*)aTableView
objectValueForTableColumn:(NSTableColumn*)aTableColumn
            row:(int)rowIndex {
    NSDictionary *annotations = [self annotations];    
    NSArray *keys = [self sortedAnnotationKeys];
    NSString *key = [keys objectAtIndex: rowIndex];
    if ([[aTableColumn identifier] isEqual:@"key"]) {
        return key;
    } else if ([[aTableColumn identifier] isEqual:@"value"]) {
        return [annotations objectForKey: key]; 
    } else {
        @throw [NSException exceptionWithName: @"" 
                                       reason:
                [NSString stringWithFormat: @"Unexpected table column identifier: %@", 
                 [aTableColumn identifier]] 
                                     userInfo: nil];
    }
}
- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
              row:(NSInteger)rowIndex {
    NSMutableDictionary *annotations = [self annotations];    
    NSArray *keys = [self sortedAnnotationKeys];
    NSString *key = [keys objectAtIndex: rowIndex];
    if ([[aTableColumn identifier] isEqual:@"key"]) {
        id obj = [[annotations objectForKey: key] retain];
        [annotations removeObjectForKey: key];
        [annotations setObject:obj forKey: anObject];
        [obj release];
    } else if ([[aTableColumn identifier] isEqual:@"value"]) {
        [key retain];
        [annotations removeObjectForKey: key];
        [annotations setObject: anObject forKey:key];
        [key release];
    } else {
        @throw [NSException exceptionWithName: @"" 
                                       reason:
                [NSString stringWithFormat: @"Unexpected table column identifier: %@", 
                 [aTableColumn identifier]] 
                                     userInfo: nil];
    }
}

- (void) setMotifSetDocument:(MotifSetDocument*)msetdoc {
	PCLog(@"Setting motif set document");
	[msetdoc retain];
	[motifSetDocument release];
	motifSetDocument = msetdoc;
}

- (MotifSetDocument*) motifSetDocument {
	return motifSetDocument;
}

-(IBAction) refresh: (id) sender {
    [table reloadData];
    [tableLabel setObjectValue:[self tableDescription]];
}

-(NSString*) tableDescription {
    NSUInteger selectionCount = [[[motifSetDocument motifSetController] selectedObjects] count];
    
    if (selectionCount == 0) {
        return @"Motif set annotations";
    } else if (selectionCount == 1) {
        return [NSString stringWithFormat:@"Annotations for %@",
            [[[[motifSetDocument motifSetController] selectedObjects] objectAtIndex:0] name]];
    } else {
        return @"Motif set annotations (multiple selected)";
    }
}

-(IBAction) newAnnotation: (id) sender {
    NSMutableDictionary *annotations = [self annotations];
    if ([annotations objectForKey: @"untitled"] == nil) {
        [annotations setObject:@"" forKey:@"untitled"];
    } else {
        int i = 1;
        while ([annotations 
                objectForKey: [NSString stringWithFormat:@"untitled%d",i]] != nil) {
            i++;
        }
        [annotations setObject:@"" forKey:[NSString stringWithFormat:@"untitled%d",i]];
    }
    
    [self refresh: self];
}
-(IBAction) removeAnnotation: (id) sender {
    NSIndexSet *indices = [table selectedRowIndexes];
    NSUInteger ind = [indices firstIndex];
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity: [indices count]];
    NSMutableArray *sortedKeys = [[self sortedAnnotationKeys] mutableCopy];
    NSMutableDictionary *annotations = [self annotations];
    while (ind != NSNotFound) {
        [keys addObject: [sortedKeys objectAtIndex: ind]];
        ind = [indices indexGreaterThanIndex: ind];
    }
    while ([keys count] > 0) {
        NSString *lastKey = [keys lastObject];
        [annotations removeObjectForKey:lastKey];
        [keys removeLastObject];
    }
    [self refresh: self];
}

- (void)tableViewSelectionDidChange: (NSNotification*)aNotification {
    if ([[table selectedRowIndexes] count] == 0) {
        [removeButton setEnabled: NO];
    } else {
        [removeButton setEnabled: YES];
    }
}

-(BOOL) annotationsEditable {
    return self.motifSetDocument.annotationsEditable;
}

-(void) setAnnotationsEditable:(BOOL) ae {
    [self.motifSetDocument setAnnotationsEditable: ae];
}

- (void) toggleEditable:(id) sender {
    PCLog(@"Toggling annotations editable:%d",[self.motifSetDocument annotationsEditable]);
    //[self.motifSetDocument willChangeValueForKey:
    self.annotationsEditable = !self.annotationsEditable;
    
    if (self.annotationsEditable) {
        self.lockToggleButton.image = [NSImage imageNamed:@"NSLockLockedTemplate"];
    } else {
        self.lockToggleButton.image = [NSImage imageNamed:@"NSLockUnlockedTemplate"];
    }
}
@end
