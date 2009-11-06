//
//  NMShuffleOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 03/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"
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
}

-(id) initWithMotifs:(MotifSet*) motifsA 
             against:(MotifSet*) motifsB;

-(id) initWithMotifsFromFile: (NSString*) motifsAPath 
       againstMotifsFromFile: (NSString*) motifsBPath
           deleteSourceFiles: (BOOL) deleteSourceFiles;

@property(nonatomic,retain)NSString *motifsAFile;
@property(nonatomic,retain)NSString *motifsBFile;
@property(nonatomic,retain)NSString *outputFile;
@property(nonatomic,assign)NSUInteger bootstraps;
@property(nonatomic,assign)double threshold;

@end
