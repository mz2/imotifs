//
//  NMShuffleOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 03/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"

@interface NMShuffleOperation : IMTaskOperation {
    NSString *_motifsAFile;
    NSString *_motifsBFile;
    
    NSUInteger _bootstraps;
    double _threshold;
    
    @protected
    NSFileHandle *_readHandle;
    NSData *_inData;
}

@property(nonatomic,retain)NSString *motifsAFile;
@property(nonatomic,retain)NSString *motifsBFile;
@property(nonatomic,assign)NSUInteger bootstraps;
@property(nonatomic,assign)double threshold;

@end
