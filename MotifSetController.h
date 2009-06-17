//
//  MotifSetController.h
//  iMotifs
//
//  Created by Matias Piipari on 17/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MotifSetController : NSArrayController {
    @private
    NSMutableArray *hiddenObjects;
    NSMutableArray *shownObjects;
}

//@property (retain,readonly) NSMutableArray *hiddenIndices;
@property (retain, readonly) NSArray *hiddenObjects;
-(id) init;

-(void) showAll;
/*
-(BOOL) objectIsShown:(id)obj;
-(void) hideObject:(id)obj;
-(void) showObject:(id)obj;

 */
@end
