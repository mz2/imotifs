//
//  IMSequence.h
//  iMotifs
//
//  Created by Matias Piipari on 05/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BioCocoa/BCSequenceArray.h>

@interface IMSequence : BCSequence {
    NSInteger _focusPosition;
    NSString *_name;
}

@property (readwrite) NSInteger focusPosition;
@property (copy,readwrite) NSString *name;

-(NSArray*) annotationsOverlappingWithPosition:(NSInteger) position;

@end