//
//  BCUtilStrings.h
//  was stringAdditions
//
//  Created by Peter Schols on Wed Oct 22 2003.
//  Copyright 2003 The BioCocoa Project. All rights reserved.
//
//  This code is covered by the Creative Commons Share-Alike Attribution license.
//	You are free:
//	to copy, distribute, display, and perform the work
//	to make derivative works
//	to make commercial use of the work
//
//	Under the following conditions:
//	You must attribute the work in the manner specified by the author or licensor.
//	If you alter, transform, or build upon this work, you may distribute the resulting work only under a license identical to this one.
//
//	For any reuse or distribution, you must make clear to others the license terms of this work.
//	Any of these conditions can be waived if you get permission from the copyright holder.
//
//  For more info see: http://creativecommons.org/licenses/by-sa/2.5/

/*!
@header
@abstract Category methods for NSString and NSMutableString. 
*/

#import <Foundation/Foundation.h>

/*!
 @category NSString(StringAdditions)
 @abstract Parsing and utility methods
*/

@interface NSString (StringAdditions)

-(BOOL)hasCaseInsensitivePrefix:(NSString *)prefix;
-(BOOL)hasCaseInsensitiveSuffix:(NSString *)suffix;

-(NSString *)stringByReplacingSpaceWithUnderscore;
#ifndef GNUSTEP
-(NSString *)stringByAddingURLEscapesUsingEncoding: (CFStringEncodings) enc;
#endif
+(NSString *)stringWithBytes:(const void *)bytes length: (unsigned)length encoding: (NSStringEncoding) encoding;

-(BOOL)stringContainsString:(NSString *)s;
-(BOOL)stringContainsCharactersFromString:(NSString *)s;
-(BOOL)stringContainsCharactersFromSet:(NSCharacterSet *)set;
//-(NSString *)stringByRemovingRichTextFromString:(NSString *)inputString

-(BOOL)stringBeginsWithTwoNumbers;

-(NSMutableArray *)splitLines;

- (NSString *)stringByRemovingWhitespace;
- (NSString *)stringByRemovingWhitespaceAndNewline;
- (NSString *)stringByRemovingCharactersFromSet:(NSCharacterSet *)set;

- (NSString *) bracketedStringWithLeftBracket: (NSString *)leftBracket rightBracket: (NSString *)rightBracket caseSensitive: (BOOL)caseSensitive;
- (NSString *) addSpacesToStringWithInterval:(int)interval;
- (NSString *) addSpacesToStringWithInterval:(int)interval removeOldWhitespaces:(BOOL)remove;
- (NSMutableString *)convertLineBreaksToMac;

@end

/*!
 @category NSMutableString(StringAdditions)
 @abstract Parsing and utility methods
 */

@interface NSMutableString (StringAdditions)

- (void)removeCharactersInSet:(NSCharacterSet *)set;

@end
