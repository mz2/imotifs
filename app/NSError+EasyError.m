//
//  NSError+EasyError.m
//  iMotifs
//
//  Created by Matias Piipari on 15/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSError+EasyError.h"


@implementation NSError (EasyError)

+(NSError*) errorWithCode:(NSInteger)code description:(NSString*)desc {
    NSDictionary *eDict = [NSDictionary dictionaryWithObject:desc forKey: NSLocalizedDescriptionKey];
    
    NSError *e = [NSError errorWithDomain:@"IMErrorDomain" 
                                     code:code
                                 userInfo:eDict];
    
    return e;
}
@end
