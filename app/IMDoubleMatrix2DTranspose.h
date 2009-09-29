//
//  IMDoubleMatrix2DTranspose.h
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMDoubleMatrix2D.h"
#import "IMDoubleMatrix2DIface.h"

@interface IMDoubleMatrix2DTranspose : NSObject <IMDoubleMatrix2DIface> {
@private 
    IMDoubleMatrix2D *raw;
}

+(id<IMDoubleMatrix2DIface>) transpose:(id<IMDoubleMatrix2DIface>)r;
@end
