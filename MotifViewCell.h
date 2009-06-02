//
//  MotifViewCell.h
//  iMotifs
//
//  Created by Matias Piipari on 30/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Motif.h>

#ifndef IMDefaultNameWidth
#define IMDefaultNameWidth (CGFloat)100.0
#endif

#ifndef IMLeftColPadding
#define IMLeftColPadding (NSInteger)2
#endif

#ifndef IMDefaultColWidth
#define IMDefaultColWidth (CGFloat)40.0
#endif

#ifndef IMDefaultColHeight
#define IMDefaultColHeight (CGFloat)60.0
#endif

#ifndef IMMotifMargin
#define IMMotifMargin (CGFloat)4.0
#endif

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
    BOOL showInformationContent;
    BOOL showScoreThreshold;
    BOOL showLength;
    
    IMMotifColumnPrecisionDrawingStyle columnPrecisionDrawingStyle;
    CGFloat confidenceIntervalCutoff;
}

@property (readwrite) MotifDrawingStyle drawingStyle;
@property (readwrite) NSInteger columnDisplayOffset;
@property (readwrite) CGFloat columnWidth;
@property (readwrite) BOOL showInformationContent;
@property (readwrite) BOOL showScoreThreshold;
@property (readwrite) BOOL showLength;
@property (readwrite) CGFloat confidenceIntervalCutoff;
@property (readwrite) IMMotifColumnPrecisionDrawingStyle columnPrecisionDrawingStyle;

- (NSInteger) calcFittingColumnCountInRect:(NSRect)rect;

+ (void) drawLogoForMotif:(Motif*)motif 
                   inRect:(NSRect)rect 
scaleByInformationContent:(BOOL)scaleByInfo 
                  flipped:(BOOL) flipped
               withOffset:(NSInteger)colOffset;

+ (void) drawLogoForMotif: (Motif*)motif 
                   inRect: (NSRect)rect 
scaleByInformationContent: (BOOL)scaleByInfo 
                  flipped: (BOOL) flipped
               withOffset: (NSInteger)colOffset
    minConfidenceInterval: (CGFloat) minInterval
    maxConfidenceInterval: (CGFloat) maxInterval
    precisionDrawingStyle: (IMMotifColumnPrecisionDrawingStyle) precStyle;

+ (void)        drawColumn: (NSUInteger) i 
                   ofMotif: (Motif*) motif
                    inRect: (NSRect) rect
 scaleByInformationContent: (BOOL) scaleByInfo
                   flipped: (BOOL) flipped 
                withOffset: (NSInteger) offset
     minConfidenceInterval: (CGFloat) minInterval
     maxConfidenceInterval: (CGFloat) maxInterval
     precisionDrawingStyle: (IMMotifColumnPrecisionDrawingStyle) precStyle;


- (void) drawMotif:(Motif*) m
			  rect:(NSRect) rect 
	   controlView:(NSView*) controlView;

+ (NSMutableAttributedString*) infoContentStringForMotif:(Motif*) motif;
+ (NSMutableAttributedString*) scoreThresholdStringForMotif:(Motif*) motif;
+ (NSMutableAttributedString*) lengthStringForMotif:(Motif*) motif;
@end
