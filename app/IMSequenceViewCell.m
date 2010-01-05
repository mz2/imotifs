//
//  MotifViewCell.m
//  iMotifs
//
//  Created by Matias Piipari on 30/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <BioCocoa/BCSequenceArray.h>
#import <IMSequenceViewCell.h>


@interface IMSequenceViewCell (private)
- (void) drawSequence: (BCSequence*) seq inRect: (NSRect)rect;
@end

@implementation IMSequenceViewCell

- (void) awakeFromNib {
    [super awakeFromNib];
    PCLog(@"IMSequenceViewcell: awakening from Nib");
}

/* the designated initializer for cells that contain images */
- (id) initImageCell:(NSImage*) image {
    self = [super initImageCell:image];
    if (self != nil) {

    }
    return self;
}

/* the designated initializer for cells that contain text */
- (id) initTextCell:(NSString*) str {
    PCLog(@"MotifViewCell: initialising motif view text cell");
    self = [super initTextCell:str];
    if (self != nil) {

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

- (id)copyWithZone:(NSZone *)zone {
    //PCLog(@"MotifViewCell: copying %@",self);
    IMSequenceViewCell *cellCopy = NSCopyObject(self, 0, zone);
    [[self objectValue] retain];
    [cellCopy setObjectValue: self.objectValue];
    [cellCopy setImage: self.image];
    
    return [cellCopy retain];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"[IMSequenceViewCell %@]",[self objectValue]];
}

#pragma mark drawing
- (void)drawWithFrame:(NSRect)cellFrame 
               inView:(NSView *)controlView {
    if ([self showsFirstResponder]) {
        // showsFirstResponder is set for us by the NSControl that is drawing  us.
        NSRect focusRingFrame = cellFrame;
        focusRingFrame.size.height -= 2.0;
        
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle(NSFocusRingOnly);
        //[[NSBezierPath bezierPathWithRect: NSInsetRect(focusRingFrame,4,6)] fill];
        [NSGraphicsContext restoreGraphicsState];
    }
    
    NSControlTint currentTint;
    if ([[controlView window] isKeyWindow])
        currentTint = [self controlTint];
    else
        currentTint= NSClearControlTint;
    
    if ([self controlTint] == NSDefaultControlTint)
        currentTint=[NSColor currentControlTint];
    else
        currentTint=[self controlTint];
    
    /*
    if ([[self objectValue] color]) {
        [[[self objectValue] color] set];
        [NSBezierPath fillRect: cellFrame];
    }*/
    
    NSColor *tintColor=[NSColor colorForControlTint:currentTint];
    [tintColor set];
    
    if (![controlView isFlipped]) {
        NSAffineTransform* xform = [NSAffineTransform transform];
        [xform translateXBy:0.0 yBy:cellFrame.size.height];
        [xform scaleXBy:1.0 yBy:-1.0];
        [xform concat];
    }
    
    [NSGraphicsContext saveGraphicsState];
    [NSBezierPath clipRect:cellFrame];
    /*
    NSAffineTransform *cellTransform = [NSAffineTransform transform];
    [cellTransform translateXBy:cellFrame.origin.x 
                            yBy:cellFrame.origin.y];
    [cellTransform concat];
    */
    [self drawSequence: (BCSequence*)self.objectValue
                inRect: cellFrame];
    
    [NSGraphicsContext restoreGraphicsState];
}

- (void) drawSequence: (BCSequence*) seq inRect: (NSRect)rect {
    NSRect insetRect = NSInsetRect(rect, IMSequenceCellMargin + 5, IMSequenceCellMargin);
    
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect: insetRect];
    [path setLineWidth: 2.0];
    [[NSColor blackColor] setFill];
    [[NSColor grayColor] setStroke];
    [path fill];
    [path stroke];

    //draw
}

@end
