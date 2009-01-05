//
//  BestReciprocalHitsOperation.m
//  iMotifs
//
//  Created by Matias Piipari on 12/9/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "BestReciprocalHitsOperation.h"


@implementation BestReciprocalHitsOperation
-(id) initWithComparitor: (MotifComparitor*) comp 
                    from: (NSArray*) am1 
                      to: (NSArray*) am2 {
    return [super initWithComparitor:comp from:am1 to:am2];
}

@end
