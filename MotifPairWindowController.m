//
//  MotifPairWindowController.m
//  iMotifs
//
//  Created by Matias Piipari on 12/3/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "MotifPairWindowController.h"


@implementation MotifPairWindowController
@synthesize motifPairs, motifPairController;

-(void) dealloc {
    [motifPairs release];
    
    [super dealloc];
}
@end
