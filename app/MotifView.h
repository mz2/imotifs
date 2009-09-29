//
//  MotifView.h
//  iMotif
//
//  Created by Matias Piipari on 26/06/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Motif.h>

@interface MotifView : NSControl {
    NSColor *bgColor;
    IBOutlet Motif* motif;
    NSInteger columnDisplayOffset;
    //MotifDrawingStyle drawingStyle;
}
@property (retain, readwrite) NSColor* bgColor;
@property (retain, readwrite) Motif* motif;
@property (readwrite) NSInteger columnDisplayOffset;
//@property (readwrite) MotifDrawingStyle drawingStyle;


@end
