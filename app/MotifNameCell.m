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
