//
//  MotifViewCell.m
//  iMotifs
//
//  Created by Matias Piipari on 30/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <MotifViewCell.h>

@interface MotifViewCell (Private)
- (void) drawMotif:(NSRect)rect 
    inControlView:(NSView*)controlView;
- (void) drawConsensus:(NSRect)rect 
        inControlView:(NSView*)controlView;
+ (NSMutableAttributedString*) makeSymbolDrawable:(Symbol*)sym 
                                          ofSize:(CGFloat)size 
                                         ofColor:(NSColor*) color;
+ (NSMutableAttributedString*) infoContentStringForMotif:(Motif*) motif;
+ (NSMutableAttributedString*) scoreThresholdStringForMotif:(Motif*) motif;
- (NSRect) measureString:(NSString*)str inRect:(NSRect)rect;
@end

NSString *IMLogoFontName = @"Arial Bold";

@implementation MotifViewCell
@synthesize drawingStyle;
@synthesize columnDisplayOffset;
@synthesize columnWidth;
@synthesize showInformationContent;
@synthesize showScoreThreshold;


- (void) awakeFromNib {
    [super awakeFromNib];
    NSLog(@"MotifViewCell: awakening from Nib");
}

/* the designated initializer for cells that contain images */
- (id) initImageCell:(NSImage*) image {
    NSLog(@"MotifViewCell: initialising motif view image cell");
    self = [super initImageCell:image];
    if (self != nil) {
        [self setDrawingStyle: IMInfoScaledLogo];
        [self setColumnDisplayOffset: IMLeftColPadding];
        [self setColumnWidth: IMDefaultColWidth];
        [self setShowInformationContent: NO];
    }
    return self;
}

/* the designated initializer for cells that contain text */
- (id) initTextCell:(NSString*) str {
    NSLog(@"MotifViewCell: initialising motif view text cell");
    self = [super initTextCell:str];
    if (self != nil) {
        [self setDrawingStyle:IMInfoScaledLogo];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    NSLog(@"MotifViewCell: initWithCoder");
    self = [super initWithCoder:coder];
    drawingStyle = [coder decodeIntegerForKey: @"drawingStyle"];
    columnDisplayOffset = [coder decodeIntegerForKey: @"columnDisplayOffset"];
    columnWidth = [coder decodeFloatForKey:@"columnWidth"];
    showInformationContent = [coder decodeBoolForKey:@"showInformationContent"];
    showScoreThreshold = [coder decodeBoolForKey:@"showScoreThreshold"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    NSLog(@"MotifViewCell: encodeWithCoder");
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
}

- (id)copyWithZone:(NSZone *)zone {
    //NSLog(@"MotifViewCell: copying %@",self);
    MotifViewCell *cellCopy = NSCopyObject(self, 0, zone);
    [[self objectValue] retain];
    [cellCopy setObjectValue: [self objectValue]];
    [cellCopy setImage:[self image]];
    [cellCopy setColumnWidth: [self columnWidth]];
    [cellCopy setColumnDisplayOffset: [self columnDisplayOffset]];
    [cellCopy setDrawingStyle: [self drawingStyle]];
    [cellCopy setShowInformationContent: [self showInformationContent]];
    [cellCopy setShowScoreThreshold: [self showScoreThreshold]];
        
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
    //    NSLog(@"MotifViewCell: color not set for %@.",[[self objectValue] name]);
    //    [[NSColor controlBackgroundColor] set];
    //} else {
    //    NSLog(@"MotifViewCell: color set for %@.",[[self objectValue] name]);
    //    [[[self objectValue] color] set];
    //}
    //[[NSColor controlAlternatingRowBackgroundColors
    //NSLog(@"MotifViewCell: color for %@.",[[self objectValue] color]);
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
    [self drawMotif: cellFrame 
      inControlView: controlView];
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

- (NSInteger) calcFittingColumnCountInRect:(NSRect)rect {
    return (NSInteger)round(rect.size.width / [self columnWidth]);
}

- (NSInteger) calcLeftPaddingColumns:(NSRect)rect {
    //NSLog(@"MotifViewCell: fitting columns=%d , displayOffset=%d",[self calcFittingColumnCountInRect:rect],[self columnDisplayOffset]);
    NSInteger extraCols = [self calcFittingColumnCountInRect:rect] - [self columnDisplayOffset];
    if (extraCols > 0) {
        return extraCols / 2;
    } else return 0;
}

- (NSRect) measureString:(NSString*)str inRect:(NSRect)rect {
    //NSLog(@"MotifViewCell: measuring string %@ (%@)",str, [str className]);
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
                         range:range];
    
    return [nameDrawable autorelease]; 
}

+ (NSMutableAttributedString*) infoContentStringForMotif:(Motif*) motif {
    NSMutableAttributedString* infoStr = [[NSMutableAttributedString alloc] 
                                               initWithString: 
                                               [NSString stringWithFormat:@"%.3g bits",[motif informationContent]]];
    
    NSRange range = NSMakeRange(0,[infoStr length]);
    [infoStr addAttribute: NSFontAttributeName
                         value: [NSFont userFontOfSize:12.0]
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
                    value: [NSFont userFontOfSize:12.0]
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

- (double) letterXTransformation:(NSString*) str
                          inRect:(NSRect)rect{
    //NSLog(@"MotifViewCell: letter X transformation for %@", str);
    NSRect meas = [self measureString:str inRect:rect];
    return (rect.size.height / meas.size.height) * (double)meas.size.width;
}

- (double) letterYTransformation:(NSString*)str 
                          inRect:(NSRect)rect {
    //NSLog(@"MotifViewCell: letter Y transformation for %@", str);
    NSRect meas = [self measureString:str inRect:rect];
    return (rect.size.height / meas.size.height);
}

- (void) drawConsensus:(NSRect)rect inBounds:(NSRect) bounds {
    NSString* consensus = [[self objectValue] consensusString];
    //NSLog(@"MotifViewCell: drawing consensus \"%@\"", consensus);
    
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
    
    [s drawInRect: bounds];
    [s release];
    s = nil;
}


+ (void) drawLogoForMotif:(Motif*)motif 
                   inRect:(NSRect)rect scaleByInformationContent:(BOOL)scaleByInfo 
                  flipped:(BOOL) flipped
               withOffset:(NSInteger)colOffset {
    //NSLog(@"MotifViewCell: drawing logo for objectValue=%@ (objectValue=%@)",[self objectValue], [self objectValue]);
    int colCount = [motif columnCount];
    int i;
    NSPoint point;
    point.x = 0;
    point.y = 0;
    
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
        [context saveGraphicsState];
        
        Multinomial *col = [motif column:i];
        NSArray *syms = [col symbolsWithWeightsInDescendingOrder];
        double colScale;
        
        double informationContent, totalBits;
        informationContent = [col informationContent];
        totalBits = [col totalBits];
        
        colScale = scaleByInfo ? informationContent/totalBits : 1.0;
        
        NSAffineTransform *transMove = [NSAffineTransform transform];
        
        CGFloat xTrans = wantedWidth * i + wantedWidth * [motif offset];
        CGFloat yTrans = 0.0;
        
        if (flipped) {
            yTrans = rect.size.height;
        }
        
        [transMove translateXBy:xTrans
                            yBy:yTrans];
        [transMove concat];
        CGFloat accumMove = 0;
        
        for (Symbol *sym in syms) {
            double w = [col weightForSymbol:sym];
            
            [context saveGraphicsState];
            
            NSMutableAttributedString *nameDrawable = [MotifViewCell makeSymbolDrawable:sym 
                                                                        ofSize:rect.size.height 
                                                                       ofColor:nil];
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
            [letterTransform translateXBy:0.0
                                       yBy:accumMove];
            [letterTransform scaleXBy: (wantedWidth/symMeas.size.width)
                                  yBy: scaleYRatio];
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
            [context restoreGraphicsState];
        }
        
        [context restoreGraphicsState];
    }
    [context restoreGraphicsState];
}

- (void) drawMotif:(NSRect)rect inControlView:(NSView*)controlView {
    NSRect insetRect = NSInsetRect(rect, IMMotifMargin, IMMotifMargin);
    if ([self drawingStyle] == IMConsensus) {
        [self drawConsensus:insetRect inControlView:controlView];
    } else if ([self drawingStyle] == IMLogo) {
        [MotifViewCell drawLogoForMotif:[self objectValue]
                                 inRect:insetRect scaleByInformationContent:NO 
                                flipped:YES 
                             withOffset:[self calcLeftPaddingColumns:rect]];
    } else if ([self drawingStyle] == IMInfoScaledLogo) {
        [MotifViewCell drawLogoForMotif:[self objectValue] 
                                 inRect:insetRect scaleByInformationContent:YES 
                                flipped:YES 
                             withOffset:[self calcLeftPaddingColumns:rect]];
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
    NSLog(@"MotifViewCell: accepting first responder");
    return YES;
}

- (BOOL) resignFirstResponder {
    NSLog(@"MotifViewCell: resigning first responder");
    return YES;
}

- (BOOL) becomeFirfgfstResponder {
    NSLog(@"MotifViewCell: becoming first responder");
    return YES;
}*/

/*
- (BOOL)startTrackingAt:(NSPoint)startPoint 
                 inView:(NSView *)controlView {
    NSLog(@"MotifViewCell: start tracking at (%g,%g)",startPoint.x,startPoint.y);
    return YES;
}

- (BOOL)continueTrackingAt:(NSPoint)point 
                    inView:(NSView *)controlView {
    NSLog(@"MotifViewCell: continue tracking at (%g,%g)", point.x,point.y);
    return YES;
}

- (void)stopTracking:(NSPoint)lastPoint 
                  at:(NSPoint)stopPoint 
              inView:(NSView *)controlView 
           mouseIsUp:(BOOL)mouseWentUp {
    NSLog(@"MotifViewCell: stop tracking at point (%g,%g),stop point=(%g,%g), mouseIsUp=%d",
          lastPoint.x,lastPoint.y,
          stopPoint.x,stopPoint.y,
          mouseWentUp);
    if (mouseWentUp) {
        NSLog(@"MotifViewCell: stopped tracking because of mouse button going up.");
    } else {
        
        NSLog(@"MotifViewCell: stopped tracking because of mouse going outside the cell.");
    }
    return;
}*/

@end
