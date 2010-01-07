//
//  BCCachedSequenceFile.h
//  BioCocoa
//
//  Created by Scott Christley on 9/10/07.
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
