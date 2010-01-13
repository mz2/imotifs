//
//  IMSequenceViewCell.h
//  iMotifs
//
//  Created by Matias Piipari on 05/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMSequence;

@interface IMSequenceViewCell : NSActionCell <NSCopying> {
    
@protected
    
    CGFloat _symbolWidth;
}

@property (readwrite) CGFloat symbolWidth;

-(CGFloat) sequenceLengthInPixels:(IMSequence*) seq;
-(CGFloat) sequence:(IMSequence*)seq lengthFractionAtPoint:(NSPoint) p;
-(NSInteger) symbolPositionAtPoint:(NSPoint) p;

@end