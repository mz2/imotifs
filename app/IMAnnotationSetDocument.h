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
