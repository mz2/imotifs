//
//  IMIntMatrix2D.h
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMIntMatrix2DIface.h"

@interface IMIntMatrix2D : NSObject <IMIntMatrix2DIface> {

@private
    NSInteger *values;
    NSUInteger _rows;
    NSUInteger _columns;
    NSUInteger _elems;
}

-(id) initWithRows:(NSUInteger)rs 
                             cols:(NSUInteger)cs;

-(id) initWithRows:(NSUInteger)rs 
                             cols:(NSUInteger)cs 
                            value:(NSInteger)value;

/*-(IMIntMatrix2D*) transpose;
-(NSUInteger) rows;
-(NSUInteger) columns;
-(NSUInteger) elements;
-(NSInteger) valueAtRow:(NSUInteger)row col:(NSUInteger)col;
-(void) setValue:(NSInteger)v 
             row:(NSUInteger) row 
             col:(NSUInteger) col;*/
@end
