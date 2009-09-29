//
//  MotifPainter.m
//  MotifQuickLook
//
//  Created by Matias Piipari on 16/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <MotifPainter.h>
#import <MotifSet.h>
#import <MotifViewCell.h>


@implementation MotifPainter

+ (void) drawMotifSet:(MotifSet*)motifSet 
                 rect:(NSRect)msetRect
              context:(NSGraphicsContext*)context {
    int mI;
    CGFloat x,y;
    x=0.0;
    y=0.0;
    
    NSAffineTransform* xform = [NSAffineTransform transform];
    [xform translateXBy:0.0 yBy:msetRect.size.height];
    [xform scaleXBy:1.0 yBy:-1.0];
    [xform concat];
    
    for (mI = 0; mI < [motifSet count]; mI++) {
        [context saveGraphicsState];
        Motif *m = [motifSet motifWithIndex:mI];
        
        NSRect rect = NSMakeRect(0.0, 
                                 0.0, 
                                 msetRect.size.width, 
                                 IMDefaultColHeight);
        NSRect nameRect = NSMakeRect(15.0, 
                                     10.0, 
                                     msetRect.size.width, 
                                     IMDefaultColHeight);
        
        NSAffineTransform *moveTrans = [NSAffineTransform transform];
        [moveTrans translateXBy:0.0 
                            yBy:y*0.98];
        [moveTrans concat];
        
        NSMutableAttributedString* nameDrawable = [[NSMutableAttributedString alloc] 
                                                   initWithString: [m name]];
        
        NSRange range = NSMakeRange(0,[nameDrawable length]);
        [nameDrawable addAttribute: NSFontAttributeName
                             value: [NSFont userFontOfSize:IMMotifNameFontWidth]
                             range: range];
        [nameDrawable applyFontTraits:NSBoldFontMask 
                                range:NSMakeRange(0, [nameDrawable length])];
        [nameDrawable addAttribute: NSForegroundColorAttributeName 
                             value: [NSColor blackColor] 
                             range:range];
        
        [nameDrawable drawInRect: nameRect];
        [MotifViewCell drawLogoForMotif: m 
                                 inRect: rect 
                            columnWidth: 30.0
              scaleByInformationContent: YES 
                                flipped: YES 
                             withOffset: 5 
                  minConfidenceInterval: 5.0 
                  maxConfidenceInterval: 95.0 
                  precisionDrawingStyle: IMMotifColumnPrecisionDrawingStyleErrorBarsTopOfSymbol];
        
        /*
        [MotifViewCell drawLogoForMotif: m
                                 inRect: rect
              scaleByInformationContent: YES 
                                flipped: YES 
                             withOff 5];
        */
        y += IMDefaultColHeight;
        [context restoreGraphicsState];
    }
}
@end
