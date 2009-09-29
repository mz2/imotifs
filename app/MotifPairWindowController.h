//
//  MotifPairWindowController.h
//  iMotifs
//
//  Created by Matias Piipari on 12/3/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MotifPair;
@class MotifPairArrayController;

@interface MotifPairWindowController : NSWindowController {
	NSMutableArray *motifPairs;
	IBOutlet MotifPairArrayController *motifPairController;
}

@property (retain, readwrite) NSMutableArray *motifPairs;
@property (retain, readwrite) MotifPairArrayController *motifPairController;
@end
