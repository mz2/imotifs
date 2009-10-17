/*! @cond IGNORE */
////////////////////////////////////////////////////////////////////////////////////////////
//
//  ARBasePrivate.h
// 
////////////////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2007, Fjölnir Ásgeirsson
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification, 
// are permitted provided that the following conditions are met:
// 
// Redistributions of source code must retain the above copyright notice, this list of conditions
// and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, this list of
// conditions and the following disclaimer in the documentation and/or other materials provided with 
// the distribution.
// Neither the name of Fjölnir Ásgeirsson, ninja kitten nor the names of its contributors may be 
// used to endorse or promote products derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#ifndef _ARBASEPRIVATE_H_
#define _ARBASEPRIVATE_H_

#import "ARBase.h"

@class ARRelationship;

#pragma mark -
#pragma mark Private types
typedef enum { 
  ARAttributeSelectorReader  = 1,
  ARAttributeSelectorWriter  = 2,
  ARAttributeSelectorAdder   = 3,
  ARAttributeSelectorRemover = 4,
} ARAttributeSelectorType;

#pragma mark -
#pragma mark Private method definitions
@interface ARBase () // Implemented in ARBase.m
// Returns the column names of the table associated with the model
- (NSArray *)columns;
// Returns the name of the id column (foreign) for a model ARModel would mean modelId
+ (NSString *)idColumnForModel:(Class)modelClass;
+ (NSString *)idColumn;
// Returns the name of the join table for two models
+ (NSString *)joinTableNameForModel:(Class)firstModel and:(Class)secondModel;

- (void)addRecord:(id)record forKey:(NSString *)key ignoreCache:(BOOL)ignoreCache;
- (void)removeRecord:(id)record forKey:(NSString *)key ignoreCache:(BOOL)ignoreCache;
@end

@interface ARBase (KeyAndSelectorParsers) // Implemented in ARBase-KeyAndSelectorParsers.m
- (ARRelationship *)relationshipForKey:(NSString *)key;
- (ARAttributeSelectorType)typeOfSelector:(SEL)aSelector
                            attributeName:(NSString **)outAttribute;
// Does all the heavy lifting when figuring out what to do with the attribute selectors
// (Parses them and then tell what sort of relationship it's for, wether it's a writer,
//  reader, etc.. and what the name of the attribute it affects is
/*- (ARRelationshipType)typeOfSelector:(SEL)aSelector
                       attributeName:(NSString **)outAttribute
                        selectorType:(ARAttributeSelectorType *)selectorType;
// Determines what sort of relationship a key represents
- (ARRelationshipType)relationShipTypeForKey:(NSString *)key;*/
@end

/*! @endcond */

#endif /* _ARBASEPRIVATE_H_ */
