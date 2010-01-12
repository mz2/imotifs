//
//  NSColor+IMColors.h
//  iMotifs
//
//  Created by Matias Piipari on 12/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSColor (IMColors)

+(NSArray*) colorRainbowWithAlternatingHueAtDeviceSaturation:(CGFloat)sat
                                                   hueOffset:(CGFloat)satOffset
                                                  brightness:(CGFloat)brightness
                                                       alpha:(CGFloat)alpha
                                                   numColors:(NSUInteger)numColors;

@end
