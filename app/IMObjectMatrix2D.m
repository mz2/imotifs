//
//  ObjectMatrix2D.m
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "IMObjectMatrix2D.h"
#import "IMObjectMatrix2DTranspose.h"

@implementation IMObjectMatrix2D

-(id) initWithRows:(NSUInteger)rs 
                             cols:(NSUInteger)cs {
    self = [super init];
    if (self != nil) {
        _rows = rs;
        _columns = cs;
        _elems = rs * cs;
        values = [[NSMutableArray alloc] initWithCapacity:_elems];
    }
    return self;
}

-(id<IMMatrix2D>) transpose {
    return [IMObjectMatrix2DTranspose transpose:self];
}

-(void) dealloc {
    [values release];
    values = nil;
    [super dealloc];
}

-(NSUInteger) rows {
    return _rows;
}

-(NSUInteger) columns {
    return _columns;
}
-(NSUInteger) elements {
    return _elems;
}

-(id) valueAtRow:(NSUInteger)row 
                 col:(NSUInteger)col {
    return [values objectAtIndex:row * _columns + col];
}

-(void) setValue:(id)v 
             row:(NSUInteger) row 
             col:(NSUInteger) col {
    [values replaceObjectAtIndex:row * _columns + col 
                      withObject:v];
}

@end
