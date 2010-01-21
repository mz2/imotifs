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
    
    IBOutlet NSButton *closeButton;
    IBOutlet NSButton *showResultsButton;
    
    //NSString *outputMotifSetPath;
    NMOperation *operation;
}

@property (retain, readwrite) NSTextField *iterationNumberLabel;
@property (retain, readwrite) NSTextField *evidenceLabel;
@property (retain, readwrite) NSTextField *likelihoodLabel;
@property (retain, readwrite) NSProgressIndicator *spinner;
@property (retain, readwrite) NSLevelIndicator *level;

@property (retain, readwrite) NSButton *closeButton;
@property (retain, readwrite) NSButton *showResultsButton;

@property (nonatomic, retain, readwrite) NMOperation *operation;
//@property (nonatomic, retain, readwrite) NSString *outputMotifSetPath;


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
//-(IBAction) stopAnimatingSpinner:(id) sender;
-(IBAction) motifDiscoveryDone:(id) sender;
-(IBAction) showResults:(id) sender;
@end
