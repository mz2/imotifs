//
//  NMTrainBGOperationConfigController.h
//  iMotifs
//
//  Created by Matias Piipari on 1/29/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class NMTrainBGModelOperation;

@interface NMTrainBGOperationConfigController : NSWindowController {

    NMTrainBGModelOperation *_operation;

}

@property(nonatomic,retain) IBOutlet NMTrainBGModelOperation *operation;

-(IBAction) browseForSequenceFile:(id) sender;
-(IBAction) browseForOutputFile:(id) sender;

-(IBAction) submit:(id) sender;
-(IBAction) cancel:(id) sender;
@end
