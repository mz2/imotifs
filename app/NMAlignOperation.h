/*
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the
Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
Boston, MA  02110-1301, USA.
*/
//
//  NMAlignOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 03/06/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"
@class MotifSetDocument;
@class MotifSet;

typedef enum NMAlignOutputType {
    NMAlignOutputTypeAverage = 0,
    NMAlignOutputTypeMetamotif = 1,
    NMAlignOutputTypeAll = 2
} NMAlignOutputType;

@interface NMAlignOperation : IMTaskOperation {
    NSArray *inputPaths;
    NSString *outputPath;
    NSString *namePrefix;
    
    BOOL addName;
    double maxPrecision;
    double minColWeight;
    NSUInteger minCols;
    
    NMAlignOutputType outputType;
    MotifSetDocument *motifSetDocument;
    //BOOL needsRepeatMasking;
    @protected
    NSMutableString *stdOutOutput;
    NSMutableString *stdErrOutput;
    
    NSString *inputTempPath;
    NSString *outputTempPath;
    
    //NSMutableString *buf;
    NSFileHandle *readHandle;
    NSFileHandle *errorReadHandle;
    
    BOOL receivedOutputData;
    BOOL receivedErrorData;
}

-(id) initWithMotifSet:(MotifSet*) mset;

@property (retain,readwrite) MotifSetDocument *motifSetDocument;
@property (retain,readwrite) NSArray *inputPaths;
@property (copy,readwrite) NSString *outputPath;
@property (copy,readwrite) NSString *namePrefix;

@property (readwrite) BOOL addName;
@property (readwrite) double maxPrecision;
@property (readwrite) double minColWeight;
@property (readwrite) NSUInteger minCols;

@property (readwrite) NMAlignOutputType outputType;

@property (retain, readonly) NSFileHandle *readHandle;
@property (retain, readonly) NSFileHandle *errorReadHandle;
@end
