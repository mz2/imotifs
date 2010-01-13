//
//  IMPositionedFeature.h
//  iMotifs
//
//  Created by Matias Piipari on 13/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMFeature.h"

@interface IMPositionedFeature : IMFeature {

}

-(BOOL) overlapsWithPosition:(NSInteger) pos;
-(BOOL) overlapsWithRange:(NSRange) range;

@end
