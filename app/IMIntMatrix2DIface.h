//
//  IMIntMatrix2DIface.h
//  iMotifs
//
//  Created by Matias Piipari on 20/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol IMIntMatrix2DIface <NSObject>
-(id<IMIntMatrix2DIface>) transpose;

-(NSUInteger) rows;
-(NSUInteger) columns;
-(NSUInteger) elements;
-(NSInteger) valueAtRow:(NSUInteger)row col:(NSUInteger)col;
-(void) setValue:(NSInteger)v 
             row:(NSUInteger) row 
             col:(NSUInteger) col;

@end