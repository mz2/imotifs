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
//  MotifViewCell.m
//  iMotifs
//
//  Created by Matias Piipari on 30/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "IMConstants.h"
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

@implementation IMSequenceViewCell
@synthesize symbolWidth = _symbolWidth;

- (void) awakeFromNib {
    [super awakeFromNib];
    PCLog(@"IMSequenceViewcell: awakening from Nib");
}

/* the designated initializer for cells that contain images */
- (id) initImageCell:(NSImage*) image {
    self = [super initImageCell:image];
    if (self != nil) {
        _symbolWidth = [[NSUserDefaults standardUserDefaults] floatForKey:IMSymbolWidthKey];
    }
    return self;
}

/* the designated initializer for cells that contain text */
- (id) initTextCell:(NSString*) str {
    PCLog(@"MotifViewCell: initialising motif view text cell");
    self = [super initTextCell:str];
    if (self != nil) {
        _symbolWidth = [[NSUserDefaults standardUserDefaults] floatForKey:IMSymbolWidthKey];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];	
	_symbolWidth = [coder decodeFloatForKey:IMSymbolWidthKey];
	
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
	[coder encodeFloat:_symbolWidth forKey:IMSymbolWidthKey];
}

- (id)copyWithZone:(NSZone *)zone {
    //PCLog(@"MotifViewCell: copying %@",self);
    IMSequenceViewCell *cellCopy = NSCopyObject(self, 0, zone);
    [[self objectValue] retain];
    [cellCopy setObjectValue: self.objectValue];
    [cellCopy setImage: self.image];
	[cellCopy setSymbolWidth: self.symbolWidth];
    
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
	
	//toggle selection
	/*
	if ([[self objectValue] focusPosition] == symPos) {
		[[self objectValue] setFocusPosition: NSNotFound];
	} else {
		[[self objectValue] setFocusPosition: symPos];		
	}*/
	[[self objectValue] setFocusPosition: symPos];
        
    IMSequence *seq = (IMSequence*)[self objectValue];

	[self willChangeValueForKey:@"features"];
	[self willChangeValueForKey:@"selectedFeatures"];
    for (IMFeature *f in seq.features) {[f setSelected: NO];}
    NSArray *selectedFeats = [seq featuresOverlappingWithPosition: symPos];
    //PCLog(@"Selected features: %@ (all: %@)", selectedFeats, [seq features]);
    for (IMFeature *f in selectedFeats) {[f setSelected: YES];}
    [self didChangeValueForKey:@"features"];
	[self didChangeValueForKey:@"selectedFeatures"];
	return [super trackMouse:theEvent 
					  inRect: cellFrame 
					  ofView: controlView 
				untilMouseUp: untilMouseUp];
}

-(CGFloat) sequenceLengthInPixels:(IMSequence*) seq {
	return (_symbolWidth * (CGFloat)[self.objectValue length]);
}
-(CGFloat) sequence:(IMSequence*)seq lengthFractionAtPoint:(NSPoint) p {
	return (p.x - IMSequenceCellMargin) / [self sequenceLengthInPixels: seq];
}

-(NSInteger) symbolPositionAtPoint:(NSPoint) p {
	IMSequence *seq = (IMSequence*)[self objectValue];
	CGFloat seqLength = [self sequenceLengthInPixels: seq];
	CGFloat lengthFraction = [self sequence:seq lengthFractionAtPoint:p];
	CGFloat syms = (lengthFraction * seqLength) / _symbolWidth;
    
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
    
    
	CGFloat seqWidthOnScreen = seq.length * _symbolWidth;	
	//PCLog(@"Seq will be %.2f pixels long on screen", seqWidthOnScreen);
    
    
	NSRect insetRect = NSMakeRect(0, 2, seqWidthOnScreen, 6);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect: insetRect];
    
    
    [path setLineWidth: 1.0];
    [[NSColor grayColor] setFill];
    [[NSColor blackColor] setStroke];
    //[path fill];
    [path stroke];
	
    

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
	
	NSInteger focus = [[self objectValue] focusPosition];
	
	if (focus != NSNotFound) {
		[NSGraphicsContext saveGraphicsState]; //moveToSeqStart
		NSAffineTransform *moveToSeqStart = [NSAffineTransform transform];
		
		[moveToSeqStart translateXBy:[[self objectValue] focusPosition] * _symbolWidth
								 yBy:5];
		[moveToSeqStart concat];
		
		
		NSBezierPath* path = [[[NSBezierPath alloc] init] autorelease];
		[path moveToPoint:NSMakePoint(-6, 0)];
		[path lineToPoint:NSMakePoint(0, -6)];
		[path lineToPoint:NSMakePoint(6, 0)];
		[path lineToPoint:NSMakePoint(0, 6)];		
		[path lineToPoint:NSMakePoint(-6, 0)];
		
		[[[NSColor redColor] colorWithAlphaComponent:0.8] setFill];
		[path fill];
		[NSGraphicsContext restoreGraphicsState];
		
		/* draw the focus range */
		NSRange range = [[self objectValue] focusRange];		
		[NSGraphicsContext saveGraphicsState]; //moveToSeqStart
		NSAffineTransform *focusBoxStart = [NSAffineTransform transform];
		[focusBoxStart translateXBy:range.location * _symbolWidth
								 yBy:0];
		[focusBoxStart concat];
		
		PCLog(@"(%d) %d => %d",focus, range.location, range.location + range.length);
		NSBezierPath *focusBox = 
		[NSBezierPath bezierPathWithRect:NSMakeRect(0,0, 
													range.length * _symbolWidth, 10)];
		[[[NSColor redColor] colorWithAlphaComponent:0.2] setFill];
		[focusBox fill];
		
		[NSGraphicsContext restoreGraphicsState];
	}
    
    [NSGraphicsContext saveGraphicsState];
    /* focus detail string */
    NSAffineTransform *trans = [NSAffineTransform transform];
    [trans translateXBy:[[self objectValue] focusPosition] yBy:10];
    [trans concat];
    
    NSAttributedString *fstring = [(IMSequence*)[self objectValue] focusPositionFormattedString];
    [fstring drawInRect:NSMakeRect(-200, 0, 400, 25)];
    
    [NSGraphicsContext restoreGraphicsState];
}

- (void) drawPointFeature: (IMPointFeature*) a
              forSequence: (IMSequence*) seq
                   inRect: (NSRect) rect {
    NSAffineTransform *moveToSeqStart = [NSAffineTransform transform];
    
	[moveToSeqStart translateXBy:a.position yBy:5];
	[moveToSeqStart concat];
	
    [NSGraphicsContext saveGraphicsState];
    
    NSBezierPath *p = [[[NSBezierPath alloc] init] autorelease];
    [p moveToPoint:NSMakePoint(a.position * _symbolWidth, 0)];
    [p lineToPoint:NSMakePoint(a.position * _symbolWidth - 5, -5)];
    [p lineToPoint:NSMakePoint(a.position * _symbolWidth + 5, -5)];
    [p lineToPoint:NSMakePoint(a.position * _symbolWidth, 0)];
    
    [NSGraphicsContext restoreGraphicsState];
}

- (void) drawRangeFeature: (IMRangeFeature*) a
              forSequence: (IMSequence*) seq
                   inRect: (NSRect) rect {
    [NSGraphicsContext saveGraphicsState];
	NSAffineTransform *transform = [NSAffineTransform transform];
    
	[transform translateXBy:a.start * _symbolWidth 
                        yBy:0];
    //[transform scaleXBy:IMSymbolWidth yBy:1.0];
    [transform concat];
    
	NSRect insetRect = NSMakeRect(0, 0, [a length] * _symbolWidth , 10);
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
		if (a.color == nil) {
			[[NSColor redColor] setStroke];
		} else {
			
			[[[a.color colorWithAlphaComponent:1.0] blendedColorWithFraction:0.5 
																	 ofColor:[NSColor blackColor]] setStroke];
			[path setLineWidth: 2];
			[path stroke];
		}
    }
    
    
	[NSGraphicsContext restoreGraphicsState]; //moveToSeqStart
}

@end