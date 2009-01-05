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
        //NSLog(@"MotifView: initialising with frame");
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
    NSLog(@"MotifView: awakening from Nib");
    id oldCell = [self cell];
    MotifViewCell *cell = [[[MotifViewCell class] alloc] initImageCell:[oldCell image]];
    [cell setColumnDisplayOffset: [self columnDisplayOffset]];
    NSLog(@"MotifView: old cell: %@",oldCell);
    NSLog(@"MotifView: represented motif: %@", [self motif]);
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
    NSLog(@"MotifView: setting motif to %@",m);
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
    NSLog(@"MotifView: accepting first responder");
    return YES;
}

- (BOOL) resignFirstResponder {
    NSLog(@"MotifView: resigning first responder");
    [self setNeedsDisplay: YES];
    return YES;
}

- (BOOL) becomeFirstResponder {
    NSLog(@"MotifView: becoming first responder");
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
    NSLog(@"MotifView: inserted tab");
}
- (void) insertBacktab:(id) sender {
    NSLog(@"MotifView: inserted backtab");
}
- (void) insertText:(NSString*) input {
    NSLog(@"MotifView: inserted text:%@",input);
}
*/

/*
- (void) moveLeft {
    NSLog(@"MotifView: move left");
    [motif decrementOffset];
    [self setNeedsDisplay:YES];
}

- (void) moveRight {
    NSLog(@"MotifView: move right");
    [motif incrementOffset];
    [self setNeedsDisplay:YES];
}*/

/*
        - (void) insertText:(NSString*) input {
    NSLog(@"MotifView: inserted %@",input);
    if ([input isEqual: @"k"]) {
        [self moveToLeft];
    } else if ([input isEqual:@"l"]) {
        [self moveToRight];
    }
    [self setNeedsDisplay: YES];
}
*/
        
@end
