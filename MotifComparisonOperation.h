//
//  MotifBestHitsOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 12/8/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMOperation.h"

@class MotifComparitor;

@interface MotifComparisonOperation : IMOperation {
    MotifComparitor *comparitor;
    //NSTask *task;
}

-(id) initWithComparitor:(MotifComparitor*) comparitor;

@property (retain,readonly) MotifComparitor *comparitor;
//@property (readonly) NSTask *task;
@end
