//
//  IMNSColorExtras.m
//  iMotifs
//
//  Created by Matias Piipari on 22/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "IMNSColorExtras.h"


@implementation NSColor (IMSNColorExtras)

-(NSString *)hexadecimalValue
{
    float redFloatValue, greenFloatValue, blueFloatValue;
    int redIntValue, greenIntValue, blueIntValue;
    NSString *redHexValue, *greenHexValue, *blueHexValue;
    
    //Convert the NSColor to the RGB color space before we can access its components
    NSColor *convertedColor=[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    
    if(convertedColor) {
        // Get the red, green, and blue components of the color
        [convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];
        
        // Convert the components to numbers (unsigned decimal integer) between 0 and 255
        redIntValue=redFloatValue*255.99999f;
        greenIntValue=greenFloatValue*255.99999f;
        blueIntValue=blueFloatValue*255.99999f;
        
        // Convert the numbers to hex strings
        redHexValue=[NSString stringWithFormat:@"%02x", redIntValue];
        greenHexValue=[NSString stringWithFormat:@"%02x", greenIntValue];
        blueHexValue=[NSString stringWithFormat:@"%02x", blueIntValue];
        
        // Concatenate the red, green, and blue components' hex strings together with a "#"
        return [NSString stringWithFormat:@"#%@%@%@", redHexValue, greenHexValue, blueHexValue];
    }
    return nil;
}

+ (NSColor *) colorFromHexadecimalValue:(NSString *) inColorString {
    if (!inColorString || [inColorString isEqual:@"(null)"]) {
        return nil;
    }
    NSString *str;
    if ([inColorString length] == 7) {
        str = [[inColorString substringFromIndex:1] uppercaseString];
    } else if ([inColorString length] == 6) {
        str = [inColorString uppercaseString];
    } else {
        @throw [NSException exceptionWithName:@"IMInvalidStringFormatException" 
                                       reason:[NSString 
                                               stringWithFormat:
                                               @"The string %@ is not of the needed form #xxyyzz or xxyyzz",inColorString] 
                                     userInfo:NULL];
    }
    
    
	NSColor *result = nil;
	unsigned int colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != inColorString)
	{
		NSScanner *scanner = [NSScanner scannerWithString:str];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);	// masks off high bits
	result = [NSColor
              colorWithCalibratedRed:		(float)redByte	/ 0xff
              green:	(float)greenByte/ 0xff
              blue:	(float)blueByte	/ 0xff
              alpha:1.0];
	return result;
}
@end
