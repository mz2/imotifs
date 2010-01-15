//
//  NSString+Quotes.m
//  iMotifs
//
//  Created by Matias Piipari on 14/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+Quotes.h"


@implementation NSString (Quotes)

-(NSString*) stringBySurroundingWithString:(NSString*)str {
    return [NSString stringWithFormat:@"%@%@%@",str,self,str];
}

-(NSString*) stringBySurroundingWithSingleQuotes {
    return [self stringBySurroundingWithString:@""];
}

-(NSString*) stringBySurroundingWithDoubleQuotes {
    return [self stringBySurroundingWithString:@"\""];
}

@end