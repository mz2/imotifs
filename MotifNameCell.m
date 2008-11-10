//
//  MotifNameCell.m
//  iMotifs
//
//  Created by Matias Piipari on 22/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "MotifNameCell.h"


@implementation MotifNameCell
-(id) initTextCell:(NSString*) str {
    [super initTextCell:str];
    return self;
}

- (void)drawWithFrame:(NSRect)cellFrame 
               inView:(NSView *)controlView {
    [super drawWithFrame:cellFrame 
                   inView:controlView];
    //[super objectValue
    //[NSBezierPath fillRect:cellFrame];
}

@end
