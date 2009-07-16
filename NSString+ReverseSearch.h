//
//  NSString+ReverseSearch.h
//  iMotifs
//
//  Created by Matias Piipari on 18/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (ReverseSearch)
-(NSComparisonResult) reverseCaseInsensitiveCompare:(NSString*)str;
@end
