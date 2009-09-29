//
//  BestReciprocalHitsOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 12/9/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BestHitsOperation.h"

@interface BestReciprocalHitsOperation : BestHitsOperation {

}

-(id) initWithComparitor: (MotifComparitor*) comp 
                    from: (NSArray*) am1 
                      to: (NSArray*) am2;

@end
