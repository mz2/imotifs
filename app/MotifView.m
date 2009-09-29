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
        //DebugLog(@"MotifView: initialising with frame");
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
    DebugLog(@"MotifView: awakening from Nib");
    id oldCell = [self cell];
    MotifViewCell *cell = [[[MotifViewCell class] alloc] initImageCell:[oldCell image]];
    
    [[NSUserDefaults standardUserDefaults] floatForKey:@"IMMetamotifConfidenceIntervalCutoff"];
    
    [cell setColumnDisplayOffset: [self columnDisplayOffset]];
    DebugLog(@"MotifView: old cell: %@",oldCell);
    DebugLog(@"MotifView: represented motif: %@", [self motif]);
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
    DebugLog(@"MotifView: setting motif to %@",m);
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
    DebugLog(@"MotifView: accepting first responder");
    return YES;
}

- (BOOL) resignFirstResponder {
    DebugLog(@"MotifView: resigning first responder");
    [self setNeedsDisplay: YES];
    return YES;
}

- (BOOL) becomeFirstResponder {
    DebugLog(@"MotifView: becoming first responder");
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
    DebugLog(@"MotifView: inserted tab");
}
- (void) insertBacktab:(id) sender {
    DebugLog(@"MotifView: inserted backtab");
}
- (void) insertText:(NSString*) input {
    DebugLog(@"MotifView: inserted text:%@",input);
}
*/

/*
- (void) moveLeft {
    DebugLog(@"MotifView: move left");
    [motif decrementOffset];
    [self setNeedsDisplay:YES];
}

- (void) moveRight {
    DebugLog(@"MotifView: move right");
    [motif incrementOffset];
    [self setNeedsDisplay:YES];
}*/

/*
        - (void) insertText:(NSString*) input {
    DebugLog(@"MotifView: inserted %@",input);
    if ([input isEqual: @"k"]) {
        [self moveToLeft];
    } else if ([input isEqual:@"l"]) {
        [self moveToRight];
    }
    [self setNeedsDisplay: YES];
}
*/
        
@end
