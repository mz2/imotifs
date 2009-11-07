//
//  ObjectMatrix2D.h
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMMatrix2D.h"

@interface IMObjectMatrix2D : NSObject <IMMatrix2D> {

@private
    NSMutableArray *values;
    NSUInteger _rows;
    NSUInteger _columns;
    NSUInteger _elems;
    
}

-(id) initWithRows:(NSUInteger)rs 
                             cols:(NSUInteger)cs;

@end
