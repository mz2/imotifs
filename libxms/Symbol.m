/*
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the
Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
Boston, MA  02110-1301, USA.
*/
//
//  symbol.m
//  objc
//
//  Created by Matias Piipari on 24/03/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Symbol.h>

@implementation Symbol
@synthesize defaultEdgeColor;
@synthesize defaultFillColor;

-(Symbol*) initWithNameSet:(NSSet*) ns primaryName:(NSString*)primName {
    [super init];
    primaryName = [primName retain];
    names = [ns retain];
    
    if ([symbolRegistry containsObject:self]) {
        PCLog(@"An existing symbol was found. Will release and deallocate self and return a pointer to the existing object");
        Symbol *sym = [symbolRegistry objectAtIndex:[symbolRegistry indexOfObject:self]];
        
        [primaryName release];
        primaryName = nil;
        [names release];
        names = nil;
        [self dealloc];
        
        return sym;
    } else {
        [symbolRegistry addObject:self];
    }
    
    return self;
}
-(Symbol*) initWithNames:(NSString*) str, ... {
    [super init];
    
	NSString *primName = str;
    NSMutableSet *ns = [[NSMutableSet alloc] init];
	
	NSString* eachObject;
	va_list argumentList;
	if (str) {
		[ns addObject:str];
		va_start(argumentList, str);
		while (eachObject = va_arg(argumentList, NSString*)) {
			[ns addObject: eachObject];
		}
		va_end(argumentList);
	}
    
	return [self initWithNameSet:ns 
                     primaryName:primName];
}

-(void) dealloc {
	[primaryName release];
    [shortName release];
    [longName release];
	[names release];
	[super dealloc];
}

- (id) initWithCoder:(NSCoder *)coder {
    PCLog(@"Symbol: initWithCoder");
    
    NSMutableSet *ns = [[coder decodeObjectForKey:@"names"] retain];
    NSString *primName = [[coder decodeObjectForKey:@"primaryName"] retain];
    
    Symbol *sym = [[Symbol alloc] initWithNameSet:[ns copyWithZone:nil]    
                                      primaryName:primName];
    
    /*if (![symbolRegistry containsObject:sym]) {
        @throw [NSException exceptionWithName:@"IMInvalidSymbolException" 
                                       reason:@"Only symbols present in the symbol registry can be encoded/decoded" 
                                     userInfo:nil];
    }*/
    
    [sym setDefaultEdgeColor: [coder decodeObjectForKey:@"defaultEdgeColor"]];
    [sym setDefaultFillColor: [coder decodeObjectForKey:@"defaultFillColor"]];
    return sym;
}

- (void) encodeWithCoder:(NSCoder *)coder {
    PCLog(@"Symbol: encodeWithCoder");
    
    /*
    if (![symbolRegistry containsObject:self]) {
        @throw [NSException exceptionWithName:@"IMInvalidSymbolException" 
                                       reason:@"Only symbols present in the symbol registry can be encoded/decoded" 
                                     userInfo:nil];
    }*/
    [coder encodeObject:names forKey:@"names"];
    [coder encodeObject:primaryName forKey:@"primaryName"];
    [coder encodeObject:defaultFillColor forKey:@"defaultFillColor"];
    [coder encodeObject:defaultEdgeColor forKey:@"defaultEdgeColor"];
}

/*
-(NSString*) description {
    NSMutableString* str = [NSMutableString stringWithString:@"Symbol"];
    for (NSString* desc in names) {
        [str appendFormat:@" %@",desc];
    } 
    return str;
}*/

-(NSString*) description {
    return [self primaryName];
}

-(NSString*) primaryName {return primaryName;}

-(NSString*) shortName {
    if (shortName) return shortName;
    
    NSString *shortestStr = nil;
    NSUInteger shortestLen = NSUIntegerMax;
    
    for (NSString *str in names) {
        if ([str length] < shortestLen) {
            shortestStr = str;
            shortestLen = [str length];
        } 
    }
    shortName = shortestStr;
    [shortName retain];
    return shortName;
}

-(NSString*) longName {
    if (longName) return longName;
    
    NSString *longestStr = nil;
    NSUInteger longestLen = 0;
    for (NSString *str in names) {
        if ([str length] > longestLen) {
            longestStr = str;
            longestLen = [str length];
        }
    }
    longName = longestStr;
    [longName retain];
    return longName;
}

-(NSSet*) names {return names;}

-(bool) hasName:(NSString*)name {
	return [names containsObject: name];
}

- (BOOL) isEqual:(id) obj {
	if (self == obj)
		return true;
	if (obj == nil)
		return false;
		
	if (![self isKindOfClass: [ obj class ] ])
		return false;
	
	if (names == nil) {
		if ( [obj names] != nil )
			return false;
	} else if (![ names isEqualToSet: (NSSet*)[obj names] ])
		return false;
		
	return true;
}

- (NSUInteger) hash {
	int prime = 31;
	int result = 1;
	result = prime * result + ((names == nil) ? 0 : [ names hash ]);
	return result;
}

- (id)copyWithZone:(NSZone*)zone {
    return [ self retain ];
}
@end
