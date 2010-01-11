//
//  BCSeriesTableController.h
//  BioCocoa
//
//  Created by Scott Christley on 10/07/08.
//  Copyright (c) 2003-2009 The BioCocoa Project.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. The name of the author may not be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

/*!
@header
@abstract Controller for BCSeriesTable interface. 
*/

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface BCSeriesTableController : NSObject {
	IBOutlet NSWindow *datasetWindow;
	IBOutlet NSTableView *datasetTable;
  IBOutlet NSPopUpButton *datasetColumns;
  IBOutlet NSPanel *inspectorPanel;
  //IBOutlet NSTextView *inspectorText;
  IBOutlet WebView *inspectorText;

  NSMutableDictionary *series;
	NSMutableArray *dataset;
	NSMutableArray *datasetSearch;
}

// Default constructor
- initWithSeries: (NSDictionary *)aSet;

- (void)makeKeyAndOrderFront: (id)sender;

// Manage the user interface
- (IBAction)loadSeries: (id)sender;
- (IBAction)showPlatforms: (id)sender;
- (IBAction)showSamples: (id)sender;
- (IBAction)showProbes: (id)sender;
- (IBAction)showGEODownload: (id)sender;
- (IBAction)modifyTableColumn: (id)sender;
- (IBAction)searchSeries: (id)sender;

@end
