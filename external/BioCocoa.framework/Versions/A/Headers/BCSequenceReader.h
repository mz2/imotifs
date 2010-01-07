//
//  BCSequenceReader.h
//  BioCocoa
//
//  Created by Koen van der Drift on 10/16/04.
//  Copyright 2004 The BioCocoa Project. All rights reserved.
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

@class BCSequence;
@class BCSequenceArray;

typedef struct strider_header
{
    char		versionNb;
    char		type;
    char		topology;
    char		reserved1;
    int			reserved2;
    int			reserved3;
    int			reserved4;
    char		reserved5;
    char		filler1;
    short		filler2;
    int			filler3;
    int			reserved6;
    int			nLength;
    int			nMinus;
    int			reserved7;
    int			reserved8;
    int			reserved9;
    int			reserved10;
    int			reserved11;
    char		reserved12[32];
    short		reserved13;
    short		filler4;
    char		reserved14;
    char		reserved15;
    char		reserved16;
    char		filler5;
    int			com_length;
    int			reserved17;
    int			filler6;
    int			filler7;
}STRIDER_HEADER;

typedef struct gck_header
{
	int			unknown1;
    int			unknown2;
	int			unknown3;
    int			unknown4;
    int			unknown5;
    int			unknown6;
    int			unknown7;
	int			nLength;
}GCK_HEADER;

typedef  struct macvector_header
{
	char	seqType;		// 0: nucleic, else: protein
	char	empty1;
	char	empty2;
	char	topology;		// 0: linear, else: circular
	char	empty3;
	char	empty4;
	char	ntType;			// 1: RNA, else: DNA
	char	empty5;
	char	month;			// 1-12
	char	day;			// 1-31
	char	year;			// 0-255 + 1900
	int		empty6;
	int		nSegments;		// always 1. Total number of sequences, BTW
	int		totalLength;	// equal to sequence length (nSegments = 1)
	int		segNo;			// Number of segment (always 1?)
	int		seqLength;		// this segment length
	int		seqBytes;		// this segment length again (???)
}MACVECTOR_HEADER;

//
// File formats 
//
typedef enum _BCFileFormat {
  BCFastaFileFormat,
  BCSwissProtFileFormat,
  BCPDBFileFormat,
  BCNCBIFileFormat,
  BCClustalFileFormat,
  BCStriderFileFormat,
  BCGCKFileFormat,
  BCMacVectorFileFormat,
  BCGDEFFileFormat,
  BCPirFileFormat,
  BCMSFFileFormat,
  BCPhylipFileFormat,
  BCNonaFileFormat,
  BCHenningFileFormat
} BCFileFormat;

@interface BCSequenceReader : NSObject {

}

- (BCSequenceArray *)readFileUsingText:(NSString *)textFile;
- (BCSequenceArray *)readFileUsingData:(NSData *)dataFile;
- (BCSequenceArray *)readFileUsingPath:(NSString *)filePath;
- (BCSequenceArray *)readFileUsingPath:(NSString *)filePath format:(BCFileFormat)aFormat;

- (BCSequenceArray *)readFastaFile:(NSString *)textFile;
- (BCSequenceArray *)readSwissProtFile:(NSString *)textFile;
- (BCSequenceArray *)readPDBFile:(NSString *)textFile;
- (BCSequenceArray *)readNCBIFile:(NSString *)textFile;
- (BCSequenceArray *)readClustalFile:(NSString *)textFile;
- (BCSequenceArray *)readStriderFile:(NSString *)textFile;
- (BCSequenceArray *)readGCKFile:(NSString *)textFile;
- (BCSequenceArray *)readMacVectorFile:(NSString *)textFile;
- (BCSequenceArray *)readGDEFile:(NSString *)entryString;
- (BCSequenceArray *)readPirFile:(NSString *)entryString;
- (BCSequenceArray *)readMSFFile:(NSString *)entryString;
- (BCSequenceArray *)readPhylipFile:(NSString *)entryString;
- (BCSequenceArray *)readRawFile:(NSString *)entryString;

//- (BCSequenceArray *)readNonaFile:(NSString *)entryString;
//- (BCSequenceArray *)readHennigFile:(NSString *)entryString;

@end

