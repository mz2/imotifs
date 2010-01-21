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
//  NMShuffleOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 03/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"
#import "MotifSetDocument.h"

@class MotifSet;

@interface NMShuffleOperation : IMTaskOperation {
    NSString *_motifsAFile;
    NSString *_motifsBFile;
    NSString *_outputFile;
    
    NSUInteger _bootstraps;
    double _threshold;
    
    @protected
    NSFileHandle *_readHandle;
    NSData *_inData;
    BOOL _temporaryFiles;
    BOOL _temporaryOutputFile;
    
    MotifSetDocument *_motifSetDocument;
}

-(id) initWithMotifs:(MotifSet*) motifsA 
             against:(MotifSet*) motifsB
          outputFile:(NSString*) outFile;

-(id) initWithMotifsFromFile: (NSString*) motifsAPath 
       againstMotifsFromFile: (NSString*) motifsBPath
                 outputFile: (NSString*) outputFile
           deleteSourceFiles: (BOOL) deleteSourceFiles;

@property(nonatomic,retain)NSString *motifsAFile;
@property(nonatomic,retain)NSString *motifsBFile;
@property(nonatomic,retain)NSString *outputFile;
@property(nonatomic,assign)NSUInteger bootstraps;
@property(nonatomic,assign)double threshold;

@property(nonatomic,retain)MotifSetDocument *motifSetDocument;

@end
