/*
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the
Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
Boston, MA  02110-1301, USA.
*/
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
