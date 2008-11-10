//
//  IMMatrix2D.h
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMDoubleMatrix2DIface.h"


@interface IMDoubleMatrix2D : NSObject <IMDoubleMatrix2DIface> {
    
@private
    double *values;
    NSUInteger _rows;
    NSUInteger _columns;
    NSUInteger _elems;
}

-(id) initWithRows:(NSUInteger)rs cols:(NSUInteger)cs;

-(id) initWithRows:(NSUInteger)rs 
                             cols:(NSUInteger)cs 
                            value:(double)value;
//-(IMDoubleMatrix2D*) transpose;

/*
-(NSUInteger) rows;
-(NSUInteger) columns;
-(NSUInteger) elements;
-(double) valueAtRow:(NSUInteger)row col:(NSUInteger)col;
-(void) setValue:(double)v 
             row:(NSUInteger) row 
             col:(NSUInteger) col;*/
@end
