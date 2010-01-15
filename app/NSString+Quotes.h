//
//  NSString+Quotes.h
//  iMotifs
//
//  Created by Matias Piipari on 14/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (Quotes)

-(NSString*) stringBySurroundingWithString:(NSString*)str;
-(NSString*) stringBySurroundingWithSingleQuotes;
-(NSString*) stringBySurroundingWithDoubleQuotes;

@end
