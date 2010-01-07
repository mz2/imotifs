//
//  BCUtilData.h
//  BioCocoa
//
//  Created by Koen van der Drift on 7/22/2005.
//  Copyright 2005 The BioCocoa Project. All rights reserved.
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

/*!
@header
@abstract Category methods for NSData. 
*/

#import <Foundation/Foundation.h>

/*!
 @category NSData(DataAdditions)
 @abstract Parsing and utility methods
 */

@interface NSData (DataAdditions)

- (unsigned char) charAtIndex: (int) index;

@end
