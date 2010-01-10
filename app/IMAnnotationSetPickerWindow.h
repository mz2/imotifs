//
//  IMAnnotationSetPickerWindow.h
//  iMotifs
//
//  Created by Matias Piipari on 08/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IMAnnotationSetPickerWindow : NSWindow {
    NSTableView *_tableView;
}

@property (retain, readwrite) IBOutlet NSTableView *tableView;

@end
