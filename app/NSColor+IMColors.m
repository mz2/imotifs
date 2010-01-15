//
//  NSColor+IMColors.m
//  iMotifs
//
//  Created by Matias Piipari on 12/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSColor+IMColors.h"


@implementation NSColor (IMColors)

+(NSArray*) colorRainbowWithAlternatingHueAtDeviceSaturation:(CGFloat)sat
                                                   hueOffset:(CGFloat)hueOffset
                                                  brightness:(CGFloat)brightness
                                                       alpha:(CGFloat)alpha
                                                   numColors:(NSUInteger)numColors {
    NSMutableArray *colors = [NSMutableArray array];
    
    CGFloat frac = 1.0 / ((CGFloat)numColors-1);
    
    NSUInteger i;
    for (i = 0; i < numColors; i++) {
        CGFloat hue = hueOffset+((CGFloat)i / numColors * frac);
        if (hue > 1.0) {hue = hue - 1.0;}
        [colors addObject:[NSColor colorWithDeviceHue:hue  
                                           saturation:sat 
                                           brightness:brightness 
                                                alpha:alpha]];
    }
    
    return [[colors copy] autorelease];
}

@end
