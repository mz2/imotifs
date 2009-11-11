//
//  BCUtilStrings.h
//  was stringAdditions
//
//  Created by Peter Schols on Wed Oct 22 2003.
//  Copyright (c) 2003-2009 The BioCocoa Project.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. The name of the author may not be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
