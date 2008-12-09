//
//  MotifSetPickerWindowController.h
//  iMotifs
//
//  Created by Matias Piipari on 12/3/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MotifSet;
@interface MotifSetPickerWindowController : NSWindowController {
	MotifSet *motifs;
}
@property (retain, readwrite) MotifSet *motifs;
@end
