//
//  IMIntMatrix2DTranspose.h
//  iMotifs
//
//  Created by Matias Piipari on 20/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMIntMatrix2D.h"
#import "IMIntMatrix2DIface.h"

@interface IMIntMatrix2DTranspose : NSObject <IMIntMatrix2DIface> {
@private 
    id<IMIntMatrix2DIface> raw;
}

+(id<IMIntMatrix2DIface>) transpose:(id<IMIntMatrix2DIface>)r;

@end
