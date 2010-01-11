//
//  BCSequenceReader.h
//  BioCocoa
//
//  Created by Koen van der Drift on 10/16/04.
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
  BCHenningFileFormat,
  BCFASTQFileFormat
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
- (BCSequenceArray *)readFASTQFile:(NSString *)textFile;

//- (BCSequenceArray *)readNonaFile:(NSString *)entryString;
//- (BCSequenceArray *)readHennigFile:(NSString *)entryString;

@end

