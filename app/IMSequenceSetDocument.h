//
//  IMSequenceSetDocument.h
//  iMotifs
//
//  Created by Matias Piipari on 03/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMSequenceSetController;
@class IMSequenceView;
@class BCSequenceArray;

@interface IMSequenceSetDocument : NSDocument {
    NSString *_name;
    BCSequenceArray *_sequenceArray;
    
    IMSequenceView *_sequenceView;
    
    IMSequenceSetController *_sequenceSetController;
    
    NSTextField *_numberOfSequencesLabel;
}

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) IBOutlet IMSequenceView *sequenceView;
@property(nonatomic,retain) IBOutlet IMSequenceSetController *sequenceSetController;
@property(nonatomic,retain) BCSequenceArray *sequenceArray;
@property(nonatomic,retain) IBOutlet NSTextField *numberOfSequencesLabel;

@end
