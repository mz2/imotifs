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

#import <MotifViewCell.h>
#import "IMAppController.h"
#import "Metamotif.h"
#import "Dirichlet.h"
#import "DistributionBounds.h"
#import "SymbolBounds.h"

CGFloat const IMDefaultNameWidth = 100.0;
NSInteger const IMLeftColPadding = 2;
CGFloat const IMDefaultColWidth = 50.0;
CGFloat const IMDefaultColHeight = 60.0;
CGFloat const IMMotifMargin = 4.0;

@interface MotifViewCell (Private)
- (void) drawConsensus: (Motif*)m 
				  rect: (NSRect)rect
            withOffset: (NSInteger) offset;
+ (NSMutableAttributedString*) makeSymbolDrawable:(Symbol*)sym 
                                          ofSize:(CGFloat)size 
                                         ofColor:(NSColor*) color;
- (NSInteger) calcLeftPaddingColumns:(NSRect)rect;
- (NSRect) measureString:(NSString*)str inRect:(NSRect)rect;
@end

NSString *IMMotifSetPboardType = @"net.piipari.motifset.pasteboard";
NSString *IMMotifSetIndicesPboardType = @"net.piipari.motifset.indices.pasteboard";

NSString *IMLogoFontName = @"Arial Bold";

@implementation MotifViewCell
@synthesize drawingStyle;
@synthesize columnDisplayOffset;
@synthesize columnWidth,columnHeight;
@synthesize showInformationContent,showScoreThreshold,showLength;
@synthesize confidenceIntervalCutoff;
@synthesize columnPrecisionDrawingStyle;

- (void) awakeFromNib {
    [super awakeFromNib];
    PCLog(@"MotifViewCell: awakening from Nib");
}

/* the designated initializer for cells that contain images */
- (id) initImageCell:(NSImage*) image {
    //NSLog(@"MotifViewCell: initialising motif view image cell");
    self = [super initImageCell:image];
    if (self != nil) {
        [self setDrawingStyle: IMInfoScaledLogo];
        [self setColumnDisplayOffset: IMLeftColPadding];
        [self setColumnWidth: [[NSUserDefaults standardUserDefaults] floatForKey:IMColumnWidth]];
        [self setColumnHeight: [[NSUserDefaults standardUserDefaults] floatForKey:IMMotifHeight]];
        [self setShowInformationContent: NO];
        [self setShowScoreThreshold: NO];
        [self setShowLength: NO];
        [self setConfidenceIntervalCutoff: 0.95];
        [self setColumnPrecisionDrawingStyle: IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol];
    }
    return self;
}

/* the designated initializer for cells that contain text */
- (id) initTextCell:(NSString*) str {
    PCLog(@"MotifViewCell: initialising motif view text cell");
    self = [super initTextCell:str];
    if (self != nil) {
        [self setDrawingStyle:IMInfoScaledLogo];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    PCLog(@"MotifViewCell: initWithCoder");
    self = [super initWithCoder:coder];
    drawingStyle = [coder decodeIntegerForKey: @"drawingStyle"];
    columnDisplayOffset = [coder decodeIntegerForKey: @"columnDisplayOffset"];
    columnWidth = [coder decodeFloatForKey:@"columnWidth"];
    columnHeight = [coder decodeFloatForKey:@"columnHeight"];
    showInformationContent = [coder decodeBoolForKey:@"showInformationContent"];
    showScoreThreshold = [coder decodeBoolForKey:@"showScoreThreshold"];
    showLength = [coder decodeBoolForKey:@"showLength"];
    confidenceIntervalCutoff = [coder decodeFloatForKey:@"confidenceIntervalCutoff"];
    columnPrecisionDrawingStyle = [coder decodeIntegerForKey:@"columnPrecisionDrawingStyle"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    PCLog(@"MotifViewCell: encodeWithCoder");
    [super encodeWithCoder:coder];
    [coder encodeInteger: [self drawingStyle] 
                  forKey: @"drawingStyle"];
    [coder encodeInteger: [self columnDisplayOffset] 
                  forKey: @"columnDisplayOffset"];
    [coder encodeFloat: [self columnWidth] 
                         forKey: @"columnWidth"];
    [coder encodeFloat: [self columnHeight] 
                forKey:@"columnHeight"];
    [coder encodeBool: showInformationContent 
               forKey: @"showInformationContent"];
    [coder encodeBool: showScoreThreshold
               forKey: @"showScoreThreshold"];
    [coder encodeBool: showLength 
               forKey: @"showLength"];
    [coder encodeFloat: confidenceIntervalCutoff 
                forKey: @"confidenceIntervalCutoff"];
    [coder encodeInt: columnPrecisionDrawingStyle 
              forKey: @"columnPrecisionDrawingStyle"];
}

- (id)copyWithZone:(NSZone *)zone {
    //PCLog(@"MotifViewCell: copying %@",self);
    MotifViewCell *cellCopy = NSCopyObject(self, 0, zone);
    [[self objectValue] retain];
    [cellCopy setObjectValue: self.objectValue];
    [cellCopy setImage: self.image];
    [cellCopy setColumnWidth: self.columnWidth];
    [cellCopy setColumnHeight: self.columnHeight];
    [cellCopy setColumnDisplayOffset: self.columnDisplayOffset];
    [cellCopy setDrawingStyle: self.drawingStyle];
    [cellCopy setShowInformationContent: self.showInformationContent];
    [cellCopy setShowScoreThreshold: self.showScoreThreshold];
    [cellCopy setShowLength: self.showLength];
    [cellCopy setConfidenceIntervalCutoff: self.confidenceIntervalCutoff];
    [cellCopy setColumnPrecisionDrawingStyle: self.columnPrecisionDrawingStyle];
    return [cellCopy retain];
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
- (void)drawWithFrame:(NSRect)cellFrame 
               inView:(NSView *)controlView {
    //NSLog(@"Drawing with frame");
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
             offset: [self calcLeftPaddingColumns:cellFrame]];
    
    [NSGraphicsContext restoreGraphicsState];
    if (self.showInformationContent) {
        NSMutableAttributedString *infoCStr = [MotifViewCell infoContentStringForMotif:[self objectValue]]; 
        [infoCStr drawInRect:NSInsetRect(cellFrame, 3.0, 3.0)];
    }
    
    if (self.showScoreThreshold) {
        NSMutableAttributedString *thrStr = [MotifViewCell scoreThresholdStringForMotif:[self objectValue]];
        NSRect rect = [thrStr boundingRectWithSize:cellFrame.size 
                                           options:0];
        NSRect r = NSMakeRect(cellFrame.origin.x + 3.0, 
                              cellFrame.origin.y + cellFrame.size.height - rect.size.height - 3.0, 
                              cellFrame.size.width - 6.0, 
                              rect.size.height);
        [thrStr drawInRect:r];
    }
    
    if (self.showLength) {
        NSMutableAttributedString *lenStr = [MotifViewCell lengthStringForMotif:[self objectValue]];
        NSRect rect = [lenStr boundingRectWithSize:cellFrame.size 
                                           options:0];
        NSRect r = NSMakeRect(cellFrame.origin.x + 3.0, 
                              cellFrame.origin.y + (cellFrame.size.height / 2 - 6.0), 
                              cellFrame.size.width - 6.0, 
                              rect.size.height);
        [lenStr drawInRect:r];
    }
    
}

- (void) drawMotif: (Motif*) m
			  rect: (NSRect)rect
            offset: (NSInteger) offset {
    
    //NSLog(@"Drawing %@ in rect [%f,%f, %f,%f] with offset %d", 
    //      m, 
    //      rect.origin.x,rect.origin.y,
    //      rect.size.width,rect.size.height,offset);
    NSRect insetRect = NSInsetRect(rect, IMMotifMargin, IMMotifMargin);
    if ([self drawingStyle] == IMConsensus) {
        [self drawConsensus: (Motif*) m 
					   rect: insetRect
                 withOffset: offset];
        
    } else if ([self drawingStyle] == IMLogo) {
        [MotifViewCell drawLogoForMotif: [self objectValue]
                                 inRect: insetRect 
                            columnWidth: self.columnWidth
              scaleByInformationContent: NO 
                                flipped: YES 
                             withOffset: offset
                  minConfidenceInterval: 1.0 - [self confidenceIntervalCutoff]
                  maxConfidenceInterval: [self confidenceIntervalCutoff]
                  precisionDrawingStyle: [self columnPrecisionDrawingStyle]];
        
    } else if ([self drawingStyle] == IMInfoScaledLogo) {
        [MotifViewCell drawLogoForMotif: [self objectValue] 
                                 inRect: insetRect 
                            columnWidth: self.columnWidth
              scaleByInformationContent: YES 
                                flipped: YES 
                             withOffset: offset 
                  minConfidenceInterval: 1.0 - [self confidenceIntervalCutoff]
                  maxConfidenceInterval: [self confidenceIntervalCutoff]
                  precisionDrawingStyle: [self columnPrecisionDrawingStyle]];
        
    }
}

+ (void) drawLogoForMotif: (Motif*)motif 
                   inRect: (NSRect)rect 
              columnWidth: (CGFloat) wantedWidth
scaleByInformationContent: (BOOL)scaleByInfo 
                  flipped: (BOOL) flipped
               withOffset: (NSInteger)colOffset {
    return [MotifViewCell drawLogoForMotif: motif 
                                    inRect: rect 
                               columnWidth: (CGFloat) wantedWidth
                 scaleByInformationContent: scaleByInfo 
                                   flipped: flipped
                                withOffset: colOffset
                     minConfidenceInterval: 0.05
                     maxConfidenceInterval: 0.95
                     precisionDrawingStyle: IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol];
}

+ (void)   drawLogoForMotif: (Motif*)motif 
                     inRect: (NSRect)rect 
                columnWidth: (CGFloat) wantedWidth
  scaleByInformationContent: (BOOL)scaleByInfo 
                    flipped: (BOOL) flipped
                 withOffset: (NSInteger)colOffset
      minConfidenceInterval: (CGFloat) minInterval
      maxConfidenceInterval: (CGFloat) maxInterval
      precisionDrawingStyle: (IMMotifColumnPrecisionDrawingStyle) precStyle {
    //PCLog(@"MotifViewCell: drawing logo for objectValue=%@ (objectValue=%@)",[self objectValue], [self objectValue]);
    int colCount = [motif columnCount];
    int i;
    NSPoint point;
    point.x = 0;
    point.y = 0;
    
    //BOOL isMetaMotif = [motif isKindOfClass:[Metamotif class]];
    //PCLog(@"Drawing logo for %@ (%@)", motif, motif.className);
    
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    NSMutableAttributedString *aLetter = [[NSMutableAttributedString alloc] 
                                          initWithString: @"A"];
    
    [aLetter addAttribute: NSFontAttributeName
                    value: [NSFont fontWithName:IMLogoFontName size:rect.size.height]
                    range:NSMakeRange(0,1)];
        
    [context saveGraphicsState];
    
    NSAffineTransform *offsetTransform = [NSAffineTransform transform];
    [offsetTransform translateXBy:(colOffset + [motif offset]) * wantedWidth 
                              yBy:0.0];
    [offsetTransform concat];
    
    for (i = 0; i < colCount; i++) {
        
        if ([motif isKindOfClass:[Metamotif class]] && 
            (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsFuzzyMotif)) {
            
            Multinomial *mean = [(Dirichlet*)[motif column: i] mean];
            NSArray *syms = [mean symbolsWithWeightsInDescendingOrder];
            
            NSUInteger r;
            for (r = 0; r < 200; r++) {
                [MotifViewCell drawColumn: i
                                  ofMotif: motif
                                   inRect: rect
                              columnWidth: wantedWidth
                scaleByInformationContent: scaleByInfo
                                  flipped: flipped 
                               withOffset: colOffset
                    minConfidenceInterval: minInterval
                    maxConfidenceInterval: maxInterval
                    precisionDrawingStyle: precStyle
                           symbolsOrdered: syms];
            }
        } else {
            [MotifViewCell drawColumn: i
                              ofMotif: motif
                               inRect: rect
                          columnWidth: wantedWidth
            scaleByInformationContent: scaleByInfo
                              flipped: flipped 
                           withOffset: colOffset
                minConfidenceInterval: minInterval
                maxConfidenceInterval: maxInterval
                precisionDrawingStyle: precStyle
                       symbolsOrdered: nil];
        }
        
    }
    [context restoreGraphicsState];
}


+ (void)        drawColumn: (NSUInteger) i 
                   ofMotif: (Motif*) motif
                    inRect: (NSRect) rect
               columnWidth: (CGFloat) wantedWidth
 scaleByInformationContent: (BOOL) scaleByInfo
                   flipped: (BOOL) flipped 
                withOffset: (NSInteger) offset
     minConfidenceInterval: (CGFloat) minInterval
     maxConfidenceInterval: (CGFloat) maxInterval
     precisionDrawingStyle: (IMMotifColumnPrecisionDrawingStyle) precStyle
            symbolsOrdered: (NSArray*) orderedSymbols {
    
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    
    [context saveGraphicsState];
    Multinomial *column = [motif column: i];
    Multinomial *col;
    Dirichlet *dir = nil;
    
    BOOL isMetaMotif = [column isKindOfClass:[Dirichlet class]];
    if (isMetaMotif) {
        dir = (Dirichlet*)column;
        
        if (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsFuzzyMotif) {
            col = [dir sample];            
        } else {
            col = [dir mean];
        }
    } else {
        col = column;
    }
    
    NSArray *syms;
    if (orderedSymbols == nil) {
        syms = [col symbolsWithWeightsInDescendingOrder];
    } else {
        syms = orderedSymbols;
    }
    
    double colScale;
    
    double informationContent, totalBits;
    informationContent = [col informationContent];
    totalBits = [col totalBits];
    
    colScale = scaleByInfo ? informationContent/totalBits : 1.0;
    
    NSAffineTransform *transMove = [NSAffineTransform transform];
    
    //CGFloat wantedWidth = columnWidth;
    
    CGFloat xTrans = wantedWidth * i + wantedWidth * offset;
    CGFloat yTrans = 0.0;
    
    if (flipped) {
        yTrans = rect.size.height;
    }
    
    [transMove translateXBy:xTrans
                        yBy:yTrans];
    [transMove concat];
    CGFloat accumMove = 0;
    
    NSUInteger symNum = 0;
    for (Symbol *sym in syms) {
        double w = [col weightForSymbol:sym];
        
        [context saveGraphicsState];
        
        NSColor *color = nil;
        if (isMetaMotif && precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsFuzzyMotif) {
            color = [NSColor colorWithCalibratedRed: [[sym defaultFillColor] redComponent] * 1.0 
                                              green: [[sym defaultFillColor] greenComponent] * 1.0 
                                               blue: [[sym defaultFillColor] blueComponent] * 1.0
                                              alpha: 0.005];
        }
        
        NSMutableAttributedString *nameDrawable = [MotifViewCell makeSymbolDrawable:sym 
                                                                             ofSize:rect.size.height 
                                                                            ofColor: color];
        NSRect symMeas = [nameDrawable boundingRectWithSize:rect.size
                                                    options:0];
        
        double sizeRatio = symMeas.size.height / rect.size.height;
        double scaleYRatio = 1.0 * colScale * w;
        
        if (flipped) {
            accumMove -= scaleYRatio * symMeas.size.height;
        } else {
            accumMove += scaleYRatio * symMeas.size.height;
        }
        
        NSAffineTransform *letterTransform = [NSAffineTransform transform];
        [letterTransform translateXBy:0.0 yBy:accumMove];
        [letterTransform scaleXBy: (wantedWidth/symMeas.size.width) yBy: scaleYRatio];
        [letterTransform concat];
        
        NSPoint pointLB;
        NSRect rectLB;
        pointLB.x = 0;
        pointLB.y = (symMeas.size.height - (symMeas.size.height / sizeRatio));
        
        rectLB = NSMakeRect(pointLB.x,
                            pointLB.y,
                            symMeas.size.width,
                            symMeas.size.height / sizeRatio);
        
        
        /*
         NSColor* col = [NSColor colorWithCalibratedRed:[[sym defaultFillColor] redComponent] * 0.25 
         green:[[sym defaultFillColor] greenComponent] * 0.25 
         blue:[[sym defaultFillColor] blueComponent] * 0.25 
         alpha:0.8];
         
         [col set];
         [NSBezierPath fillRect:rectLB];
         */
        [nameDrawable drawInRect:rectLB];
        if (isMetaMotif) {
            
            DistributionBounds *dirB = [dir confidenceAtMinInterval: minInterval 
                                                        maxInterval: maxInterval];
            SymbolBounds *symB = [dirB boundsForSymbol: sym];
            
            
            //the min/max bar style error bars starting from the bottom of the letter
            NSRect minSymBound;
            
            CGFloat minSymY;
            if (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsFromBottomToTop) {
                minSymY = pointLB.y + symMeas.size.height / sizeRatio;
                minSymBound = NSMakeRect(pointLB.x + ((3.0 - (CGFloat)symNum) * symMeas.size.width * 0.25),
                                         minSymY, 
                                         symMeas.size.width * 0.25,
                                         -((symB.min / w) * (symMeas.size.height / sizeRatio) * 0.74));
            } else if (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol) {
                minSymY = (pointLB.y + symMeas.size.height / sizeRatio) + (-((symB.min / w) * (symMeas.size.height / sizeRatio) * 0.74));
                minSymBound = NSMakeRect(pointLB.x + (symMeas.size.width * 0.25),
                                         minSymY, 
                                         symMeas.size.width * 0.50,
                                         0.7 * (1.0 / w));
            }
            
            NSRect maxSymBound;
            
            CGFloat maxSymY;
            if (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsFromBottomToTop) {
                maxSymY = pointLB.y + symMeas.size.height / sizeRatio;
                maxSymBound = NSMakeRect(pointLB.x + ((3.0 - (CGFloat)symNum) * symMeas.size.width * 0.25),
                                         maxSymY, 
                                         symMeas.size.width * 0.25,
                                         -((symB.max / w) * (symMeas.size.height / sizeRatio) * 0.74));
            } else if (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol) {
                maxSymY = (pointLB.y + symMeas.size.height / sizeRatio) +(-((symB.max / w) * (symMeas.size.height / sizeRatio) * 0.74));
                maxSymBound = NSMakeRect(pointLB.x + symMeas.size.width * 0.25,
                                         maxSymY, 
                                         symMeas.size.width * 0.50,
                                         0.7 * (1.0 / w));
            }
            
            [[NSColor colorWithCalibratedRed: [[sym defaultFillColor] redComponent] * 0.6 
                                       green: [[sym defaultFillColor] greenComponent] * 0.6 
                                        blue: [[sym defaultFillColor] blueComponent] * 0.6
                                       alpha: 0.8] set];
            
            if ((minSymY - maxSymY) > 0.0 && (minSymY > 0.0) && (maxSymY > 0.0)) {
                if (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol) {
                    NSBezierPath *upBarPath = [NSBezierPath bezierPathWithRect:NSMakeRect(
                                                                                          pointLB.x + symMeas.size.width * 0.47, 
                                                                                          maxSymY, 
                                                                                          symMeas.size.width * 0.06,
                                                                                          minSymY - maxSymY)];
                    //[upBarPath setLineWidth: 5.0];
                    
                    //[[NSColor blackColor] set];
                    [upBarPath fill];
                }
            }
            
            NSBezierPath *minbpath = [NSBezierPath bezierPathWithRect: minSymBound];
            
            [minbpath setLineWidth: 3.0];
            [minbpath fill];
            [minbpath stroke];
            
            /*
             [[NSColor colorWithCalibratedRed: [[sym defaultFillColor] redComponent] * 0.6
             green: [[sym defaultFillColor] greenComponent] * 0.6
             blue: [[sym defaultFillColor] blueComponent] * 0.6
             alpha: 0.8] set];
             */
            
            //NSLog(@"%@ minSymBound %.3f, %.3f - diff: %.3f", [sym shortName], minSymY, maxSymY, minSymY - maxSymY);
            
            
            NSBezierPath *maxbpath = [NSBezierPath bezierPathWithRect: maxSymBound];
            [maxbpath setLineWidth: 3.0];
            [maxbpath stroke];
            [maxbpath fill];
            
        }
        
        
        /* set the color */
        
        [context restoreGraphicsState];
        
        symNum += 1;
    }
    
    [context restoreGraphicsState];
}


- (NSInteger) calcFittingColumnCountInRect:(NSRect)rect {
    return (NSInteger)round(rect.size.width / [self columnWidth]);
}

- (NSInteger) calcLeftPaddingColumns:(NSRect)rect {
    NSInteger extraCols = [self calcFittingColumnCountInRect:rect] / 3;
    //NSLog(@"MotifViewCell: fitting columns=%d , displayOffset=%d",extraCols,[self columnDisplayOffset]);

    if (extraCols > 0) {
        return extraCols / 2;
    } else return 0;
}

- (NSRect) measureString:(NSString*)str inRect:(NSRect)rect {
    //PCLog(@"MotifViewCell: measuring string %@ (%@)",str, [str className]);
    NSMutableAttributedString *atstr = 
    [[NSMutableAttributedString alloc] initWithString:str];
    NSRect r = [atstr boundingRectWithSize:rect.size
                                   options:0];
    [atstr release];
    atstr = nil;
    return r;
}

+ (NSMutableAttributedString*) makeSymbolDrawable:(Symbol*) sym 
                                           ofSize:(CGFloat)size 
                                          ofColor:(NSColor*)color {
    NSMutableAttributedString* nameDrawable = [[NSMutableAttributedString alloc] 
     initWithString: [[sym shortName] uppercaseString]];
    
    NSRange range = NSMakeRange(0,[nameDrawable length]);
    [nameDrawable addAttribute: NSFontAttributeName
                         value: [NSFont userFontOfSize:size]
                         range: range];
    
    [nameDrawable addAttribute: NSForegroundColorAttributeName 
                         value: (color == nil) ? [sym defaultFillColor] : color 
                         range: range];
    
    return [nameDrawable autorelease]; 
}

+ (NSMutableAttributedString*) infoContentStringForMotif:(Motif*) motif {
    NSMutableAttributedString* infoStr = [[NSMutableAttributedString alloc] 
                                               initWithString: 
                                               [NSString stringWithFormat:@"%.3g bits",[motif informationContent]]];
    
    NSRange range = NSMakeRange(0,[infoStr length]);
    [infoStr addAttribute: NSFontAttributeName
                         value: [NSFont userFontOfSize:9.0]
                         range: range];
    
    [infoStr applyFontTraits: NSBoldFontMask 
                       range: range];
    
    [infoStr addAttribute: NSForegroundColorAttributeName 
                         value: [[NSColor blackColor] colorWithAlphaComponent:0.5]
                         range: range];
    
    [infoStr setAlignment: NSRightTextAlignment 
                    range: range];
    return [infoStr autorelease];
}

+ (NSMutableAttributedString*) scoreThresholdStringForMotif:(Motif*) motif {
    NSMutableAttributedString* infoStr = [[NSMutableAttributedString alloc] 
                                          initWithString: 
                                          [NSString stringWithFormat:@"%.3g",[motif threshold]]];
    
    NSRange range = NSMakeRange(0,[infoStr length]);
    [infoStr addAttribute: NSFontAttributeName
                    value: [NSFont userFontOfSize:9.0]
                    range: range];
        
    [infoStr addAttribute: NSForegroundColorAttributeName 
                    value: [[NSColor blueColor] colorWithAlphaComponent:0.5] 
                    range: range];
    
    [infoStr applyFontTraits: NSBoldFontMask 
                       range: range];
    
    [infoStr setAlignment: NSRightTextAlignment 
                    range: range];
    return [infoStr autorelease];
}

+ (NSMutableAttributedString*) lengthStringForMotif:(Motif*) motif {
    NSMutableAttributedString* infoStr = [[NSMutableAttributedString alloc] 
                                          initWithString: 
                                          [NSString stringWithFormat:@"%d",[motif columnCount]]];
    
    NSRange range = NSMakeRange(0,[infoStr length]);
    [infoStr addAttribute: NSFontAttributeName
                    value: [NSFont userFontOfSize:9.0]
                    range: range];
    
    [infoStr addAttribute: NSForegroundColorAttributeName 
                    value: [[NSColor redColor] colorWithAlphaComponent:0.7] 
                    range: range];
    
    [infoStr applyFontTraits: NSBoldFontMask 
                       range: range];
    
    [infoStr setAlignment: NSRightTextAlignment 
                    range: range];
    return [infoStr autorelease];
}

- (double) letterXTransformation:(NSString*) str
                          inRect:(NSRect)rect{
    //PCLog(@"MotifViewCell: letter X transformation for %@", str);
    NSRect meas = [self measureString:str inRect:rect];
    return (rect.size.height / meas.size.height) * (double)meas.size.width;
}

- (double) letterYTransformation:(NSString*)str 
                          inRect:(NSRect)rect {
    //PCLog(@"MotifViewCell: letter Y transformation for %@", str);
    NSRect meas = [self measureString:str inRect:rect];
    return (rect.size.height / meas.size.height);
}

- (void) drawConsensus:(Motif*) motif 
                  rect:(NSRect) rect
           controlView:(NSView*) view {
    NSString* consensus = [[self objectValue] consensusString];
    //PCLog(@"MotifViewCell: drawing consensus \"%@\"", consensus);
    
    NSMutableAttributedString *s;
    s = [[NSMutableAttributedString alloc]
         initWithString:[consensus uppercaseString]];
    [s addAttribute: NSFontAttributeName
              value: [NSFont userFontOfSize:rect.size.height]
              range:NSMakeRange(0,[s length])];
    
    NSRect actualRect = [s boundingRectWithSize:rect.size
                                        options:0];
    
    NSAffineTransform *trans = [NSAffineTransform transform];
    double scaleRatio = (double) actualRect.size.height / (double)rect.size.height;
    [trans scaleBy: scaleRatio];
    
    if ([[self objectValue] offset] != 0) {
        [trans translateXBy: [self letterXTransformation:@"A"
                                                  inRect:rect] * [[self objectValue] offset]
                        yBy:0];
    }
    [trans concat];
    
    [s drawInRect: rect];
    [s release];
    s = nil;
}

-(NSBitmapImageRep*) makeBitmapImageRepForMotif:(Motif*) motif {
    NSRect offscreenRect = NSMakeRect(0.0, 0.0,
                                      self.columnWidth * [motif columnCount] * 2, 
                                      self.columnHeight * 2);
    
    NSBitmapImageRep* offscreenRep = nil;
    
    
    offscreenRep = [[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil
                                                           pixelsWide:(NSInteger)round(offscreenRect.size.width)
                                                           pixelsHigh:(NSInteger)round(offscreenRect.size.height)
                                                        bitsPerSample:8
                                                      samplesPerPixel:4
                                                             hasAlpha:YES
                                                             isPlanar:NO
                                                       colorSpaceName:NSCalibratedRGBColorSpace
                                                         bitmapFormat:0
                                                          bytesPerRow:4*(NSInteger)round(offscreenRect.size.width) * 2
                                                         bitsPerPixel:32] autorelease];
    
    //NSLog(@"Bitmap rep created");
    //NSImage *offscreenImage = [[NSImage alloc] initWithSize:offscreenRect.size];
    //[offscreenImage addRepresentation: offscreenRep];
    
    if (offscreenRep != nil) {
        //NSLog(@"Off screen rep created");
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep: offscreenRep]];
        //NSGraphicsContext *context = [NSGraphicsContext currentContext];
        
        //[NSGraphicsContext saveGraphicsState];
        
        //because the view isn't flipped.
        NSAffineTransform* xform = [NSAffineTransform transform];
        [xform translateXBy:0.0 yBy: offscreenRect.size.height];
        [xform scaleXBy:1.0 yBy:-1.0];
        [xform concat];
        
        [NSGraphicsContext saveGraphicsState];
        
        
        //xform = [NSAffineTransform transform];
        //[xform translateXBy:0.0 yBy: -offscreenRect.size.height / 0.5];
        //[xform concat];
        //yTrans = rect.size.height;
        
        //NSLog(@"Making Bitmap Rep. Context: %@ (%d)", context,[context isFlipped]);
        
        
        //[offscreenImage lockFocus];
        NSBezierPath *bpath = [NSBezierPath bezierPathWithRect:offscreenRect];
        [[NSColor yellowColor] set];
        [bpath fill];
        
        xform = [NSAffineTransform transform];
        [xform translateXBy:offscreenRect.size.height * 0.7 yBy: offscreenRect.size.height * -2.0];
        [xform concat];
        
        [self drawMotif: motif rect: offscreenRect offset: 0];
        [NSGraphicsContext restoreGraphicsState];
        //[offscreenImage unlockFocus];
        //[NSGraphicsContext restoreGraphicsState];
        
        [NSGraphicsContext restoreGraphicsState];
        //[offscreenImage release];
        
        //NSData *pngData = [offscreenRep representationUsingType:NSPNGFileType properties: nil];
        //[pngData writeToFile:@"/Users/mp4/Desktop/foo.png" atomically:NO];

    } else {
        //NSLog(@"ERROR: could not create offscreen rep for drawing the motif");
    }
    
    return offscreenRep;
    
}


/*
-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView*) controlView {
    
}
 */

/* If the subclass contains instance variables that 
 hold pointers to objects, consider overriding 
 copyWithZone: to duplicate the objects. 
 The default version copies only pointers to the objects.*/

#pragma mark Event handling

/*
- (BOOL) acceptsFirstResponder {
    PCLog(@"MotifViewCell: accepting first responder");
    return YES;
}

- (BOOL) resignFirstResponder {
    PCLog(@"MotifViewCell: resigning first responder");
    return YES;
}

- (BOOL) becomeFirfgfstResponder {
    PCLog(@"MotifViewCell: becoming first responder");
    return YES;
}*/

/*
- (BOOL)startTrackingAt:(NSPoint)startPoint 
                 inView:(NSView *)controlView {
    PCLog(@"MotifViewCell: start tracking at (%g,%g)",startPoint.x,startPoint.y);
    return YES;
}

- (BOOL)continueTrackingAt:(NSPoint)point 
                    inView:(NSView *)controlView {
    PCLog(@"MotifViewCell: continue tracking at (%g,%g)", point.x,point.y);
    return YES;
}

- (void)stopTracking:(NSPoint)lastPoint 
                  at:(NSPoint)stopPoint 
              inView:(NSView *)controlView 
           mouseIsUp:(BOOL)mouseWentUp {
    PCLog(@"MotifViewCell: stop tracking at point (%g,%g),stop point=(%g,%g), mouseIsUp=%d",
          lastPoint.x,lastPoint.y,
          stopPoint.x,stopPoint.y,
          mouseWentUp);
    if (mouseWentUp) {
        PCLog(@"MotifViewCell: stopped tracking because of mouse button going up.");
    } else {
        
        PCLog(@"MotifViewCell: stopped tracking because of mouse going outside the cell.");
    }
    return;
}*/

-(void) setColumnDisplayOffset:(NSInteger) i {
    NSLog(@"Column display offset changed to %d", i);
    columnDisplayOffset = i;
}

@end
