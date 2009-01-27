//
//  NMOperationStatusDialogController.h
//  iMotifs
//
//  Created by Matias Piipari on 1/27/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class NMOperation;

@interface NMOperationStatusDialogController : NSWindowController {
    IBOutlet NSTextField *likelihoodLabel;
    IBOutlet NSTextField *evidenceLabel;
    IBOutlet NSTextField *iterationNumberLabel;
    IBOutlet NSProgressIndicator *spinner;
    IBOutlet NSLevelIndicator *level;
    
    ///NSUInteger iterationNumber;
    //double evidence;
    //double likelihood;
    //double iterationTime;
    NMOperation *operation;
}

@property (retain, readwrite) NSTextField *iterationNumberLabel;
@property (retain, readwrite) NSTextField *evidenceLabel;
@property (retain, readwrite) NSTextField *likelihoodLabel;
@property (retain, readwrite) NSProgressIndicator *spinner;
@property (retain, readwrite) NSLevelIndicator *level;

@property (nonatomic, retain, readwrite) NMOperation *operation;

-(void) setIterationNumber: (NSNumber*)num;
-(void) setPriorMassShifted: (NSNumber*)num;
-(void) setBestLikelihood: (NSNumber*)num;
-(void) setAccummulatedEvidence: (NSNumber*)num;
-(void) setIterationTime: (NSNumber*)num;
-(void) setStatus:(NSString*)str;
//@property (readwrite) NSUInteger iterationNumber;
//@property (readwrite) double evidence;
//@property (readwrite) double likelihood;
//@property (readwrite) double iterationTime;
-(IBAction) stop:(id) sender;
-(IBAction) stopAnimatingSpinner:(id) sender;
@end
