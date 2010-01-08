//
//  BCAppKitDefines.h
//  BioCocoa
//
//  Created by Koen van der Drift on Tue Mar 1 2005.
//  Copyright (c) 2005 The BioCocoa Project. All rights reserved.
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

////////////////////////////////////////////////////////////////////////////
//  GLOBAL DEFINES
////////////////////////////////////////////////////////////////////////////

#define	kLEFT_MARGIN_WIDTH	30


/*!
@enum       BCSequenceViewCase
 @abstract   Provides an ordered list of possible cases displayed in a sequenceView.
 */
typedef enum BCSequenceViewCase {
    BCUppercase = 1,
    BCLowercase = 2,
	BCOthercase = 3
    
} BCSequenceViewCase;
