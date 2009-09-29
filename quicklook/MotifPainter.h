//
//  MotifPainter.h
//  MotifQuickLook
//
//  Created by Matias Piipari on 16/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MotifViewCell.h>
#import <MotifSet.h>

#ifndef IMMotifNameFontWidth
#define IMMotifNameFontWidth (CGFloat)15.0
#endif

#ifndef IMQuickLoockMaxMotifsPerPage
#define IMQuickLoockMaxMotifsPerPage (NSInteger)50
#endif

@interface MotifPainter : NSObject {

}

+ (void) drawMotifSet:(MotifSet*)motifSet 
                 rect:(NSRect)msetRect
              context:(NSGraphicsContext*)context;
@end
