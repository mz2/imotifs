//
//  alphabet.h
//  objc
//
//  Created by Matias Piipari on 24/03/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Symbol.h>


@interface Alphabet : NSObject <NSCoding> {
	NSString* name;
	NSMutableArray* symbols;
}
NSMutableArray* nameRegistry;

@property (copy) NSString *name;
@property (readonly) NSMutableArray *symbols;

- (Symbol*) symbolWithName:(NSString*) name;
- (int) index:(Symbol*) symbol;
- (bool) containsSymbolWithName:(NSString*) name;

+ (Alphabet*) dna;
+ (Alphabet*) protein;
+ (Alphabet*) withName:(NSString*) name;

- (void)dealloc;


@end
