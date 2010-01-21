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
    IBOutlet NSButton *lockToggleButton;
}

@property (retain, readwrite) MotifSetDocument *motifSetDocument;
@property (retain, readwrite) NSTableView *table;
@property (retain, readwrite) NSTextField *tableLabel;
@property (retain, readwrite) NSButton *addButton;
@property (retain, readwrite) NSButton *removeButton;
@property (retain, readwrite) NSButton *lockToggleButton;

@property (readwrite) BOOL annotationsEditable;

-(NSString*) tableDescription;
-(NSArray*) sortedAnnotationKeys;

-(IBAction) refresh: (id) sender;
-(NSMutableDictionary*) annotations;
-(IBAction) newAnnotation: (id) sender;
-(IBAction) removeAnnotation: (id) sender;
-(IBAction) toggleEditable: (id) sender;

@end
