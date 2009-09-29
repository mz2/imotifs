//
//  Transpose.h
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IMMatrix2D.h"
#import "IMObjectMatrix2D.h"

@interface IMObjectMatrix2DTranspose : NSObject <IMMatrix2D> {
    
@private 
    id<IMMatrix2D> raw;
}

+(IMObjectMatrix2D*) transpose:(id<IMMatrix2D>)r;
@end
