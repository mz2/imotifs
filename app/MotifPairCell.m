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
//  MotifPairCell.m
//  iMotifs
//
//  Created by Matias Piipari on 12/2/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "MotifPairCell.h"
#import "MotifPair.h"

@implementation MotifPairCell

- (void) awakeFromNib {
    [super awakeFromNib];
    DebugLog(@"MotifViewCell: awakening from Nib");
}

/* the designated initializer for cells that contain images */
- (id) initImageCell:(NSImage*) image {
    self = [super initImageCell:image];
	return self;
}

/* the designated initializer for cells that contain text */
- (id) initTextCell:(NSString*) str {
    self = [super initTextCell:str];
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
	MotifPairCell *copy = [super copyWithZone: zone];
	return copy;
}


- (NSString*) description {
    return [NSString stringWithFormat:@"%@,drawingStyle=%d,columnDisplayOffset=%d,columnWidth=%g (motif=%@)",
            [super description],
            [self drawingStyle],
            [self columnDisplayOffset],
            [self columnWidth],
            [self objectValue]];
}

#pragma mark drawing
- (void)drawWithFrame: (NSRect)cellFrame 
               inView: (NSView *)controlView {
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
    
    //if (![[self objectValue] color]) {
    //    DebugLog(@"MotifViewCell: color not set for %@.",[[self objectValue] name]);
    //    [[NSColor controlBackgroundColor] set];
    //} else {
    //    DebugLog(@"MotifViewCell: color set for %@.",[[self objectValue] name]);
    //    [[[self objectValue] color] set];
    //}
    //[[NSColor controlAlternatingRowBackgroundColors
    //DebugLog(@"MotifViewCell: color for %@.",[[self objectValue] color]);
    if ([[self objectValue] color]) {
        [[[self objectValue] color] set];
        [NSBezierPath fillRect: cellFrame];
    }
	
    NSColor *tintColor=[NSColor colorForControlTint:currentTint];
    [tintColor set];
    //[NSBezierPath strokeRect: cellFrame];
    
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
    [self drawMotif: (Motif*)self.objectValue
			   rect: cellFrame 
        controlView: controlView];
    [NSGraphicsContext restoreGraphicsState];
    if ([self showInformationContent]) {
        NSMutableAttributedString *infoCStr = [MotifViewCell infoContentStringForMotif:[self objectValue]]; 
        [infoCStr drawInRect:NSInsetRect(cellFrame, 3.0, 3.0)];
    }
    
    if ([self showScoreThreshold]) {
        NSMutableAttributedString *thrStr = [MotifViewCell scoreThresholdStringForMotif:[self objectValue]];
        NSRect rect = [thrStr boundingRectWithSize:cellFrame.size 
                                           options:0];
        NSRect r = NSMakeRect(cellFrame.origin.x + 3.0, 
                              cellFrame.origin.y + cellFrame.size.height - rect.size.height - 3.0, 
                              cellFrame.size.width - 6.0, 
                              rect.size.height);
        [thrStr drawInRect:r];
    }
}

+ (void) drawLogosForMotifPair: (MotifPair*)pair 
						inRect: (NSRect)rect 
	 scaleByInformationContent: (BOOL)scaleByInfo 
					   flipped: (BOOL) flipped
					withOffset: (NSInteger)colOffset {
	NSRect rect1,rect2;
	rect1.origin = rect2.origin = rect.origin;
	rect2.origin.y = rect.origin.y + rect.size.height / 2.0;
	
	rect1.size = rect2.size = rect.size;
	rect1.size.height = rect2.size.height = rect.size.height / 2.0;
	
	[MotifViewCell drawLogoForMotif: pair.m1
							 inRect: rect1
		  scaleByInformationContent: scaleByInfo 
							flipped: flipped withOffset: colOffset];
	
	[MotifViewCell drawLogoForMotif: pair.m2
							 inRect: rect2
		  scaleByInformationContent: scaleByInfo 
							flipped: flipped withOffset: colOffset];
	
	
}


@end