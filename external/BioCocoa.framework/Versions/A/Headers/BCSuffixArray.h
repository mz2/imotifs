//
//  BCSuffixArray.h
//  BioCocoa
//
//  Created by Scott Christley on 7/20/07.
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
//

/*
Hybrid suffix-array builder, written by Sean Quinlan and Sean Doward,
distributed under the Plan 9 license, which reads in part

3.3 With respect to Your distribution of Licensed Software (or any
portion thereof), You must include the following information in a
conspicuous location governing such distribution (e.g., a separate
file) and on all copies of any Source Code version of Licensed
Software You distribute:

    "The contents herein includes software initially developed by
    Lucent Technologies Inc. and others, and is subject to the terms
    of the Lucent Technologies Inc. Plan 9 Open Source License
    Agreement.  A copy of the Plan 9 Open Source License Agreement is
    available at: http://plan9.bell-labs.com/plan9dist/download.html
    or by contacting Lucent Technologies at http: //www.lucent.com.
    All software distributed under such Agreement is distributed on,
    obligations and limitations under such Agreement.  Portions of
    the software developed by Lucent Technologies Inc. and others are
    Copyright (c) 2002.  All rights reserved.
    Contributor(s):___________________________"
*/

/*!
@header
@abstract Create and manage suffix arrays for sequence data.
*/

#import <Foundation/Foundation.h>

@class BCSequence;
@class BCSequenceArray;
@class BCMCP;

/*!
    @class      BCSuffixArray
    @abstract   Class that manages a suffix array for a sequence.
    @discussion A suffix array is a data structure containing all of the suffix
    * strings for a sequence in sorted order.  It is useful for doing fast, simple
    * string searches and comparison operations.  In constrast to a suffix tree,
    * the suffix array is easily stored on disk for large sequences like whole genomes.
*/

@interface BCSuffixArray : NSObject {
  BCSequenceArray *sequenceArray;
  BCSequenceArray *reverseComplementArray;
  NSMutableDictionary *metaDict;
  NSString *dirPath;
  NSString *tmpFile;
  unsigned char *memSequence;
  int numOfSuffixes;
  int *suffixArray;
  BOOL inMemory;
  long long maxMemoryUsage;
  int memoryState;
  BOOL softMask;
}

- (BOOL)constructFromSequence:(BCSequence *)aSequence strand:(NSString *)aStrand;
- (BOOL)constructFromSequenceArray:(BCSequenceArray *)anArray strand:(NSString *)aStrand;
- (BOOL)constructFromSequenceFile:(NSString *)aPath strand:(NSString *)aStrand;

- initWithContentsOfFile:(NSString *)aPath forSequence:(BCSequence *)aSequence inMemory:(BOOL)aFlag;
- initWithContentsOfFile:(NSString *)aPath forSequenceArray:(BCSequenceArray *)anArray
		inMemory:(BOOL)aFlag;
- initWithContentsOfFile:(NSString *)aPath inMemory:(BOOL)aFlag;

- (BOOL)writeToFile:(NSString *)aPath withMasking:(BOOL)aFlag;
- (FILE *)getFILE;

- (int)numberOfSequences;
- (int)numOfSuffixes;
- (const int *)suffixArray;
- (unsigned char *)memoryForSequence:(int)aNum;
- (BCSequenceArray *)sequenceArray;
- (BCSequenceArray *)reverseComplementArray;
- (NSDictionary *)metaDictionary;
- (BOOL)softMask;
- (void)setSoftMask: (BOOL)aFlag;

- (void)dumpSuffixArray;
- (void)dumpSuffixArrayForSequence:(int)aSeq position:(int)aPos length:(int)aLen;

@end

/*!
    @class      BCSuffixArrayUnionEnumerator
    @abstract   Provides an enumeration of the suffix strings for the union of a set of suffix arrays.
    @discussion Performs an on-the-fly (online) union of a set of suffix arrays with an enumeration of
    * the suffixes in sorted order.  Each time -nextSuffixPosition is called, the enumerator moves to
    * the next suffix in the union; returns NO when the enumeration is at the end.  If enumeration is at
    * the end, calling -nextSuffixPosition again will restart the enumeration back at the beginning.
    * Puts the current suffix position, sequence index and suffix array index into the parameters, pass
    * NULL for any parameters not wanted.
*/

@interface BCSuffixArrayUnionEnumerator : NSObject
{
  NSArray *suffixArrays;
  int *suffixPositions;
  int *suffixSequences;
  FILE **arrayFiles;
  BOOL *eofFlags;
  BCSequenceArray **saSeqs;
  BCSequenceArray **saRevs;

  int currentSuffix;
  BCSuffixArray *currentArray;
}

- initWithSuffixArrays:(NSArray *)arrays;

- (BOOL)nextSuffixPosition:(int *)aPos sequence:(int *)aSeq suffixArray:(int *)anArray;

- (NSArray *)suffixArrays;

@end

#define BCSUFFIXARRAY_TERM_CHAR '#'
