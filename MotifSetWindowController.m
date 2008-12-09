//
//  MotifSetWindowController.m
//  iMotifs
//
//  Created by Matias Piipari on 27/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "MotifSetWindowController.h"
#import "Motif.h"
#import "MotifSetParser.h"

@implementation MotifSetWindowController
- (id) init {
    self = [super init];
    if (self != nil) {
        NSLog(@"MotifSetWindowController: initialising");
      }
    return self;
}


-(void) dealloc {
    NSLog(@"MotifSetWindowController: deallocating");
    [super dealloc];
}

-(void) awakeFromNib {
    NSLog(@"MotifSetWindowController: awakening from Nib");
}

@end
