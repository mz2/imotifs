////////////////////////////////////////////////////////////////////////////////////////////
//
// ActiveRecord.h
// A simple to use database framework.
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
#ifndef _ACTIVERECORD_H_ 
#define _ACTIVERECORD_H_ 
#import <ActiveRecord/ARBase.h>
#import <ActiveRecord/ARBase+Finders.h>

#import <ActiveRecord/ARConnection.h>
#import <ActiveRecord/ARSQLiteConnection.h>
#if (TARGET_OS_MAC && !TARGET_OS_IPHONE)
#	import <ActiveRecord/ARMySQLConnection.h>
#endif

#import <ActiveRecord/ARRelationship.h>
#import <ActiveRecord/ARRelationshipHasMany.h>
#import <ActiveRecord/ARRelationshipHasManyThrough.h>
#import <ActiveRecord/ARRelationshipHasOne.h>
#import <ActiveRecord/ARRelationshipBelongsTo.h>
#import <ActiveRecord/ARRelationshipHABTM.h>
#import <ActiveRecord/ARRelationshipColumn.h>

#import <ActiveRecord/ARBaseArrayInterface.h>

#if (TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR)
#	import "NSObject+iPhoneHacks.h"
#endif

#endif /* _ACTIVERECORD_H_ */
