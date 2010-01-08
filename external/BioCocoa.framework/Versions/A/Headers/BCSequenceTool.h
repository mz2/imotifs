//
//  BCSequenceTool.h
//  BioCocoa
//
//  Created by Koen van der Drift on 12/17/2004.
//  Copyright 2004 The BioCocoa Project. All rights reserved.
//
//  This code is covered by the Creative Commons Share-Alike Attribution license.
//	You are free:
//	to copy, distribute, display, and perform the work
//	to make derivative works
//	to make commercial use of the work
//
//	Under the following conditions:
//	You must attribute the work in the manner specified by the author or licensor.
//	If you alter, transform, or build upon this work, you may distribute the resulting work only under a license identical to this one.
//
//	For any reuse or distribution, you must make clear to others the license terms of this work.
//	Any of these conditions can be waived if you get permission from the copyright holder.
//
//  For more info see: http://creativecommons.org/licenses/by-sa/2.5/

#import <Foundation/Foundation.h>
#import "BCFoundationDefines.h"

@class BCSequence;

@interface BCSequenceTool : NSObject 
{
	BCSequence	*sequence;
}

- (id) initWithSequence: (BCSequence *)list;

- (BCSequence *)sequence;
- (void)setSequence:(BCSequence *)s;

@end
