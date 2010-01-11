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
