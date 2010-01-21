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
//  NMCutoffController.h
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class NMCutoffOperation;

@interface NMCutoffController : NSWindowController {
    NMCutoffOperation *_operation;
}

@property (retain, readwrite) IBOutlet NMCutoffOperation *operation;

-(IBAction) browseForMotifsFile:(id) sender;
-(IBAction) browseForSeqsFile:(id) sender;
-(IBAction) browseForBackgroundModelFile:(id) sender;
-(IBAction) browseForOutputFile:(id) sender;

-(IBAction) cancel:(id) sender;
-(IBAction) ok:(id) sender;

@end
