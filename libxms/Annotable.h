//
//  Annotable.h
//  iMotifs
//
//  Created by Matias Piipari on 30/06/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol Annotable
- (NSMutableDictionary*) annotations;
- (NSArray*) xmsPropKeyValuePairs;
@end