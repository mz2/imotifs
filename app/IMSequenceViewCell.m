//
//  MotifViewCell.m
//  iMotifs
//
//  Created by Matias Piipari on 30/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <BioCocoa/BCSequenceArray.h>
#import "IMSequenceViewCell.h"
#import "IMRangeFeature.h"
#import "IMSequence.h"

@interface IMSequenceViewCell (private)
- (void) drawSequence: (BCSequence*) seq 
			   inRect: (NSRect)rect;
- (void) drawRangeFeature: (IMRangeFeature*) a
				 forSequence: (BCSequence*) seq
					  inRect: (NSRect) rect;
-(NSInteger) symbolPositionAtPoint:(NSPoint) p;
@end

const CGFloat IMSymbolWidth = 2.0;


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

- (BOOL)trackMouse:(NSEvent *)theEvent 
			inRect:(NSRect)cellFrame 
			ofView:(NSView *)controlView 
	  untilMouseUp:(BOOL)untilMouseUp {
    
	/* Origin in p is in top-left, in cellP it is  */
	NSPoint p = [controlView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    
	NSPoint cellP = NSMakePoint(p.x - cellFrame.origin.x,p.y - cellFrame.origin.y);
	[[self objectValue] setFocusPosition: [self symbolPositionAtPoint: cellP]];
    
	PCLog(@"Track mouse event %f,%f in rect %f,%f (%f,%f) of view %@ until mouse up %d",
		  p.x,p.y,cellFrame.origin.x,cellFrame.origin.y,cellP.x,cellP.y,controlView,untilMouseUp);
    
    
	return [super trackMouse:theEvent 
					  inRect: cellFrame 
					  ofView: controlView 
				untilMouseUp: untilMouseUp];
    
}

-(CGFloat) sequenceLengthInPixels:(IMSequence*) seq {
	return (IMSymbolWidth * (CGFloat)[self.objectValue length]);
}
-(CGFloat) sequence:(IMSequence*)seq lengthFractionAtPoint:(NSPoint) p {
	return (p.x - IMSequenceCellMargin) / [self sequenceLengthInPixels: seq];
}


-(NSInteger) symbolPositionAtPoint:(NSPoint) p {
	IMSequence *seq = (IMSequence*)[self objectValue];
	CGFloat seqLength = [self sequenceLengthInPixels: seq];
    
	CGFloat lengthFraction = [self sequence:seq lengthFractionAtPoint:p];
    
    
	CGFloat syms = (lengthFraction * seqLength) / IMSymbolWidth;
    
	if (lengthFraction > 1.0) {
		return NSNotFound;
	} else if (lengthFraction < 0) {
		return NSNotFound;
	}
    
	return syms;
}

/*
 - (BOOL)startTrackingAt:(NSPoint)startPoint 
 inView:(NSView *)controlView {
 //PCLog(@"Start tracking at %f,%f in view %@", startPoint.x,startPoint.y, controlView);
 return [super startTrackingAt:startPoint inView: controlView];
 }
 
 - (BOOL)continueTracking:(NSPoint)lastPoint 
 at:(NSPoint)currentPoint
 inView:(NSView *)controlView {
 PCLog(@"Continue tracking from %f,%f to %f,%f in view %@", 
 lastPoint.x,
 lastPoint.y,
 currentPoint.x,
 currentPoint.y,
 controlView);
 return [super continueTracking:lastPoint at:currentPoint inView:controlView];
 }
 
 - (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag {
 PCLog(@"Stop tracking at %f,%f in view %@. mouse is up:%d", lastPoint,stopPoint,controlView,flag);
 [super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];
 }
 */

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
    
    NSAffineTransform *cellTransform = [NSAffineTransform transform];
    [cellTransform translateXBy:cellFrame.origin.x 
                            yBy:cellFrame.origin.y];
    [cellTransform concat];
    
    [self drawSequence: (BCSequence*)self.objectValue inRect: cellFrame];
    
    [NSGraphicsContext restoreGraphicsState];
}

- (void) drawSequence: (BCSequence*) seq inRect: (NSRect)rect {
	NSAffineTransform *moveToSeqStart = [NSAffineTransform transform];
	[moveToSeqStart translateXBy:IMSequenceCellMargin yBy:IMSequenceCellMargin];
	[moveToSeqStart concat];
	[NSGraphicsContext saveGraphicsState];
    
    
	CGFloat seqWidthOnScreen = seq.length * IMSymbolWidth;	
	PCLog(@"Seq will be %.2f pixels long on screen", seqWidthOnScreen);
    
    
	NSRect insetRect = NSMakeRect(0, 1, seqWidthOnScreen, 8);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect: insetRect];
    
    
    [path setLineWidth: 1.0];
    [[NSColor blackColor] setFill];
    [[NSColor grayColor] setStroke];
    [path fill];
    [path stroke];
    
	[self drawRangeFeature:
	 [IMRangeFeature rangeFeatureWithStart: 10 end: 20 score: 10 strand:IMStrandNA]
                  forSequence: seq
                       inRect: rect];
    
	[self drawRangeFeature:
	 [IMRangeFeature rangeFeatureWithStart: 80 end: 100 score: 10 strand:IMStrandNA]
				  forSequence: seq
					   inRect: rect];
    
	if ([[self objectValue] focusPosition] != NSNotFound) {
        
		NSRect rect = NSMakeRect([[self objectValue] focusPosition] * IMSymbolWidth, 0, 10, 10);
		NSBezierPath* circlePath = [NSBezierPath bezierPath];
		[circlePath appendBezierPathWithOvalInRect: rect];
        
		[[NSColor redColor] setFill];
		[circlePath stroke];
	}
    
	[NSGraphicsContext restoreGraphicsState]; //moveToSeqStart
}

- (void) drawRangeFeature: (IMRangeFeature*) a
				 forSequence: (BCSequence*) seq
					  inRect: (NSRect) rect {
	NSAffineTransform *moveToSeqStart = [NSAffineTransform transform];
	[moveToSeqStart translateXBy:a.start * IMSymbolWidth yBy:0];
	[moveToSeqStart concat];
	[NSGraphicsContext saveGraphicsState];
    
	NSRect insetRect = NSMakeRect(0, 0, [a length] * IMSymbolWidth, 10);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect: insetRect];
    
    [path setLineWidth: 2.0];
    [[NSColor blueColor] setFill];
    [[NSColor darkGrayColor] setStroke];
    [path fill];
    [path stroke];
    
	[NSGraphicsContext restoreGraphicsState]; //moveToSeqStart
}

@end