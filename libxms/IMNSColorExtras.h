//
//  IMNSColorExtras.h
//  iMotifs
//
//  Created by Matias Piipari on 22/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (IMNSColorExtras)
- (NSString*) hexadecimalValue;
+ (NSColor*) colorFromHexadecimalValue:(NSString *) inColorString;
@end
