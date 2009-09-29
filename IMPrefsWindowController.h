//
//  IMPrefsWindowController.h
//  iMotifs
//
//  Created by Matias Piipari on 31/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBPrefsWindowController.h"

@interface IMPrefsWindowController : DBPrefsWindowController {
    IBOutlet NSView *generalPrefsView;
    IBOutlet NSView *vizPrefsView;
    
    IBOutlet NSView *nmicaPrefsView;
    IBOutlet NSView *ensemblPrefsView;
}

@property (retain, readwrite) NSView *generalPrefsView;
@property (retain, readwrite) NSView *vizPrefsView;
@property (retain, readwrite) NSView *nmicaPrefsView;
@property (retain, readwrite) NSView *ensemblPrefsView;

@end
