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
//  IMAnnotationSetDocument.h
//  iMotifs
//
//  Created by Matias Piipari on 06/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMotifsDocument.h"

@class IMAnnotationSetController;

@interface IMAnnotationSetDocument : NSDocument <IMotifsDocument> {
    NSArray *_annotations;
    NSString *_name;
    
    IMAnnotationSetController *_annotationSetController;
    NSTableView *_tableView;
    
}
@property (readwrite,retain) NSArray *annotations;
@property (readwrite,retain) IBOutlet IMAnnotationSetController *annotationSetController;
@property (readwrite,copy) NSString *name;

+(NSArray*) annotationSetDocuments;


@end