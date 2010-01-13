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
#import "IMPointFeature.h"
#import "IMSequence.h"

@interface IMSequenceViewCell (private)
- (void) drawSequence: (IMSequence*) seq 
			   inRect: (NSRect)rect;
- (void) drawRangeFeature: (IMRangeFeature*) a
				 forSequence: (IMSequence*) seq
					  inRect: (NSRect) rect;

- (void) drawPointFeature: (IMPointFeature*) a
              forSequence: (IMSequence*) seq
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
	
	NSInteger symPos = [self symbolPositionAtPoint: cellP];
	[[self objectValue] setFocusPosition: symPos];
    
	PCLog(@"Track mouse event %f,%f in rect %f,%f (%f,%f) of view %@ until mouse up %d: %d",
		  p.x,p.y,cellFrame.origin.x,cellFrame.origin.y,cellP.x,cellP.y,controlView,untilMouseUp, symPos);
    
    IMSequence *seq = (IMSequence*)[self objectValue];

	[self willChangeValueForKey:@"features"];
	[self willChangeValueForKey:@"selectedFeatures"];
    for (IMFeature *f in seq.features) {[f setSelected: NO];}
    NSArray *selectedFeats = [seq featuresOverlappingWithPosition: symPos];
    PCLog(@"Selected features: %@ (all: %@)", selectedFeats, [seq features]);
    for (IMFeature *f in selectedFeats) {[f setSelected: YES];}
    [self didChangeValueForKey:@"features"];
	[self didChangeValueForKey:@"selectedFeatures"];
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
 return [super startTrackingAt:startPoint inView: controlView];
 }
 
 - (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag {
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
    
    [self drawSequence: (IMSequence*)self.objectValue inRect: cellFrame];
    
    [NSGraphicsContext restoreGraphicsState];
}

- (void) drawSequence: (IMSequence*) seq inRect: (NSRect)rect {
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
	
    /*
	if ([[self objectValue] focusPosition] != NSNotFound) {
		NSRect rect = NSMakeRect([[self objectValue] focusPosition] * IMSymbolWidth, 0, 10, 10);
		NSBezierPath* circlePath = [NSBezierPath bezierPath];
		[circlePath appendBezierPathWithOvalInRect: rect];
        
		[[NSColor redColor] setFill];
		[circlePath fill];
	}*/
    
	for (IMFeature *f in [seq features]) {
		if ([f isKindOfClass:[IMRangeFeature class]]) {
			[self drawRangeFeature: (IMRangeFeature*)f
					   forSequence: seq
							inRect: rect];
		}
        if ([f isKindOfClass:[IMPointFeature class]]) {
            [self drawPointFeature: (IMPointFeature*)f
                       forSequence: seq
                            inRect: rect];
        }
	}
	
	[NSGraphicsContext restoreGraphicsState]; //moveToSeqStart
}

- (void) drawPointFeature: (IMPointFeature*) a
              forSequence: (IMSequence*) seq
                   inRect: (NSRect) rect {
    NSAffineTransform *moveToSeqStart = [NSAffineTransform transform];
    
	[moveToSeqStart translateXBy:a.position yBy:5];
	[moveToSeqStart concat];
	
    [NSGraphicsContext saveGraphicsState];
    
    NSBezierPath *p = [[[NSBezierPath alloc] init] autorelease];
    [p moveToPoint:NSMakePoint(a.position * IMSymbolWidth, 0)];
    [p lineToPoint:NSMakePoint(a.position * IMSymbolWidth - 5, -5)];
    [p lineToPoint:NSMakePoint(a.position * IMSymbolWidth + 5, -5)];
    [p lineToPoint:NSMakePoint(a.position * IMSymbolWidth, 0)];
    
    [NSGraphicsContext restoreGraphicsState];
}

- (void) drawRangeFeature: (IMRangeFeature*) a
              forSequence: (IMSequence*) seq
                   inRect: (NSRect) rect {
    [NSGraphicsContext saveGraphicsState];
	NSAffineTransform *transform = [NSAffineTransform transform];
    
	[transform translateXBy:a.start * IMSymbolWidth 
                        yBy:0];
    //[transform scaleXBy:IMSymbolWidth yBy:1.0];
    [transform concat];
    
	NSRect insetRect = NSMakeRect(0, 0, [a length] * IMSymbolWidth , 10);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect: insetRect];
    
    [path setLineWidth: 1.0];
    
    if (a.color == nil) {[[NSColor colorWithDeviceHue:0.0 saturation:0.0 brightness:0.8 alpha:0.5] setFill];} 
    else {
        if (a.selected) {
            [[a.color colorWithAlphaComponent:1.0] setFill];
        } else {
            [[a.color colorWithAlphaComponent:0.5] setFill];
        }
    }
    [path fill];
    
    if (a.selected) {
        [[NSColor redColor] setStroke];
        [path stroke];
    }
    
	[NSGraphicsContext restoreGraphicsState]; //moveToSeqStart
}

@end