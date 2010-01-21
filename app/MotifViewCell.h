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
//  MotifViewCell.h
//  iMotifs
//
//  Created by Matias Piipari on 30/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Motif.h>

extern CGFloat const IMDefaultNameWidth;
extern NSInteger const IMLeftColPadding;
extern CGFloat const IMDefaultColWidth;
extern CGFloat const IMDefaultColHeight;
extern CGFloat const IMMotifMargin;

typedef enum MotifDrawingStyle {
    IMNone  = 0,
    IMConsensus = 1,
    IMLogo = 2,
    IMInfoScaledLogo = 3 
} MotifDrawingStyle;

typedef enum IMMotifColumnPrecisionDrawingStyle {
    IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol = 0,
    IMMotifColumnPrecisionDrawingStyleErrorBarsFromBottomToTop = 1,
    IMMotifColumnPrecisionDrawingStyleErrorBarsFuzzyMotif = 2
} IMMotifColumnPrecisionDrawingStyle;

extern NSString *IMMotifSetPboardType;
extern NSString *IMMotifSetIndicesPboardType;


@interface MotifViewCell : NSActionCell <NSCopying> {
    MotifDrawingStyle drawingStyle;
    NSInteger columnDisplayOffset;
    CGFloat columnWidth;
    CGFloat columnHeight;
    BOOL showInformationContent;
    BOOL showScoreThreshold;
    BOOL showLength;
    
    IMMotifColumnPrecisionDrawingStyle columnPrecisionDrawingStyle;
    CGFloat confidenceIntervalCutoff;
}

@property (readwrite) MotifDrawingStyle drawingStyle;
@property (readwrite) NSInteger columnDisplayOffset;
@property (readwrite) CGFloat columnWidth;
@property (readwrite) CGFloat columnHeight;
@property (readwrite) BOOL showInformationContent;
@property (readwrite) BOOL showScoreThreshold;
@property (readwrite) BOOL showLength;
@property (readwrite) CGFloat confidenceIntervalCutoff;
@property (readwrite) IMMotifColumnPrecisionDrawingStyle columnPrecisionDrawingStyle;

- (NSInteger) calcFittingColumnCountInRect:(NSRect)rect;

+ (void) drawLogoForMotif:(Motif*)motif 
                   inRect:(NSRect)rect 
              columnWidth: (CGFloat) wantedWidth
scaleByInformationContent:(BOOL)scaleByInfo 
                  flipped:(BOOL) flipped
               withOffset:(NSInteger)colOffset;

+ (void) drawLogoForMotif: (Motif*)motif 
                   inRect: (NSRect)rect 
              columnWidth: (CGFloat) wantedWidth
scaleByInformationContent: (BOOL)scaleByInfo 
                  flipped: (BOOL) flipped
               withOffset: (NSInteger)colOffset
    minConfidenceInterval: (CGFloat) minInterval
    maxConfidenceInterval: (CGFloat) maxInterval
    precisionDrawingStyle: (IMMotifColumnPrecisionDrawingStyle) precStyle;

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
            symbolsOrdered: (NSArray*) orderedSymbols;


- (void) drawMotif:(Motif*) m
			  rect:(NSRect) rect
            offset:(NSInteger) offset;

-(NSBitmapImageRep*) makeBitmapImageRepForMotif:(Motif*) motif;

+ (NSMutableAttributedString*) infoContentStringForMotif:(Motif*) motif;
+ (NSMutableAttributedString*) scoreThresholdStringForMotif:(Motif*) motif;
+ (NSMutableAttributedString*) lengthStringForMotif:(Motif*) motif;
@end
