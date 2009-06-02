//
//  MotifViewCell.m
//  iMotifs
//
//  Created by Matias Piipari on 30/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <MotifViewCell.h>
#import "Metamotif.h"
#import "Dirichlet.h"
#import "DistributionBounds.h"
#import "SymbolBounds.h"

@interface MotifViewCell (Private)
- (void) drawConsensus: (Motif*)m 
				  rect: (NSRect)rect 
           controlView: (NSView*)controlView;
+ (NSMutableAttributedString*) makeSymbolDrawable:(Symbol*)sym 
                                          ofSize:(CGFloat)size 
                                         ofColor:(NSColor*) color;
- (NSRect) measureString:(NSString*)str inRect:(NSRect)rect;
@end

NSString *IMMotifSetPboardType = @"net.piipari.motifset.pasteboard";
NSString *IMMotifSetIndicesPboardType = @"net.piipari.motifset.indices.pasteboard";

NSString *IMLogoFontName = @"Arial Bold";

@implementation MotifViewCell
@synthesize drawingStyle;
@synthesize columnDisplayOffset;
@synthesize columnWidth;
@synthesize showInformationContent,showScoreThreshold,showLength;
@synthesize confidenceIntervalCutoff;
@synthesize columnPrecisionDrawingStyle;

- (void) awakeFromNib {
    [super awakeFromNib];
    DebugLog(@"MotifViewCell: awakening from Nib");
}

/* the designated initializer for cells that contain images */
- (id) initImageCell:(NSImage*) image {
    DebugLog(@"MotifViewCell: initialising motif view image cell");
    self = [super initImageCell:image];
    if (self != nil) {
        [self setDrawingStyle: IMInfoScaledLogo];
        [self setColumnDisplayOffset: IMLeftColPadding];
        [self setColumnWidth: IMDefaultColWidth];
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
    DebugLog(@"MotifViewCell: initialising motif view text cell");
    self = [super initTextCell:str];
    if (self != nil) {
        [self setDrawingStyle:IMInfoScaledLogo];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    DebugLog(@"MotifViewCell: initWithCoder");
    self = [super initWithCoder:coder];
    drawingStyle = [coder decodeIntegerForKey: @"drawingStyle"];
    columnDisplayOffset = [coder decodeIntegerForKey: @"columnDisplayOffset"];
    columnWidth = [coder decodeFloatForKey:@"columnWidth"];
    showInformationContent = [coder decodeBoolForKey:@"showInformationContent"];
    showScoreThreshold = [coder decodeBoolForKey:@"showScoreThreshold"];
    showLength = [coder decodeBoolForKey:@"showLength"];
    confidenceIntervalCutoff = [coder decodeFloatForKey:@"confidenceIntervalCutoff"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    DebugLog(@"MotifViewCell: encodeWithCoder");
    [super encodeWithCoder:coder];
    [coder encodeInteger: [self drawingStyle] 
                  forKey: @"drawingStyle"];
    [coder encodeInteger: [self columnDisplayOffset] 
                  forKey: @"columnDisplayOffset"];
    [coder encodeFloat: [self columnWidth] 
                         forKey: @"columnWidth"];
    [coder encodeBool: showInformationContent 
               forKey: @"showInformationContent"];
    [coder encodeBool: showScoreThreshold
               forKey: @"showScoreThreshold"];
    [coder encodeBool: showLength 
               forKey: @"showLength"];
    [coder encodeFloat: confidenceIntervalCutoff 
                forKey: @"confidenceIntervalCutoff"];
}

- (id)copyWithZone:(NSZone *)zone {
    //DebugLog(@"MotifViewCell: copying %@",self);
    MotifViewCell *cellCopy = NSCopyObject(self, 0, zone);
    [[self objectValue] retain];
    [cellCopy setObjectValue: self.objectValue];
    [cellCopy setImage: self.image];
    [cellCopy setColumnWidth: self.columnWidth];
    [cellCopy setColumnDisplayOffset: self.columnDisplayOffset];
    [cellCopy setDrawingStyle: self.drawingStyle];
    [cellCopy setShowInformationContent: self.showInformationContent];
    [cellCopy setShowScoreThreshold: self.showScoreThreshold];
    [cellCopy setShowLength: self.showLength];
    [cellCopy setConfidenceIntervalCutoff: self.confidenceIntervalCutoff];
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
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
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

- (NSInteger) calcFittingColumnCountInRect:(NSRect)rect {
    return (NSInteger)round(rect.size.width / [self columnWidth]);
}

- (NSInteger) calcLeftPaddingColumns:(NSRect)rect {
    //DebugLog(@"MotifViewCell: fitting columns=%d , displayOffset=%d",[self calcFittingColumnCountInRect:rect],[self columnDisplayOffset]);
    NSInteger extraCols = [self calcFittingColumnCountInRect:rect] - [self columnDisplayOffset];
    if (extraCols > 0) {
        return extraCols / 2;
    } else return 0;
}

- (NSRect) measureString:(NSString*)str inRect:(NSRect)rect {
    //DebugLog(@"MotifViewCell: measuring string %@ (%@)",str, [str className]);
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
    //DebugLog(@"MotifViewCell: letter X transformation for %@", str);
    NSRect meas = [self measureString:str inRect:rect];
    return (rect.size.height / meas.size.height) * (double)meas.size.width;
}

- (double) letterYTransformation:(NSString*)str 
                          inRect:(NSRect)rect {
    //DebugLog(@"MotifViewCell: letter Y transformation for %@", str);
    NSRect meas = [self measureString:str inRect:rect];
    return (rect.size.height / meas.size.height);
}

- (void) drawConsensus:(Motif*) motif 
                  rect:(NSRect) rect
           controlView:(NSView*) view {
    NSString* consensus = [[self objectValue] consensusString];
    //DebugLog(@"MotifViewCell: drawing consensus \"%@\"", consensus);
    
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

+ (void) drawLogoForMotif:(Motif*)motif 
                   inRect:(NSRect)rect 
scaleByInformationContent:(BOOL)scaleByInfo 
                  flipped:(BOOL) flipped
               withOffset:(NSInteger)colOffset {
    return [MotifViewCell drawLogoForMotif: motif 
                                    inRect: rect 
                 scaleByInformationContent: scaleByInfo 
                                   flipped: flipped
                                withOffset: colOffset
                     minConfidenceInterval: 0.05
                     maxConfidenceInterval: 0.95
                     precisionDrawingStyle: IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol];
}

+ (void)   drawLogoForMotif: (Motif*)motif 
                     inRect: (NSRect)rect 
  scaleByInformationContent: (BOOL)scaleByInfo 
                    flipped: (BOOL) flipped
                 withOffset: (NSInteger)colOffset
      minConfidenceInterval: (CGFloat) minInterval
      maxConfidenceInterval: (CGFloat) maxInterval
      precisionDrawingStyle: (IMMotifColumnPrecisionDrawingStyle) precStyle {
    //DebugLog(@"MotifViewCell: drawing logo for objectValue=%@ (objectValue=%@)",[self objectValue], [self objectValue]);
    int colCount = [motif columnCount];
    int i;
    NSPoint point;
    point.x = 0;
    point.y = 0;
    
    //BOOL isMetaMotif = [motif isKindOfClass:[Metamotif class]];
    //DebugLog(@"Drawing logo for %@ (%@)", motif, motif.className);
    
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    
    NSMutableAttributedString *aLetter = [[NSMutableAttributedString alloc] 
                                          initWithString: @"A"];
    
    [aLetter addAttribute: NSFontAttributeName
                    value: [NSFont fontWithName:IMLogoFontName size:rect.size.height]
                    range:NSMakeRange(0,1)];
    
    //double wantedWidth = rect.size.width / 20;
    CGFloat wantedWidth = IMDefaultColWidth;

    [context saveGraphicsState];
    
    NSAffineTransform *offsetTransform = [NSAffineTransform transform];
    [offsetTransform translateXBy:colOffset*wantedWidth 
                              yBy:0.0];
    [offsetTransform concat];
    
    for (i = 0; i < colCount; i++) {
        
        if ([motif isKindOfClass:[Metamotif class]] && 
            (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsFuzzyMotif)) {
            
            int r = 0;
            for (r = 0; r < 100; r++) {
                [MotifViewCell drawColumn: i
                                  ofMotif: motif
                                   inRect: rect
                scaleByInformationContent: scaleByInfo
                                  flipped: flipped 
                               withOffset: colOffset
                    minConfidenceInterval: minInterval
                    maxConfidenceInterval: maxInterval
                    precisionDrawingStyle: precStyle];                
            }
        } else {
            [MotifViewCell drawColumn: i
                              ofMotif: motif
                               inRect: rect
            scaleByInformationContent: scaleByInfo
                              flipped: flipped 
                           withOffset: colOffset
                minConfidenceInterval: minInterval
                maxConfidenceInterval: maxInterval
                precisionDrawingStyle: precStyle];
        }

    }
    [context restoreGraphicsState];
}
        

+ (void)        drawColumn: (NSUInteger) i 
                   ofMotif: (Motif*) motif
                    inRect: (NSRect) rect
 scaleByInformationContent: (BOOL) scaleByInfo
                   flipped: (BOOL) flipped 
                withOffset: (NSInteger) offset
     minConfidenceInterval: (CGFloat) minInterval
     maxConfidenceInterval: (CGFloat) maxInterval
     precisionDrawingStyle: (IMMotifColumnPrecisionDrawingStyle) precStyle {
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
    
    NSArray *syms = [col symbolsWithWeightsInDescendingOrder];
    double colScale;
    
    double informationContent, totalBits;
    informationContent = [col informationContent];
    totalBits = [col totalBits];
    
    colScale = scaleByInfo ? informationContent/totalBits : 1.0;
    
    NSAffineTransform *transMove = [NSAffineTransform transform];
    
    CGFloat wantedWidth = IMDefaultColWidth;

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
                                              alpha: 0.05];
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
         */
        
        /*
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
            
            if (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsFromBottomToTop) {
                minSymBound = NSMakeRect(pointLB.x + ((3.0 - (CGFloat)symNum) * symMeas.size.width * 0.25),
                                         pointLB.y + symMeas.size.height / sizeRatio, 
                                         symMeas.size.width * 0.25,
                                         -((symB.min / w) * (symMeas.size.height / sizeRatio) * 0.74));
            } else if (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol) {
                minSymBound = NSMakeRect(pointLB.x + (symMeas.size.width * 0.25),
                                         (pointLB.y + symMeas.size.height / sizeRatio) + (-((symB.min / w) * (symMeas.size.height / sizeRatio) * 0.74)), 
                                         symMeas.size.width * 0.50,
                                         3.0 * (1.0 / w));
            }
            
            NSBezierPath *minbpath = [NSBezierPath bezierPathWithRect: minSymBound];
            
            [[NSColor colorWithCalibratedRed: [[sym defaultFillColor] redComponent] * 0.35 
                                       green: [[sym defaultFillColor] greenComponent] * 0.35 
                                        blue: [[sym defaultFillColor] blueComponent] * 0.35
                                       alpha: 0.8] set];
            
            [minbpath setLineWidth: 3.0];
            [minbpath fill];
            [minbpath stroke];
            
            [[NSColor colorWithCalibratedRed: [[sym defaultFillColor] redComponent] * 0.55 
                                       green: [[sym defaultFillColor] greenComponent] * 0.55
                                        blue: [[sym defaultFillColor] blueComponent] * 0.55
                                       alpha: 0.8] set];
            
            NSRect maxSymBound;
            
            if (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsFromBottomToTop) {
                maxSymBound = NSMakeRect(pointLB.x + ((3.0 - (CGFloat)symNum) * symMeas.size.width * 0.25),
                                         pointLB.y + symMeas.size.height / sizeRatio, 
                                         symMeas.size.width * 0.25,
                                         -((symB.max / w) * (symMeas.size.height / sizeRatio) * 0.74));
            } else if (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol) {
                maxSymBound = NSMakeRect(pointLB.x + symMeas.size.width * 0.25,
                                         (pointLB.y + symMeas.size.height / sizeRatio) +(-((symB.max / w) * (symMeas.size.height / sizeRatio) * 0.74)), 
                                         symMeas.size.width * 0.50,
                                         3.0 * (1.0 / w));
            }
            
            if (precStyle == IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol) {
                NSBezierPath *upBarPath = [NSBezierPath bezierPath];
                [upBarPath setLineWidth: 3.0];
                [upBarPath moveToPoint: NSMakePoint(pointLB.x + symMeas.size.width * 0.50, pointLB.y)];
                [upBarPath moveToPoint: NSMakePoint(pointLB.x + symMeas.size.width * 0.50, 
                                                    (pointLB.y + symMeas.size.height / sizeRatio) +(-((symB.max / w) * (symMeas.size.height / sizeRatio) * 0.74)))];
                [upBarPath stroke];
            }
            
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
        

- (void) drawMotif: (Motif*) m
			  rect: (NSRect)rect 
	   controlView: (NSView*)controlView {
    NSRect insetRect = NSInsetRect(rect, IMMotifMargin, IMMotifMargin);
    if ([self drawingStyle] == IMConsensus) {
        [self drawConsensus: (Motif*) m 
					   rect: insetRect 
				controlView: controlView];
    } else if ([self drawingStyle] == IMLogo) {
        [MotifViewCell drawLogoForMotif: [self objectValue]
                                 inRect: insetRect 
              scaleByInformationContent: NO 
                                flipped: YES 
                             withOffset: [self calcLeftPaddingColumns:rect]
                  minConfidenceInterval: 1.0 - [self confidenceIntervalCutoff]
                  maxConfidenceInterval: [self confidenceIntervalCutoff]
                  precisionDrawingStyle: [self columnPrecisionDrawingStyle]];
    } else if ([self drawingStyle] == IMInfoScaledLogo) {
        [MotifViewCell drawLogoForMotif: [self objectValue] 
                                 inRect: insetRect 
              scaleByInformationContent: YES 
                                flipped: YES 
                             withOffset: [self calcLeftPaddingColumns:rect]
                  minConfidenceInterval: 1.0 - [self confidenceIntervalCutoff]
                  maxConfidenceInterval: [self confidenceIntervalCutoff]
                  precisionDrawingStyle: [self columnPrecisionDrawingStyle]];
    }
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
    DebugLog(@"MotifViewCell: accepting first responder");
    return YES;
}

- (BOOL) resignFirstResponder {
    DebugLog(@"MotifViewCell: resigning first responder");
    return YES;
}

- (BOOL) becomeFirfgfstResponder {
    DebugLog(@"MotifViewCell: becoming first responder");
    return YES;
}*/

/*
- (BOOL)startTrackingAt:(NSPoint)startPoint 
                 inView:(NSView *)controlView {
    DebugLog(@"MotifViewCell: start tracking at (%g,%g)",startPoint.x,startPoint.y);
    return YES;
}

- (BOOL)continueTrackingAt:(NSPoint)point 
                    inView:(NSView *)controlView {
    DebugLog(@"MotifViewCell: continue tracking at (%g,%g)", point.x,point.y);
    return YES;
}

- (void)stopTracking:(NSPoint)lastPoint 
                  at:(NSPoint)stopPoint 
              inView:(NSView *)controlView 
           mouseIsUp:(BOOL)mouseWentUp {
    DebugLog(@"MotifViewCell: stop tracking at point (%g,%g),stop point=(%g,%g), mouseIsUp=%d",
          lastPoint.x,lastPoint.y,
          stopPoint.x,stopPoint.y,
          mouseWentUp);
    if (mouseWentUp) {
        DebugLog(@"MotifViewCell: stopped tracking because of mouse button going up.");
    } else {
        
        DebugLog(@"MotifViewCell: stopped tracking because of mouse going outside the cell.");
    }
    return;
}*/

@end
