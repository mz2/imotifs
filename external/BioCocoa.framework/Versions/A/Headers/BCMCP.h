//
//  BCMCP.h
//  BioCocoa
//
//  Created by Scott Christley on 7/24/07.
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
