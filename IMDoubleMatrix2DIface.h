//
//  IMDoubleMatrix2DIface.h
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol IMDoubleMatrix2DIface <NSObject>
-(id<IMDoubleMatrix2DIface>) transpose;

-(NSUInteger) rows;
-(NSUInteger) columns;
-(NSUInteger) elements;
-(double) valueAtRow:(NSUInteger)row col:(NSUInteger)col;
-(void) setValue:(double)v 
             row:(NSUInteger) row 
             col:(NSUInteger) col;

@end
