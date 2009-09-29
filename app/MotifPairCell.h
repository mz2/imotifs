//
//  MotifPairCell.h
//  iMotifs
//
//  Created by Matias Piipari on 12/2/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MotifViewCell.h"
@class MotifPair;

@interface MotifPairCell : MotifViewCell {
	//the object value used in this
}

+ (void) drawLogosForMotifPair: (MotifPair*)motif 
                        inRect: (NSRect)rect 
	 scaleByInformationContent: (BOOL)scaleByInfo 
                       flipped: (BOOL) flipped
                    withOffset: (NSInteger)colOffset;
@end
