//
//  Transpose.m
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "IMObjectMatrix2DTranspose.h"
#import "IMMatrix2D.h"

@implementation IMObjectMatrix2DTranspose

+(IMObjectMatrix2D*) transpose:(id<IMMatrix2D>)r {
    IMObjectMatrix2DTranspose *transp = [[IMObjectMatrix2DTranspose alloc] init];
    transp->raw = [(id)r retain];
    return (IMObjectMatrix2D*)transp;
}

-(void) dealloc {
    [(id)raw release];
    [super dealloc];
}

-(NSUInteger) rows {
    return [raw columns];
}

-(NSUInteger) columns {
    return [raw rows];
}

-(NSUInteger) elements {
    return [raw elements];
}

-(id) valueAtRow:(NSUInteger)row col:(NSUInteger)col {
    return [raw valueAtRow:col 
                col:row];
}
-(void) setValue:(id)v 
             row:(NSUInteger) row 
             col:(NSUInteger) col {
    return [raw setValue:v 
                     row:col 
                     col:row];
}
-(id<IMMatrix2D>) transpose {
    return [raw transpose];
}
@end
