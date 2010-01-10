//
//  BCCachedSequenceFile.h
//  BioCocoa
//
//  Created by Scott Christley on 9/10/07.
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

//
// Cached sequences
//
// For handling very large sequence files,
// we do not want to read in all of sequence
// data into memory; instead we parse the file
// and pull out meta-data.  Working with the
// sequence data is handled by a specific cached
// sequence class which reads data from the file
// when needed.
//

@interface BCCachedSequenceFile : NSObject {
  NSString *sequenceFile;
  NSMutableDictionary *sequenceInfo;
  NSMutableArray *sequenceList;

  FILE *fileHandle;
  int currentSequenceNumber;
  NSDictionary *currentSequence;
}

+ readCachedFileUsingPath:(NSString *)filePath;

// overridden by file format specific subclasses
- initWithContentsOfFile:(NSString *)filePath;

- (unsigned)numberOfSequences;
- (NSDictionary *)infoForSequence:(NSString *)seqID;
- (NSDictionary *)infoForSequenceNumber:(int)seqNum;

- (char)symbolAtPosition:(unsigned long long)aPos forSequence:(NSString *)seqID;
- (char)symbolAtPosition:(unsigned long long)aPos forSequenceNumber:(int)seqNum;

- (int)symbols:(char *)aBuffer atPosition:(unsigned long long)aPos ofLength:(unsigned)aLen forSequenceNumber:(int)seqNum;
- (int)symbols:(char *)aBuffer atPosition:(unsigned long long)aPos ofLength:(unsigned)aLen forSequence:(NSString *)seqID;

- (void)closeFileHandle;

@end
