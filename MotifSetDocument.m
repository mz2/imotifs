//
//  MyDocument.m
//  iMotif
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright Matias Piipari 2008 . All rights reserved.
//

#import <MotifSetDocument.h>
#import <Motif.h>
#import <MotifSet.h>
#import <MotifView.h>
#import <MotifSetParser.h>
#import <MotifViewCell.h>
#import <IMDoubleMatrix2D.h>
#import <MotifNameCell.h>
#import <MotifSetPickerTableDelegate.h>
#import <MotifSetDrawerTableDelegate.h>
#import <MotifComparitor.h>
#import <MotifPair.h>
#import "BestHitsOperation.h"
#import "BestReciprocalHitsOperation.h"
#import "MotifsBelowDistanceCutoffOperation.h"
#import "AppController.h"
#import "MotifSetController.h"
#import "NMOperationConfigDialogController.h"


@interface MotifSetDocument (private)
-(void) initializeUI;
@end

@implementation MotifSetDocument
@synthesize motifTable;
@synthesize motifNameCell,motifViewCell;
@synthesize nameColumn,motifColumn;
@synthesize motifComparitor;
@synthesize motifColumn;
@synthesize motifSetController;
@synthesize searchField,searchType;
@synthesize searchTypeNameItem,searchTypeConsensusItem,searchTypeConsensusScoringItem;
@synthesize motifSetPickerSheet, motifSetPickerTableDelegate, motifSetPickerTableView, motifSetPickerOkButton;
@synthesize drawerTableDelegate,drawer;
@synthesize progressIndicator;
@synthesize motifNamePickerSheet, motifNamePickerTextField, motifNamePickerLabel;
@synthesize annotationsEditable;

- (id)init {
    DebugLog(@"MotifSetDocument: initialising MotifSetDocument");
    self = [super init];
    if (self) {
        [self setMotifSet:[[MotifSet alloc] init]];
        [self initializeUI];
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsChanged:)
                                                     name:@"NSUserDefaultsDidChangeNotification" object:nil];
    }
    return self;
}

- (void) initializeUI {
    //[motifTable setRowHeight: IMDefaultColHeight];
    
    NSArray *dragTypes = [NSArray arrayWithObjects:IMMotifSetPboardType,NSFilenamesPboardType,NSStringPboardType,nil];
    [motifTable setDraggingSourceOperationMask:NSDragOperationCopy|NSDragOperationMove|NSDragOperationDelete forLocal:YES];
    [motifTable setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [motifTable registerForDraggedTypes:dragTypes];
    
    motifViewCell = [[[MotifViewCell alloc] 
                      initImageCell:[[motifColumn dataCell] image]] autorelease];
    [motifViewCell setColumnDisplayOffset: [[self motifSet] columnCountWithOffsets]];
    
    /*motifNameCell = [[[MotifNameCell alloc]
                      initTextCell:@""] autorelease];
    [nameColumn setDataCell: motifNameCell];
     */
    
    
    [motifColumn setDataCell: motifViewCell];
    pboardMotifs = nil;
    pboardMotifsOriginals = nil;
    
    [motifSetController rearrangeObjects];
    
    motifComparitor = [[MotifComparitor alloc] initWithExponentRatio:2.0 progressIndicator: progressIndicator];
    
    motifHeight = [[self motifTable] rowHeight];
    //[progressIndicator setUsesThreadedAnimation: YES];
}

-(void) userDefaultsChanged:(NSNotification *)notification {
    //DebugLog(@"User defaults changed: %@", notification);
    NSNumber* defHeight = [[NSUserDefaults standardUserDefaults] objectForKey:IMMotifHeight];
    NSNumber *defConfInterval = [[NSUserDefaults standardUserDefaults] objectForKey:IMMetamotifDefaultConfidenceIntervalCutoffKey];
    NSNumber *defDrawingStyle = [[NSUserDefaults standardUserDefaults] objectForKey:IMMotifDrawingStyle];
    NSNumber *defErrorBarStyle = [[NSUserDefaults standardUserDefaults] objectForKey:IMMotifColumnPrecisionDrawingStyleKey];
    
    CGFloat newHeight = [defHeight floatValue];
    if (newHeight != motifHeight) {
        motifHeight = newHeight;
        [self.motifTable setRowHeight: newHeight];
        [self.motifTable setNeedsDisplay: YES];
    }
    
    CGFloat newConfInterval = [defConfInterval floatValue];
    if (newConfInterval != motifViewCell.confidenceIntervalCutoff) {
        motifViewCell.confidenceIntervalCutoff = newConfInterval;
        [self.motifTable reloadData];
    }
    
    if (motifViewCell.drawingStyle != [defDrawingStyle intValue]) {
        motifViewCell.drawingStyle = [defDrawingStyle intValue];
        [self.motifTable reloadData];
    }
    
    if (motifViewCell.columnPrecisionDrawingStyle != [defErrorBarStyle intValue]) {
        motifViewCell.columnPrecisionDrawingStyle = [defErrorBarStyle intValue];
        NSLog(@"Column precision drawing style set: %d", motifViewCell.columnPrecisionDrawingStyle);
        [self.motifTable reloadData];
    }
}

- (void) awakeFromNib {
    DebugLog(@"MotifSetDocument: awakening from Nib (motifset=%@)",[[self motifSet] name]);
    //DebugLog(@"Arranged objects:%@",[motifSetController arrangedObjects]);
    [self initializeUI];
}



- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MotifSetDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    DebugLog(@"MotifSetDocument: window controller loaded the %@ Nib file",[self windowNibName]);
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    DebugLog(@"Window controller: %@ %@", aController, motifSet);
    if ([self fileName]) {
        [aController setWindowFrameAutosaveName:[self fileName]];
    }
    //[self setShouldCascadeWindows: NO];
    //[self setWindowFrameAutosaveName: @"pannerWindow"];
        
        // and any other windowDidLoad work to be done
    //} // windowDidLoad
    
}

- (NSString *)displayName {
    if ([self fileURL] == nil) {
        if (self.motifSet.name != nil) {
            return self.motifSet.name;
        } else {
            return [super displayName];
        }
    } else {
        return [super displayName];
    }
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    if (![typeName isEqual:@"Motif set"]) {
        return nil;
    }
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain 
                                        code:unimpErr 
                                    userInfo:NULL];
	}
    
    NSMutableDictionary *annots = [[self motifSet] annotations];
    if ([annots objectForKey:@"imotifs-window-width"]) {
        
    }
    if ([annots objectForKey:@"imotifs-window-height"]) {
        
    }
    
    
    NSXMLDocument *xmsDoc = [[[self motifSet] toXMS] retain];
    return [[xmsDoc description] dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)readFromData: (NSData *)data 
              ofType: (NSString *)typeName 
               error: (NSError **)outError {
    if ([typeName isEqual:@"Motif set"]) {
        [self setMotifSet:[MotifSetParser motifSetFromData: data]];
        //if (motifSet.name == nil) {
        //    [motifSet setName: [self displayName]];            
        //}
        
        return motifSet != nil ? YES : NO;
    } else {
        ddfprintf(stderr, @"Trying to read an unsupported type : %@", typeName);
        return NO;
    }
}

//TODO: You might be using some of the deprecated methods from NSDocument, check through that you're not

-(BOOL)readFromURL:(NSURL*) url 
            ofType:(NSString*)type 
             error:(NSError*) outError {
    if ([type isEqual:@"Motif set"]) {
        [self setMotifSet:[MotifSetParser motifSetFromURL:url]];
        
        if (![[motifSet annotations] objectForKey:@"imotifs-window-autosave-id"]) {
            [[motifSet annotations] setObject: [NSString stringWithFormat:@"%d",rand()] 
                                       forKey: @"imotifs-window-autosave-id"];
        }
        //[motifSet setName: [self displayName]];
        return motifSet != nil ? YES : NO;
    } else {
        ddfprintf(stderr, @"Trying to read an unsupported type : %@\n", type);
        return NO;
    }
}

#pragma mark Accessors
- (void) setMotifView:(MotifView*) mView {
    [mView retain];
    [motifView release];
    motifView = mView;
    [motifView setMotif: [motifSet motifWithIndex:0]];
    [motifView setNeedsDisplay: YES];
    DebugLog(@"MotifSetDocument: setting motif view to %@", mView);
}

- (void) setMotifTable:(NSTableView*) mTable {
    [mTable retain];
    [motifTable release];
    motifTable = mTable;
    //DebugLog(@"MotifSetDocument: set motif table to %@", mTable);
    //MotifViewCell *cell = [[[MotifViewCell class] alloc] initImageCell:[[motifColumn dataCell] image]];
    //[cell setRepresentedObject:motif];
    //[motifColumn setDataCell:cell];
    //[cell release];
}

- (MotifView*) motifView {
    return motifView;
}

- (void) setMotifSet:(MotifSet*) ms {
    //DebugLog(@"MotifSetDocument: setting motif set to %@", ms);
    [ms retain];
    [motifSet release];
    motifSet = ms;
    //Motif* motif = [ms motifWithIndex:0];
    //DebugLog(@"MotifSetDocument: setting the motif view %@ to show the first motif of the set: %@",motifView,motif);
    //[motifView setMotif:[ms motifWithIndex:0]];
    //DebugLog(@"MotifSetDocument: total column count: %d", [motifSet columnCountWithOffsets]);
    //DebugLog(@"MotifSetDocument: the current MotifViewCell=%@", motifViewCell);
    if ([motifSet count] > 0) {
        [motifViewCell setColumnDisplayOffset: [motifSet columnCountWithOffsets]];
        //[motifViewCell setColumnDisplayOffset: 5];
    }
    
    /*
    NSMutableArray *colors = [[[NSColorPanel sharedColorPanel] valueForKey:@"_colorSwatch"] 
                              valueForKey:@"colors"];
    
    int i = 0;
    for (Motif *m in [motifSet motifs]) {
        [m setColor: [colors objectAtIndex:i++]];
        if ([colors count] >= i) i = 0;
    }*/
    
    [motifSetController setContent:motifSet];
    [motifSetController rearrangeObjects];
}

- (MotifSet*) motifSet {
    return motifSet;
}

#pragma mark NSTableView dataSource & delegate


/*
- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [motifSet count];
}

- (id)tableView:(NSTableView*)aTableView
objectValueForTableColumn:(NSTableColumn*)aTableColumn
            row:(int)rowIndex {
    NSParameterAssert(rowIndex >= 0 && rowIndex < [motifSet count]);
    Motif *motif = [motifSet motifWithIndex:rowIndex];
    
    if ([[aTableColumn identifier] isEqual:@"name"]) {
        return [motif name];
    } else if ([[aTableColumn identifier] isEqual:@"motif"]) {
        return motif;
    } else {
        @throw [NSException exceptionWithName:@"IMUnexpectedTableColumnIdentifier" 
                                       reason:
                [NSString stringWithFormat:
                 @"Unexpected table column identifier %@ (expected \"name\" or \"motif\"",
                 [aTableColumn identifier]] 
                                     userInfo:nil];
    }
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
              row:(NSInteger)rowIndex {
    if ([[aTableColumn identifier] isEqual:@"name"]) {
        [[[self motifSet] motifWithIndex:rowIndex] setName: anObject];
        DebugLog(@"MotifSetDocument: name of motif with index %d set to %@",rowIndex,anObject);
    }
    
    [motifTable setNeedsDisplay: YES];
}*/


- (NSString *)tableView:(NSTableView *)aTableView 
         toolTipForCell:(NSCell *)aCell 
                   rect:(NSRectPointer)rect 
            tableColumn:(NSTableColumn *)aTableColumn 
                    row:(NSInteger)row 
          mouseLocation:(NSPoint)mouseLocation {
    //DebugLog(@"MotifSetWindowController: toolTip");
    if ([[aTableColumn identifier] isEqual:@"motif"]) {
        //DebugLog(@"MotifSetWindowController: arrangedObjects:%@",[motifSetController arrangedObjects]);
        Motif *m = [[motifSetController arrangedObjects] objectAtIndex:row];
        return [NSString stringWithFormat:@"%@: %@",[m name],[[m consensusString] uppercaseString]];
    } 
    return nil;
}


#pragma mark NSDraggingSource
-   (BOOL) tableView:(NSTableView *)tv 
writeRowsWithIndexes:(NSIndexSet *)rowIndexes 
        toPasteboard:(NSPasteboard*)pboard {
    DebugLog(@"MotifSetDocument: writing rows with indices to pasteboard %@",[pboard name]);
    
    NSMutableArray *draggedMotifs = [[NSMutableArray alloc] init];
    NSMutableArray *draggedMotifsOriginals = [[NSMutableArray alloc] init];
    
    unsigned currentIndex = [rowIndexes firstIndex];
    while (currentIndex != NSNotFound) {
        DebugLog(@"currentIndex=%d",currentIndex);
        Motif *m = [[motifSetController arrangedObjects] objectAtIndex:currentIndex];
        [draggedMotifs addObject:[m copy]];
        [draggedMotifsOriginals addObject:m];
        currentIndex = [rowIndexes indexGreaterThanIndex: currentIndex];
    }
    
    [pboard declareTypes:[NSArray arrayWithObjects:
                          IMMotifSetPboardType,
                          NSStringPboardType,nil] 
                   owner:self];
    
    pboardMotifs = [draggedMotifs retain];
    pboardMotifsOriginals = [draggedMotifsOriginals retain];
    DebugLog(@"MotifSetDocument: pboardMotifs = %@",pboardMotifs);
    
    return YES;
}

/*
-(NSArray*) namesOfPromisedFilesDroppedAtDestination:(NSURL*) dropDestination {
    DebugLog(@"Names of promised files dropped at destination %@", dropDestination);
    NSString *name;
    if ([pboardMotifs count] > 1) {
        name = [NSString stringWithFormat: @"%@.xms",[[pboardMotifs objectAtIndex:0] name]];
    } else {
        name = [NSString stringWithFormat: @"%d_motifs.xms",[pboardMotifs count]];
    }
    return [NSArray arrayWithObject:name];
}*/

- (void)pasteboard:(NSPasteboard *)sender 
provideDataForType:(NSString *)type {
    if ([type isEqual:IMMotifSetPboardType]) {
        DebugLog(@"MotifSetDocument: provideDataForType IMMotifSetPboardType");
        DebugLog(@"Pasteboard motifs:%@",pboardMotifs);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pboardMotifs];
        [sender setData:data 
				forType:IMMotifSetPboardType];
        
    } else if ([type isEqual:NSFilenamesPboardType]) {
        DebugLog(@"MotifSetDocument: provideDataForType NSFilenamesPboardType");
    } else if ([type isEqual:NSStringPboardType]) {
        DebugLog(@"MotifSetDocument: provideDataForType NSStringPboardType");
        MotifSet *pboardMotifSet = [[MotifSet alloc] init];
        [sender setData:[[[[pboardMotifSet toXMS] retain] description] dataUsingEncoding:NSUTF8StringEncoding] 
                forType:NSStringPboardType];
        
        
    } else if ([type isEqual:IMMotifSetIndicesPboardType]) {
        DebugLog(@"MotifSetDocument: provideDataForType IMMotifSetIndicesPboardType");
        NSMutableArray *motifIndices = [[NSMutableArray alloc] init];
        for (Motif* m in pboardMotifsOriginals) {
            [motifIndices addObject:[NSNumber numberWithInteger:[[motifSetController arrangedObjects] indexOfObject:m]]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:motifIndices]];
            [sender setData: data forType:IMMotifSetIndicesPboardType];
        }
    } /*else if ([type isEqual:NSFilesPromisePboardType]) {
        DebugLog(@"MotifSetDocument: provideDataForType NSFilesPromisePboardType");
        MotifSet *pboardMotifSet = [[MotifSet alloc] init];
        for (Motif *m in pboardMotifs) {
            [pboardMotifSet addMotif:m];
        }
        
        [sender setData:[[[[pboardMotifSet toXMS] retain] description] dataUsingEncoding:NSUTF8StringEncoding] 
                forType:NSFilesPromisePboardType];
    }*/
    
    [pboardMotifs release];
    pboardMotifs = nil;
    
    [pboardMotifsOriginals release];
    pboardMotifsOriginals = nil;
}

- (void)pasteboardChangedOwner:(NSPasteboard *)sender {
    DebugLog(@"MotifSetDocument: pasteboard changed owner. Will relase the cached data.");
    [pboardMotifs release];
    pboardMotifs = nil;
}

#pragma mark NSDraggingDestination
/*When a drag operation enters a table view, 
 the table view sends a 
 tableView:validateDrop:proposedRow:proposedDropOperation: message to its data source. 
 If this method is not implemented or if the method returns NSDragOperationNone, the drag operation is not allowed.
 
 The last two parameters of the 
 tableView:validateDrop:proposedRow:proposedDropOperation: method 
 contain the proposed row insertion point and insertion behavior 
 (NSTableViewDropOn or NSTableViewDropAbove). 
 You can override these values in your delegate method implementation by 
 sending a setDropRow:dropOperation: message to the table view.*/
- (NSDragOperation)tableView:(NSTableView*)tv 
                validateDrop:(id <NSDraggingInfo>)info 
                 proposedRow:(int)row 
       proposedDropOperation:(NSTableViewDropOperation)op {
    // Add code here to validate the drop
    //DebugLog(@"MotifSetDocument: validating drop for drag with source=%@",[info draggingSource]);
    //DebugLog(@"Available types: %@",[[info draggingPasteboard] types]);
    
    //id source = [info draggingSource];
    //NSDragOperation dragOperation = [info draggingSourceOperationMask];
    //NSWindow *destWindow = [info draggingDestinationWindow];
    
    if ([info draggingSourceOperationMask] & NSDragOperationDelete) {
        return NSDragOperationDelete;
    } 
    
    if ([info draggingSource] != tv) {
        DebugLog(@"You're dragging to a different document.");
        return NSDragOperationCopy;
    } else {
        DebugLog(@"You're dragging to the same document.");
        return NSDragOperationMove;
    }
}

/*When a validated drag operation is dropped onto a table view, 
 the table view sends a 
 tableView:acceptDrop:row:dropOperation: message to its data source. 
 
 The data source's implementation of this method should incorporate 
 the data from the dragging pasteboard (obtained from the acceptDrop parameter) 
 and use the other parameters to update the table. 
 
 For example, if the drag operation type (also obtained from the acceptDrop parameter) 
 was NSDragOperationMove and the drag originated from the table, 
 you would want to move the row from its old location to the new one.
 */
- (BOOL)tableView:(NSTableView *)aTableView 
       acceptDrop:(id <NSDraggingInfo>)info
              row:(int)row 
    dropOperation:(NSTableViewDropOperation)operation {
    DebugLog(@"MotifSetDocument: dropOperation=%d",operation);
    
    if ([info draggingSourceOperationMask] & NSDragOperationCopy) {
        NSArray *types = [[info draggingPasteboard] types];
        
        DebugLog(@"OperationMask & NSDragOperationCopy");
        
        if ([types containsObject:IMMotifSetPboardType]) {
            NSData *data = [[info draggingPasteboard] dataForType:IMMotifSetPboardType];
            NSArray *copiedMotifs = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            //DebugLog(@"Copied motifs:%@",copiedMotifs);
            
            NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(row, [copiedMotifs count])];
            
            [motifSetController insertObjects:copiedMotifs atArrangedObjectIndexes:indexes];
            //[motifSetController insertObjects:copiedMotifs atArrangedObjectIndexes:row];
            //[motifSetController addObjects:copiedMotifs atIndex:row];
            
            [motifSetController rearrangeObjects]; 
            //[[self motifTable] reloadData];
            //[[self motifTable] setNeedsDisplay:YES];
        } else if ([types containsObject:NSFilenamesPboardType]) {
            NSArray *filenames = [[info draggingPasteboard] propertyListForType:NSFilenamesPboardType];
            for (NSString *filename in filenames) {
                MotifSet *mset = [MotifSetParser motifSetFromURL:[NSURL fileURLWithPath:filename]];
                
                NSInteger mI;
                for (mI = 0; mI < [mset count]; mI++) {
                    DebugLog(@"Adding motif with name %@ (#%d)",[[mset motifWithIndex:mI] name],mI);
                    [motifSetController insertObject:[[mset motifWithIndex:mI] retain] atArrangedObjectIndex:row];
                    
                    //[[self motifSet] addMotif:[[mset motifWithIndex:mI] retain] atIndex:row];
                }
            }
            
            [motifSetController rearrangeObjects];
            //[[self motifTable] reloadData];
            //[[self motifTable] setNeedsDisplay:YES];
        }
    } else if ([info draggingSourceOperationMask] & NSDragOperationDelete) {
        DebugLog(@"OperationMask & NSDragOperationDelete");
        NSData *data = [[info draggingPasteboard] dataForType:IMMotifSetIndicesPboardType];
        NSArray *removedMotifIndices = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (NSNumber* num in removedMotifIndices) {
            NSInteger i = [num intValue];
            [motifSetController removeObject:[[motifSetController arrangedObjects] objectAtIndex:i]];
            [[self motifTable] reloadData];
            [[self motifTable] setNeedsDisplay:YES];
        }
    } else if ([info draggingSourceOperationMask] & NSDragOperationMove) {
        NSData *data = [[info draggingPasteboard] dataForType:IMMotifSetIndicesPboardType];
        NSArray *movedMotifIndices = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSMutableArray *movedMotifs = [[NSArray alloc] init];
        for (NSNumber* num in movedMotifIndices) {
            NSInteger i = [num intValue];
            Motif *movedMotif = [[motifSetController arrangedObjects] objectAtIndex:i];
            [movedMotifs addObject:movedMotif];
            [motifSetController removeObject:movedMotif];
        }
        NSInteger mI = 0;
        for (mI = [movedMotifIndices count] - 1; mI >= 0; mI++) {
            [motifSetController insertObject:[movedMotifs objectAtIndex:mI] 
                       atArrangedObjectIndex:row];
        }
        [motifSetController rearrangeObjects];
    }
    
    return YES;
}

- (NSDragOperation) draggingSourceOperationMaskForLocal:(BOOL)isLocal {
    DebugLog(@"MotifSetDocument: Returning NSDragOperationCopy as dragging source operation mask");
    //return isLocal ? NSDragOperationNone || NSDragOperationCopy || NSDragOperationMove : 
    //            NSDragOperationCopy;
    return NSDragOperationCopy;
}


- (void) remove:(id)sender {
    DebugLog(@"MotifSetDocument: delete %d rows",[[[self motifTable] selectedRowIndexes] count]);
    NSIndexSet *indices = [[self motifTable] selectedRowIndexes];
    
    NSUInteger ind = [indices firstIndex];
    NSMutableArray *motifs = [NSMutableArray arrayWithCapacity:[indices count]];
    while (ind != NSNotFound) {
        [motifs addObject:[[motifSetController arrangedObjects] objectAtIndex:ind]];
        ind = [indices indexGreaterThanIndex:ind];
    }
    for (Motif *m in motifs) {
        DebugLog(@"MotifSetDocument: deleting %@",[m name]);
        [motifSetController removeObject:m];
        //[[motifSetController arrangedObjects] removeObject:m];
    }
    [motifSetController setSelectionIndex:-1];
    [motifSetController rearrangeObjects];
}

#pragma mark Printing
- (void)printShowingPrintPanel:(BOOL)showPanels {
    // Obtain a custom view that will be printed
    NSView *printView = [self motifTable];
    // Construct the print operation and setup Print panel
    
    NSPrintOperation *op = [NSPrintOperation
                            printOperationWithView:printView
                            printInfo:[self printInfo]];
    [op setShowPanels:showPanels];
    
    if (showPanels) {
        // Add accessory view, if needed
    }
    
    // Run operation, which shows the Print panel if showPanels was YES
    [self runModalPrintOperation:op
                        delegate:nil
                  didRunSelector:NULL
                     contextInfo:NULL];
}

#pragma mark Event handling
- (BOOL) acceptsFirstResponder {
    DebugLog(@"MotifSetDocument: accepting first responder");
    return YES;
}

- (BOOL) resignFirstResponder {
    DebugLog(@"MotifSetDocument: resigning first responder");
    return YES;
}

- (BOOL) becomeFirstResponder {
    DebugLog(@"MotifSetDocument: becoming first responder");
    return YES;
}

- (void) keyDown: (NSEvent*) event {
    DebugLog(@"MotifSetDocument: interpreting key event");
    if ([event modifierFlags] & NSNumericPadKeyMask) {
        NSString *str = [event charactersIgnoringModifiers];
        unichar ch = [str characterAtIndex:0];
        
        NSIndexSet *selectedIndices = [[self motifTable] selectedRowIndexes];
        NSUInteger ind = [selectedIndices firstIndex];
        while ((ind = [selectedIndices indexGreaterThanIndex:ind]) != NSNotFound) {
            Motif *motif = [[self motifSet] motifWithIndex:ind];
            
            if (ch == NSLeftArrowFunctionKey) {
                [motif decrementOffset];
            } else if (ch == NSRightArrowFunctionKey) {
                [motif incrementOffset];
            }
        }
        if (ch == NSLeftArrowFunctionKey || ch == NSRightArrowFunctionKey) {
            [[self motifTable] setNeedsDisplay:YES];
        }
    } else {
        [[self motifTable] interpretKeyEvents:[NSArray arrayWithObject:event]];
        //[self interpretKeyEvents:[NSArray arrayWithObject: event]];
    }
}

- (void) shiftLeft:(id) sender {
    DebugLog(@"MotifSetDocument: shiftLeft");
    
    for (Motif *m in [motifSetController selectedObjects]) {
        [m decrementOffset];
    }

    [motifTable setNeedsDisplay:YES];
}

- (void) shiftRight:(id) sender {
    DebugLog(@"MotifSetDocument: shiftRight");
    
    for (Motif *m in [motifSetController selectedObjects]) {
        [m incrementOffset];
    }
    
    [motifTable setNeedsDisplay:YES];
}

/*
- (void) reverseComplement:(id) sender {
    DebugLog(@"MotifSetDocument: reverseComplement");
    NSIndexSet *indices = [[self motifTable] selectedRowIndexes];
    NSUInteger ind = [indices firstIndex];
    
    while (ind != NSNotFound) {
        
        //NSUInteger repInd = [[[self motifSet] motifs] indexOfObject:[displayedMotifs objectAtIndex: ind]];
        Motif *revCompMotif = [[[motifSetController arrangedObjects] objectAtIndex:ind] reverseComplement];
        [[motifSetController arrangedObjects] replaceObjectAtIndex:ind 
                                                        withObject:revCompMotif];
        //[motifSet replaceMotifAtIndex:repInd 
        //                     withMotif:revCompMotif];
        ind = [indices indexGreaterThanIndex: ind];
    }
    
    [motifTable reloadData];
    [motifTable setNeedsDisplay:YES];
}*/


- (void) reverseComplement:(id) sender {

    
    DebugLog(@"MotifSetDocument: reverseComplement");
    
    NSIndexSet *inds = [motifSetController selectionIndexes];
    NSUInteger mInd = [inds firstIndex];
    while (mInd != NSNotFound) {
        Motif *m = [[motifSet motifs] objectAtIndex: mInd];

        NSUInteger ind = [[motifSetController arrangedObjects] indexOfObject:m];
        
        if (ind != NSNotFound) {
            DebugLog(@"MotifSetDocument: reverse complementing %@ and replacing at index %d",[m name],ind);
            Motif *revM = [m reverseComplement];
            //[motifSetController removeObject:m];
            [motifSetController removeObjectAtArrangedObjectIndex:ind];
            [motifSetController insertObject:revM 
                       atArrangedObjectIndex:ind];
            [motifSetController addSelectionIndexes: [NSIndexSet indexSetWithIndex:mInd]];
            
        } else {
            DebugLog(@"MotifSetDocument: motif %@ was not among arranged objects, will not reverse complement it.",
                  [m name]);
        }
        
        mInd = [inds indexGreaterThanIndex:mInd];
    }
    
    [motifSetController rearrangeObjects];
}

//search field delegate method
- (void)textDidChange:(NSNotification *)aNotification {
    DebugLog(@"Text changed!");
    if (searchField.stringValue.length == 0) {

    }
}


- (IBAction) searchMotifs:(id) sender {
    
    if (self.searchType != IMMotifSetSearchByConsensusScoring && 
        [motifSetController hiddenObjects].count > 0) {
        [motifSetController showAll];
        [motifSetController rearrangeObjects];
    }
    
    if ([searchField.stringValue isEqual:@""]) {
        DebugLog(@"clearing predicate and showing all");
        [motifSetController setFilterPredicate:nil];
        [motifSetController showAll];
        [motifSetController rearrangeObjects];
    } else {
        NSString *str = [[self searchField] stringValue];
        
        if (self.searchType == IMMotifSetSearchByName) {
            [motifSetController 
             setFilterPredicate:[NSPredicate predicateWithFormat:@"name contains[c] %@",str]];
        } else if (self.searchType == IMMotifSetSearchByConsensusString) {
            [motifSetController 
             setFilterPredicate:[NSPredicate 
                                 predicateWithFormat:@"consensusString contains[c] %@",str]];
        } else if (self.searchType == IMMotifSetSearchByConsensusScoring) {
            if (searchField.stringValue.length >= IMMotifSetConsensusScoringSearchMinLength) {
                Motif *consm = [[Motif alloc] initWithAlphabet:[Alphabet dna] 
                            fromConsensusString:searchField.stringValue];
                DebugLog(@"MotifSetDocument: searchMotifs: motif=%@",[consm consensusString]);
                
                MotifsBelowDistanceCutoffOperation *belowCutoffOperation = 
                [[MotifsBelowDistanceCutoffOperation alloc] initWithComparitor: motifComparitor 
                                                                         motif: consm 
                                                     againstMotifsControlledBy: motifSetController]; 
                                [[[[NSApplication sharedApplication] delegate] sharedOperationQueue] 
                 addOperation:belowCutoffOperation];
                [belowCutoffOperation release];
            }
        }
    }
    [motifSetController rearrangeObjects];
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>) item {
    //DebugLog(@"Validating item %@",item);
    if ([item tag] == 6666) {
        [self searchType] == IMMotifSetSearchByName ?
            [(id)item setState:NSOnState] :[(id)item setState:NSOffState];
        return YES;
    } else if ([item tag] == 6667) {
        [self searchType] == IMMotifSetSearchByConsensusString ?
            [(id)item setState:NSOnState] :[(id)item setState:NSOffState];
        return YES;
    } else if ([item tag] == 6668) {
        [self searchType] == IMMotifSetSearchByConsensusScoring ?
            [(id)item setState:NSOnState] :[(id)item setState:NSOffState];
        return YES;
    }
    
    return [super validateUserInterfaceItem:item];
}

- (void) setSearchType:(IMMotifSetSearchType)stype {
    searchType = stype;
    
}

- (IBAction) searchTypeToggled:(id) sender {
    //NSMenuItem *item = (NSMenuItem*) sender;
    NSUInteger oldSearchType = [self searchType];    
    if ([[sender title] isEqual:@"Name"]) {
        DebugLog(@"MotifSetDocument: search type toggled to name");
        [self setSearchType:IMMotifSetSearchByName];
    } else if ([[sender title] isEqual:@"Consensus"]) {
        DebugLog(@"MotifSetDocument: search type toggled to consensus");
        [self setSearchType:IMMotifSetSearchByConsensusString];
    } else if ([[sender title] isEqual:@"Search"]) {
        DebugLog(@"MotifSetDocument: search type toggled to consensus");
        [self setSearchType:IMMotifSetSearchByConsensusScoring];
    }
    
    if ([self searchType] != oldSearchType) {
        if (oldSearchType == IMMotifSetSearchByName ||
            self.searchType == IMMotifSetSearchByName) {
            self.searchField.stringValue = @"";
            if (self.searchType != IMMotifSetSearchByConsensusScoring) {
                [self.motifSetController showAll];   
                [self.motifSetController rearrangeObjects];
            }
        }
    }
}

- (void) alignMotifsToLeftEnd:(id) sender {
    DebugLog(@"MotifSetDocument: aligning motifs to left end");
    [motifSet alignToLeftEnd];
    [motifSetController rearrangeObjects];
}

- (IBAction) selectNone:(id) sender {
    DebugLog(@"MotifSetDocument: selecting none");
    [motifSetController removeSelectionIndexes:[motifSetController selectionIndexes]];
    //[motifSetController rearrangeObjects];
}

- (void)changeColor:(id) sender {
    NSColor *color = [[NSColorPanel sharedColorPanel] color];
    for (Motif *m in [motifSetController selectedObjects]) {
        [m setColor: color];
        DebugLog(@"Color for %@ = %@",[m name],[m color]);
    }
    
    [motifTable setNeedsDisplay:YES];
}

- (IBAction) find: (id) sender {
    [searchField selectText: self];
    [[NSApp mainWindow] makeFirstResponder: searchField];
    //[searchField performClick: self];
}

- (IBAction) alignMotifs: (id) sender {
    DebugLog(@"MotifSetDocument: aligning motifs");
    
    //char* in_tmpname = tmpnam(NULL);
    //char* aligned_tmpname = tmpnam(NULL);
    
    //NSString *inTmp = [NSString stringWithCString:in_tmpname];
    //NSString *alignTmp = [NSString stringWithCString:aligned_tmpname];
    
    NSArray *ms = [[motifSetController selectedObjects] count] > 0 ? 
                        [motifSetController selectedObjects]: 
                        [motifSetController arrangedObjects];
    
    MotifSet *mset = [[[MotifSet alloc] init] autorelease];
    for (Motif *m in ms) {
        DebugLog(@"Adding motif %@",[m name]);
        [mset addMotif:m];
    }
    
    DebugLog(@"Exporting XMS");
    NSXMLDocument *doc = [mset toXMS];
    
    DebugLog(@"Getting file handle");
    NSFileHandle *inTmpFH = [NSFileHandle fileHandleForWritingAtPath:@"/tmp/foo.xms"];
    DebugLog(@"Writing data");
    [inTmpFH writeData:[[doc description] dataUsingEncoding:NSUTF8StringEncoding]];
    [inTmpFH closeFile];
    
    NSError *writeError;
    [[doc description] writeToFile: @"/tmp/foo.xms" 
                        atomically: YES
                          encoding: NSUTF8StringEncoding
                             error: &writeError];
    DebugLog(@"Data written");
    
    //NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"~/workspace/nmica-extra/bin/nmalign"];
    
    NSArray *arguments = [NSArray arrayWithObjects: @"/tmp/foo.xms", @"-outputType", @"all",nil];    
    DebugLog(@"Setting arguments");
    [task setArguments: arguments];
    
    DebugLog(@"Getting standard output pipe");
    //NSPipe *pipe;
    [pipe release];
    pipe = [[NSPipe alloc] init];
    [task setStandardOutput: pipe];
    //[pipe release];
    
    //[task launch]; 
    DebugLog(@"Getting file handle for reading from pipe");
    NSFileHandle *handle = [pipe fileHandleForReading];
    //NSData *data = [handle availableData];
    
    NSNotificationCenter *nc;
    nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    DebugLog(@"Adding self as an observer");
    [nc addObserver:self 
           selector:@selector(dataReady:) 
               name:NSFileHandleReadToEndOfFileCompletionNotification 
             object:handle];
    [nc addObserver:self 
           selector:@selector(taskTerminated:) 
               name:NSTaskDidTerminateNotification 
             object:task];
    
    [task launch];
    [handle readInBackgroundAndNotify];
    
    
    /*
    DebugLog(@"Checking task termination status");
    int status = [task terminationStatus];
    [task release];
    if (status != 0) {
        DebugLog(@"Motif alignment failed");
        return;
    }
    
    DebugLog(@"Parsing a motifset from the XMS");
    NSError *error;
    NSXMLDocument *alignedDoc = [[NSXMLDocument alloc] initWithData:data 
                                options:0 
                                  error:&error];
    DebugLog (@"Got:\n%@", alignedDoc);
    */
}

- (IBAction) bestHitsWith: (id)sender {
    if (!motifSetPickerSheet) {
        [NSBundle loadNibNamed: @"MotifSetPickerWindow" 
						 owner: self];
	}
	
	[motifSetPickerTableDelegate setMotifSetDocument: self];
	[motifSetPickerTableView reloadData];
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
						  @"bestHitsWith",@"action",nil];
	
	[NSApp beginSheet: motifSetPickerSheet
	   modalForWindow: [NSApp mainWindow]
		modalDelegate: self
	   didEndSelector: @selector(didEndMotifPickerSheet:returnCode:contextInfo:)
		  contextInfo: dict];
}

-(IBAction) bestReciprocalHitsWith: (id)sender {
    if (!motifSetPickerSheet) {
        [NSBundle loadNibNamed: @"MotifSetPickerWindow" 
						 owner: self];
	}
	
	[motifSetPickerTableDelegate setMotifSetDocument: self];
	[motifSetPickerTableView reloadData];
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
						  @"bestReciprocalHitsWith",@"action",nil];
	
	[NSApp beginSheet: motifSetPickerSheet
	   modalForWindow: [NSApp mainWindow]
		modalDelegate: self
	   didEndSelector: @selector(didEndMotifPickerSheet:returnCode:contextInfo:)
		  contextInfo: dict];
}

- (IBAction) addPrefixToMotifNames: (id) sender {
    if (!motifNamePickerSheet) {
        [NSBundle loadNibNamed: @"MotifSetPickerWindow" 
                         owner: self];
    }
    [motifNamePickerLabel setObjectValue:@"Add prefix"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
						  @"addPrefixToMotifNames",@"action",nil];
    //[motifNamePickerSheet setMotifSetDocument: self];
    [NSApp beginSheet: motifNamePickerSheet 
       modalForWindow: [NSApp mainWindow] 
        modalDelegate: self 
       didEndSelector: @selector(didEndMotifNamePickerSheet:returnCode:contextInfo:) 
          contextInfo: dict];
}

- (IBAction) addSuffixToMotifNames: (id) sender {
    if (!motifNamePickerSheet) {
        [NSBundle loadNibNamed: @"MotifSetPickerWindow" 
                         owner: self];
    }
    [motifNamePickerLabel setObjectValue:@"Add suffix"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
						  @"addSuffixToMotifNames",@"action",nil];
    //[motifNamePickerSheet setMotifSetDocument: self];
    [NSApp beginSheet: motifNamePickerSheet 
       modalForWindow: [NSApp mainWindow] 
        modalDelegate: self 
       didEndSelector: @selector(didEndMotifNamePickerSheet:returnCode:contextInfo:) 
          contextInfo: dict];
}



- (IBAction)closeMotifSetPickerSheet: (id)sender {
	[motifSetPickerSheet orderOut: self];
	//NOTE: The tableview has its doubleAction also tied to this closeMotifSetPickerSheet and the tableview's tag is 1 (i.e. OK)
    [NSApp endSheet:motifSetPickerSheet 
		 returnCode:([sender tag] == 1) ? NSOKButton : NSCancelButton];
    
}

-(IBAction) closeMotifNamePickerSheet: (id) sender {
    [motifNamePickerSheet orderOut: self];
    [NSApp endSheet:motifNamePickerSheet
         returnCode:([sender tag] == 1) ? NSOKButton : NSCancelButton];
}

- (void) didEndMotifNamePickerSheet: (NSWindow*) sheet 
                         returnCode: (int) returnCode 
                        contextInfo: (void*) contextInfo {
    if (returnCode == NSCancelButton) {
        return;
    } else {
        NSDictionary *dict = contextInfo;
        NSString *action = [dict objectForKey:@"action"];
        NSString *val = [motifNamePickerTextField objectValue];
        if ([action isEqual: @"addPrefixToMotifNames"]) {
            DebugLog(@"Add prefix");
            for (Motif *m in [motifSet motifs]) {
                [m setName: [val stringByAppendingFormat:m.name]];
            }
        } else {
            DebugLog(@"Add suffix");
            for (Motif *m in [motifSet motifs]) {
                [m setName: [m.name stringByAppendingFormat: val]];
            }
        }
        [motifSetController rearrangeObjects];
    }
}


- (void)didEndMotifPickerSheet: (NSWindow*)sheet 
					returnCode: (int)returnCode 
				   contextInfo: (void*)contextInfo {
	if (returnCode == NSCancelButton) { 
		DebugLog(@"Pressed cancel in the sheet");
		return;
	}
	else {
		NSDictionary *dict = contextInfo;
		NSString *action = [dict objectForKey:@"action"];
		NSIndexSet *indexes = [motifSetPickerTableView selectedRowIndexes];
		if ([action isEqual: @"bestHitsWith"]||[action isEqual:@"bestReciprocalHitsWith"]) {
			DebugLog(@"Will calculate best hits with...");
			NSUInteger curIndex = [indexes firstIndex];
			DebugLog(@"First index: %d", curIndex);
			while (curIndex != NSNotFound) {
				DebugLog(@"curIndex: %d", curIndex);
				MotifSet *mset = [[motifSetPickerTableDelegate otherMotifSets] 
								  objectAtIndex: curIndex];
                
                //NSArray *bestHitPairs;
                if ([action isEqual:@"bestHitsWith"]) {
                    //bestHitPairs = [motifComparitor 
                    //                        bestMotifPairsHitsFrom: self.motifSet.motifs 
                    //                        to: mset.motifs];
                    BestHitsOperation *bestHitsOperation = [[BestHitsOperation alloc] 
                                                            initWithComparitor: motifComparitor
                                                            from:self.motifSet.motifs 
                                                            to:mset.motifs];
                    [[[[NSApplication sharedApplication] delegate] sharedOperationQueue] 
                     addOperation:bestHitsOperation];
                    [bestHitsOperation release];
                    
				} else {
                    //bestHitPairs = [motifComparitor 
                    //                        bestReciprocalHitsFrom:self.motifSet.motifs 
                    //                        to: mset.motifs];
                    BestHitsOperation *bestRecipHitsOperation = [[BestHitsOperation alloc]
                                                                           initWithComparitor:motifComparitor 
                                                                           from:self.motifSet.motifs 
                                                                           to:mset.motifs
                                                                 reciprocal: YES];
                    [[[[NSApplication sharedApplication] delegate] sharedOperationQueue]
                     addOperation:bestRecipHitsOperation];
                    [bestRecipHitsOperation release];
                }
				//DebugLog(@"Found %d pairs", [bestHitPairs count]);
                
                
                /*
                NSError *error;
                MotifSetDocument *msetDocument = [[NSDocumentController sharedDocumentController] 
                                                 makeUntitledDocumentOfType:@"Motif set" 
                                                 error:&error];
                
                if (msetDocument) {
                    [[NSDocumentController sharedDocumentController] addDocument: msetDocument];
                    [msetDocument makeWindowControllers];
                    for (MotifPair *mp in bestHitPairs) {
                        Motif *m1 = [[Motif alloc] initWithMotif: mp.m1];
                        Motif *m2;
                        if ([mp flipped]) 
                            m2 = [[Motif alloc] initWithMotif: [mp.m2 reverseComplement]];
                        else
                            m2 = [[Motif alloc] initWithMotif: mp.m2];
                        [m2 setOffset: mp.offset];
                        [[msetDocument motifSet] addMotif: m1]; 
                        [[msetDocument motifSet] addMotif: m2];
                        DebugLog(@"%@ -> %@ : %d (%d)",
                              m1.name,
                              m2.name,
                              mp.offset,
                              mp.flipped);
                    }
                    [msetDocument showWindows];
                    
                } else {
                    NSAlert *alert = [NSAlert alertWithError:error];
                    int button = [alert runModal];
                    if (button != NSAlertFirstButtonReturn) {
                        // handle
                    }
                }*/
                curIndex = [indexes indexGreaterThanIndex: curIndex];
			}
		}
	}
}

- (void)didPresentErrorWithRecovery:(BOOL)recover
                        contextInfo:(void *)info {
    if (recover == NO) { 
        // recovery did not succeed, or no recovery attempter
        // proceed accordingly
    }
}

- (void) dataReady:(NSNotification*) n {
    NSData *d;
    d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
    DebugLog(@"dataReady:%d bytes", [d length]);
    if (task) {
        [[pipe fileHandleForReading] readInBackgroundAndNotify];
    }
}

- (void) taskTerminated:(NSNotification*) note {
    DebugLog(@"taskTerminated");
    [task release];
    task = nil;
}


-(BOOL) searchingByName {
    return [self searchType] == IMMotifSetSearchByName;
}
-(BOOL) searchingByConsensusMatching {
    return [self searchType] == IMMotifSetSearchByConsensusString;
}

-(BOOL) searchingByConsensusScoring {
    return [self searchType] == IMMotifSetSearchByConsensusScoring;
}

- (IBAction) toggleInformationContentShown: (id) sender {
    [sender state] == NSOffState ?
        [sender setState:NSOnState] : [sender setState:NSOffState];
    
    [motifViewCell setShowInformationContent: ![motifViewCell showInformationContent]];
    [motifTable setNeedsDisplay:YES];
}

- (IBAction) toggleScoreThresholdShown: (id) sender {
    [sender state] == NSOffState ?
        [sender setState:NSOnState] : [sender setState:NSOffState];
    
    [motifViewCell setShowScoreThreshold: ![motifViewCell showScoreThreshold]];
    [motifTable setNeedsDisplay:YES];
}

- (IBAction) toggleLengthShown: (id) sender {
    [sender state] == NSOffState ? [sender setState: NSOnState] : [sender setState: NSOffState];
    
    [motifViewCell setShowLength: ![motifViewCell showLength]];
    [motifTable setNeedsDisplay: YES];
}

-(IBAction) exportToPDF:(id) sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setRequiredFileType:@"pdf"];
    [panel beginSheetForDirectory:nil 
                             file:nil 
                   modalForWindow:[[NSApplication sharedApplication] mainWindow] 
                    modalDelegate:self 
                   didEndSelector:@selector(didEnd:returnCode:contextInfo:) 
                      contextInfo:NULL];
}

-(void) didEnd:(NSSavePanel*) sheet 
    returnCode:(int)code 
   contextInfo:(void*) contextInfo {
    if (code != NSOKButton) return;
    
    NSRect r = [motifTable bounds];
    NSData *data = [motifTable dataWithPDFInsideRect:r];
    NSString *path = [sheet filename];
    NSError *error;
    BOOL successful = [data writeToFile:path options:0 error:&error];
    
    if (!successful) {
        NSAlert *a = [NSAlert alertWithError:error];
        [a runModal];
    }
}

/*
-(IBAction) selectAll: (id) sender {
    
}

-(IBAction) selectNone: (id) sender {
    
}*/

-(IBAction) toggleDrawer: (id) sender {
    [drawer toggle: sender];
    [drawerTableDelegate refresh: self];
}



- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    [drawerTableDelegate refresh: self];
}

-(IBAction) toggleAnnotationsEditable: (id) sender {
    [self.drawerTableDelegate toggleEditable: sender];
}
@end
