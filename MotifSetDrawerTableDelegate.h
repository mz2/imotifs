//
//  MotifSetDrawerTableDelegate.h
//  iMotifs
//
//  Created by Matias Piipari on 12/4/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MotifSetDocument;

@interface MotifSetDrawerTableDelegate : NSObject {
    IBOutlet MotifSetDocument *motifSetDocument;
    IBOutlet NSTableView *table;
    IBOutlet NSTextField *tableLabel;
    IBOutlet NSButton *addButton;
    IBOutlet NSButton *removeButton;
}

@property (retain, readwrite) MotifSetDocument *motifSetDocument;
@property (retain, readwrite) NSTableView *table;
@property (retain, readwrite) NSTextField *tableLabel;
@property (retain, readwrite) NSButton *addButton;
@property (retain, readwrite) NSButton *removeButton;

-(NSString*) tableDescription;
-(NSArray*) sortedAnnotationKeys;

-(IBAction) refresh: (id) sender;
-(NSMutableDictionary*) annotations;
-(IBAction) newAnnotation: (id) sender;
-(IBAction) removeAnnotation: (id) sender;
@end
