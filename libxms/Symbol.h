//
//  symbol.h
//  objc
//
//  Created by Matias Piipari on 24/03/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Symbol : NSObject < NSCopying,NSCoding > {
	NSColor *defaultFillColor;
    NSColor *defaultEdgeColor;
    
    @private
    NSString* primaryName;
    NSString* shortName;
    NSString* longName;
	NSSet* names;
}
NSMutableArray* symbolRegistry;

@property (retain,readwrite) NSColor* defaultFillColor;
@property (retain,readwrite) NSColor* defaultEdgeColor;

- (NSString*) primaryName;
- (NSString*) shortName;
- (NSString*) longName;
- (NSSet*) names;
- (bool) hasName:(NSString*)name;
- (Symbol*) initWithNames:(NSString*) str, ...;
- (id)copyWithZone:(NSZone *) zone;
- (BOOL)isEqual:(id)anObject;
@end
