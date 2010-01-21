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
//  MotifView.m
//  iMotif
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MotifView.h"
#import "MotifViewCell.h"

/*@interface MotifView (Private)
-(void) drawMotif:(NSRect)rect;
-(void) drawConsensus:(NSRect)rect;
-(void) drawLogo:(NSRect)rect scaleByInformationContent:(BOOL)yesno;
@end*/

@implementation MotifView
@synthesize motif;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //PCLog(@"MotifView: initialising with frame");
        bgColor = [[NSColor controlBackgroundColor] retain];
        //[self setDrawingStyle:IMInfoScaledLogo];
    }
    return self;
}

- (void)dealloc {
    [bgColor release];
    [super dealloc];
}

- (void)awakeFromNib {
    PCLog(@"MotifView: awakening from Nib");
    id oldCell = [self cell];
    MotifViewCell *cell = [[[MotifViewCell class] alloc] initImageCell:[oldCell image]];
    
    [[NSUserDefaults standardUserDefaults] floatForKey:@"IMMetamotifConfidenceIntervalCutoff"];
    
    [cell setColumnDisplayOffset: [self columnDisplayOffset]];
    PCLog(@"MotifView: old cell: %@",oldCell);
    PCLog(@"MotifView: represented motif: %@", [self motif]);
    //[cell setImage:[oldCell image]];
    [cell setObjectValue:motif];
    [self setCell:cell];
    [cell release];
}

+ (Class) cellClass {
    return [MotifViewCell class];
}

-(Motif*) motif {
    return motif;
}

-(void) setMotif:(Motif*) m {
    PCLog(@"MotifView: setting motif to %@",m);
    [m retain];
    [[self motif] release];
    motif = m;
    [self setColumnDisplayOffset: [motif columnCount]];
    [[self cell] setObjectValue:motif];
}

#pragma mark Accessors
- (void)setBgColor:(NSColor*) c {
    [c retain];
    [bgColor release];
    bgColor = c;
    [self setNeedsDisplay:YES];
}

-(NSColor*) bgColor {
    return bgColor;
}

#pragma mark Drawing

- (BOOL) isFlipped {
    return YES;
}

- (NSInteger) columnDisplayOffset {
    return columnDisplayOffset;
}
- (void) setColumnDisplayOffset:(NSInteger)val {
    columnDisplayOffset = val;
    [[self cell] setColumnDisplayOffset: val];
    [self setNeedsDisplay:YES];
}

#pragma mark Event handling
- (BOOL) acceptsFirstResponder {
    PCLog(@"MotifView: accepting first responder");
    return YES;
}

- (BOOL) resignFirstResponder {
    PCLog(@"MotifView: resigning first responder");
    [self setNeedsDisplay: YES];
    return YES;
}

- (BOOL) becomeFirstResponder {
    PCLog(@"MotifView: becoming first responder");
    [self setNeedsDisplay: YES];
    return YES;
}

- (void) keyDown: (NSEvent*) event {
    if ([event modifierFlags] & NSNumericPadKeyMask) {
        NSString *str = [event charactersIgnoringModifiers];
        unichar ch = [str characterAtIndex:0];
        if (ch == NSLeftArrowFunctionKey) {
            [motif decrementOffset];
            [self setNeedsDisplay:YES];
        } else if (ch == NSRightArrowFunctionKey) {
            [motif incrementOffset];
            [self setNeedsDisplay:YES];
        }
    } else {
        [self interpretKeyEvents:[NSArray arrayWithObject: event]];
    }
}

/*
- (void) insertTab:(id) sender {
    PCLog(@"MotifView: inserted tab");
}
- (void) insertBacktab:(id) sender {
    PCLog(@"MotifView: inserted backtab");
}
- (void) insertText:(NSString*) input {
    PCLog(@"MotifView: inserted text:%@",input);
}
*/

/*
- (void) moveLeft {
    PCLog(@"MotifView: move left");
    [motif decrementOffset];
    [self setNeedsDisplay:YES];
}

- (void) moveRight {
    PCLog(@"MotifView: move right");
    [motif incrementOffset];
    [self setNeedsDisplay:YES];
}*/

/*
        - (void) insertText:(NSString*) input {
    PCLog(@"MotifView: inserted %@",input);
    if ([input isEqual: @"k"]) {
        [self moveToLeft];
    } else if ([input isEqual:@"l"]) {
        [self moveToRight];
    }
    [self setNeedsDisplay: YES];
}
*/
        
@end
