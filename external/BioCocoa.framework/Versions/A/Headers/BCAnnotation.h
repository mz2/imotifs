//
//  BCAnnotation.h
//  BioCocoa
//
//  Created by Alexander Griekspoor on 22/2/2005.
//  Copyright (c) 2003-2009 The BioCocoa Project.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. The name of the author may not be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

/*!
@header
@abstract Provides sequence annotations. 
*/

#import <Foundation/Foundation.h>
#import "BCInternal.h"
#import "BCFoundationDefines.h"


// BCAnnotation Strings
/*!
 @constant BCAnnotationIdentity
 @abstract Annotation Identity Property
 */
FOUNDATION_EXPORT NSString * const BCAnnotationIdentity;
/*!
 @constant BCAnnotationOrganism
 @abstract Annotation Organism Property
 */
FOUNDATION_EXPORT NSString * const BCAnnotationOrganism;



/*!
@class      BCAnnotation
@abstract   Represents a single annotation belonging to a sequence
@discussion This class represents a non-positional annotation (in contrast to its subclass BCFeature which adds positional information).
			* BCAnnotation objects are held by the sequence object in a mutable dictionary with its name as the key. Each annotation object 
			* has a name (as its identifier), and a content which can be of any class but must be an object. The name of the content class is  
			* can be retrieved using the datatype method. These property names (name, content, datatype) adhere to the BSML standard of attributes. 
			* Note that in principle it is possible to store arrays and dictionaries as content, which allows for nested annotations. Further
			* methods to support/organize annotation nesting/sets are necessary though, nesting is therefore not advised.
*/

@interface BCAnnotation : NSObject <NSCopying>{

    NSString *name;			// name or identifier of the annotation
	NSObject *content;		// content, must be an object (plain c types must be converted to NSNumber)
	
}


#if 0
#pragma mark == INITIALIZATION METHODS ==
#endif


/*!
@method     initWithName:content:
@abstract   initializes a BCAnnotation object by passing it a NSString (name) and content object.
@discussion This is the designated initializer for BCAnnotation
*/
- (id)initWithName: (NSString *)aName content: (id)theContent;


/*!
@method     initWithName:intValue:
@abstract   initializes a BCAnnotation object by passing it a NSString name and integer as content.
@discussion This is method converts an integer in a NSNumber object and uses the designated initializer
* to initialize a BCAnnotation object
*/
- (id)initWithName: (NSString *)aName intValue: (int)theContent;

/*!
@method     initWithName:floatValue:
@abstract   initializes a BCAnnotation object by passing it a NSString name and float as content.
@discussion This is method converts a float in a NSNumber object and uses the designated initializer
* to initialize a BCAnnotation object
*/
- (id)initWithName: (NSString *)aName floatValue: (float)theContent;

/*!
@method     initWithName:doubleValue:
@abstract   initializes a BCAnnotation object by passing it a NSString name and double as content.
@discussion This is method converts a double in a NSNumber object and uses the designated initializer
* to initialize a BCAnnotation object
*/
- (id)initWithName: (NSString *)aName doubleValue: (double)theContent;

/*!
@method     initWithName:boolValue:
@abstract   initializes a BCAnnotation object by passing it a NSString name and boolean as content.
@discussion This is method converts a boolean in a NSNumber object and uses the designated initializer
* to initialize a BCAnnotation object
*/
- (id)initWithName: (NSString *)aName boolValue: (BOOL)theContent;


/*!
@method     annotationWithName:content:
@abstract   creates and returns an autoreleased annotation object initialized with a NSString (name) and content object.
*/
+ (id)annotationWithName: (NSString *)aName content: (id)theContent;

/*!
@method     annotationWithName:intValue:
@abstract   creates and returns an autoreleased annotation object initialized with a NSString (name) and integer as content.
@discussion This is method converts a integer in a NSNumber object
*/
+ (id)annotationWithName: (NSString *)aName intValue: (int)theContent;

/*!
@method     annotationWithName:floatValue:
@abstract   creates and returns an autoreleased annotation object initialized with a NSString (name) and float as content.
@discussion This is method converts a float in a NSNumber object
*/
+ (id)annotationWithName: (NSString *)aName floatValue: (float)theContent;

/*!
@method     annotationWithName:doubleValue:
@abstract   creates and returns an autoreleased annotation object initialized with a NSString (name) and double as content.
@discussion This is method converts a double in a NSNumber object
*/
+ (id)annotationWithName: (NSString *)aName doubleValue: (double)theContent;

/*!
@method     annotationWithName:boolValue:
@abstract   creates and returns an autoreleased annotation object initialized with a NSString (name) and boolean as content.
@discussion This is method converts a boolean in a NSNumber object
*/
+ (id)annotationWithName: (NSString *)aName boolValue: (BOOL)theContent;


/*!
@method     copyWithZone:
@abstract   returns copy of the receiving annotation object. 
*/
- (id)copyWithZone:(NSZone *)zone;


#if 0
#pragma mark == ACCESSOR METHODS ==
#endif


/*!
@method     name
@abstract   returns the name of the annotation
*/
- (NSString *)name;
	
/*!
@method     setName:
@abstract   sets the name of the annotation
*/
- (void)setName:(NSString *)newName;

/*!
@method     content
@abstract   returns the name of the content
*/
- (NSObject *)content;

/*!
@method     setContent:
@abstract   sets the content of the annotation
@discussion Note that this method retains the content object!
*/
- (void)setContent:(NSObject *)newContent;


#if 0
#pragma mark == GENERAL METHODS ==
#endif


/*!
@method     description
@abstract   returns the name, content, and datatype
*/
- (NSString *) description;

/*!
@method     datatype
@abstract   returns the class name of the content object
*/
- (NSString *)datatype;


/*!
@method     stringValue
@abstract   returns a string representation of the content object
@discussion If the content object is not of class NSString this method returns the content object's description
*/
- (NSString *) stringValue;

/*!
@method     intValue
@abstract   returns an integer representation of the content object
@discussion This method tries to call intValue on the content object. Otherwise returns 0.
*/
- (int)intValue;

/*!
@method     floatValue
@abstract   returns an float representation of the content object
@discussion This method tries to call floatValue on the content object. Otherwise returns 0.0.
 */
- (float)floatValue;

/*!
@method     doubleValue
@abstract   returns an double representation of the content object
@discussion This method tries to call doubleValue on the content object. Otherwise returns 0.0.
 */
- (double)doubleValue;

/*!
@method     boolValue
@abstract   returns an bool representation of the content object
@discussion This method tries to call boolValue on the content object. Otherwise returns NO.
 */
- (BOOL)boolValue;


#if 0
#pragma mark == COMPARISON & SORTING METHODS ==
#endif


/*!
@method     isEqualTo:
@abstract   Compares the receiving annotation to otherAnnotation. 
@discussion If the NAME of otherAnnotation is equal to that of the receiver, this method returns YES. If not, it returns NO.
*/
- (BOOL)isEqualTo: (BCAnnotation *) otherAnnotation;

/*!
@method     isEqualToAnnotation:
@abstract   Compares the content of the receiving annotation to otherAnnotation. 
@discussion If the CONTENT of otherAnnotation is equal to that of the receiver, this method returns YES. If not, it returns NO.
            * Note that the names of both annotations do not necessarily have to be identical.
*/
- (BOOL)isEqualToAnnotation: (BCAnnotation *) otherAnnotation;


/*!
@method     sortAnnotationsOnNameAscending:
@abstract   Sorts the receiving annotations compared to otherAnnotation based on name in ascending order. 
*/
- (NSComparisonResult)sortAnnotationsOnNameAscending:(BCAnnotation *) ann;

/*!
@method     sortAnnotationsOnNameDescending:
@abstract   Sorts the receiving annotations compared to otherAnnotation based on name in descending order. 
*/
- (NSComparisonResult)sortAnnotationsOnNameDescending:(BCAnnotation *) ann;

/*!
@method     sortAnnotationsOnContentAscending:
@abstract   Sorts the receiving annotations compared to otherAnnotation based on content in ascending order. 
@discussion If both contents are of class NSString OR NSNumber calls compare: else returns NSOrderedSame
*/
- (NSComparisonResult)sortAnnotationsOnContentAscending:(BCAnnotation *) ann;

/*!
@method     sortAnnotationsOnContentDescending:
@abstract   Sorts the receiving annotations compared to otherAnnotation based on content in descending order. 
@discussion If both contents are of class NSString OR NSNumber calls compare: else returns NSOrderedSame
*/
- (NSComparisonResult)sortAnnotationsOnContentDescending:(BCAnnotation *) ann;


@end

