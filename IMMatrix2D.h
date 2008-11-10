//
//  IMMatrix2D.h
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol IMMatrix2D
-(id<IMMatrix2D>) transpose;

-(NSUInteger) rows;
-(NSUInteger) columns;
-(NSUInteger) elements;
-(id) valueAtRow:(NSUInteger)row col:(NSUInteger)col;
-(void) setValue:(id)v 
             row:(NSUInteger) row 
             col:(NSUInteger) col;
@end
