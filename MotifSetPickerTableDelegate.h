//
//  MotifSetPickerTableDelegate.h
//  iMotifs
//
//  Created by Matias Piipari on 12/3/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MotifSetDocument;

@interface MotifSetPickerTableDelegate : NSObject {
	IBOutlet MotifSetDocument *motifSetDocument;
	NSMutableArray *otherMotifSetDocuments;
	NSMutableArray *otherMotifSets;
}

@property (retain, readwrite) MotifSetDocument *motifSetDocument;
@property (retain, readonly) NSArray *otherMotifSetDocuments;
@property (retain, readonly) NSArray *otherMotifSets;
@end
