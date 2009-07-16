//
//  NSString+ReverseSearch.m
//  iMotifs
//
//  Created by Matias Piipari on 18/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+ReverseSearch.h"


@implementation NSString (ReverseSearch)
-(NSComparisonResult) reverseCaseInsensitiveCompare:(NSString*)str {
    return [str caseInsensitiveCompare:self];
}
@end
