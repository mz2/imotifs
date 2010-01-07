//
//  BCMCP.h
//  BioCocoa
//
//  Created by Scott Christley on 7/24/07.
//  Copyright 2007 The BioCocoa Project. All rights reserved.
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

#import <Foundation/Foundation.h>

@class BCSuffixArray;
@class BCSequenceArray;
@class BCCachedSequenceFile;

@interface BCMCP : NSObject {
  NSMutableDictionary *metaDict;
  NSMutableArray *sequenceToMeta;
  BOOL inMemory;

  // in memory sequences
  BCSequenceArray *sequenceArray;
  BCSequenceArray *reverseComplementArray;

  // cached sequences
  NSMutableArray *cachedFiles;
}

+ (BOOL)mcpToFile:(NSString *)aPath suffixArray:(BCSuffixArray *)oneArray
  withSuffixArray:(BCSuffixArray *)otherArray lowerBound:(int)lowerBound;

- (BOOL)intersectToFile:(NSString *)aPath withMCP:(BCMCP *)anMCP;
- (BOOL)unionToFile:(NSString *)aPath withMCP:(BCMCP *)anMCP;
- (BOOL)trimToFile:(NSString *)aPath;

- initWithContentsOfFile:(NSString *)aPath inMemory:(BOOL)aFlag;

- (BOOL)isInMemory;
- (BCSequenceArray *)sequenceArray;
- (BCSequenceArray *)reverseComplementArray;
- (NSDictionary *)metaDictionary;
- (NSArray *)sequenceToMeta;
- (NSArray *)cachedFiles;

- (BOOL)writeToFile:(NSString *)aPath;
- (FILE *)getFILE;

- (void)summaryFormatWithMinimumLength:(int)minLength;
- (void)fastaFormatWithMinimumLength:(int)minLength;
- (void)tableFormatWithMinimumLength:(int)minLength;

@end
