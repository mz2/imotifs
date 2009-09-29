//
//  NMTrainBGModelOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 1/29/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"

@interface NMTrainBGModelOperation : IMTaskOperation {
    NSString *inputSequencePath;
    NSString *outputBackgroundModelFilePath;
    NSUInteger classes;
    NSUInteger order;
    
    
    @private
    NSFileHandle *readHandle;
    NSFileHandle *errorReadHandle;
}

@property (copy,readwrite) NSString *inputSequencePath;
@property (copy,readwrite) NSString *outputBackgroundModelFilePath;

@property NSUInteger classes;
@property NSUInteger order;

@end
