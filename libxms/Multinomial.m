//
//  multinomial.m
//  objc
//
//  Created by Matias Piipari on 23/03/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Multinomial.h>
#import <Symbol.h>
#import <math.h>

@implementation Multinomial
@synthesize highlighted;

- (id) init
{
    self = [super init];
    if (self != nil) {
        @throw [NSException exceptionWithName:@"IllegaInitMessageException" 
                                       reason:@"Use -initWithAlphabet: instead"
                                     userInfo:nil];
    }
    return self;
}

- (id) initWithAlphabet:(Alphabet*) alpha {
    [super init];
	alphabet = [alpha retain];
    
	int symCount = [[alpha symbols] count];
	double uniformWeight = 1.0/(double)symCount;
	weights = [[NSMutableDictionary alloc] init];
	
	for (Symbol* sym in [alphabet symbols]) {
		[self symbol:sym withWeight:uniformWeight];        
    }
	
	return self;
}

- (id) initWithMultinomial:(Multinomial*)m {
    self = [super init];
    weights = [[NSMutableDictionary alloc] init];
    
    if (self != nil) {
        alphabet = [m.alphabet retain];
        for (Symbol *sym in alphabet.symbols) {
            [self symbol:sym withWeight:[m weightForSymbol:sym]];
        }        
    }
    return self;
}


- (void) dealloc {
	[alphabet release];
	[weights release];
    //[weightArray release];
	
	[super dealloc];
}


- (id) initWithCoder:(NSCoder*)coder {
    [super init];
    //DebugLog(@"Multinomial: initWithCoder");
    alphabet = [[coder decodeObjectForKey:@"alphabet"] retain];
    //weightArray = [[coder decodeObjectForKey:@"weightArray"] retain];
    weights = [[coder decodeObjectForKey:@"weights"] retain];
    highlighted = [coder decodeBoolForKey:@"highlighted"];
    return self;
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:alphabet forKey:@"alphabet"];
    [coder encodeObject:weights forKey:@"weights"];
    [coder encodeBool:highlighted forKey:@"highlighted"];
}

+ (id) multinomialWithAlphabet:(Alphabet*) alpha {
    return [[[Multinomial alloc] initWithAlphabet:alpha] autorelease];
}

+ (id) multinomialWithMultinomial:(Multinomial*) multinomial {
    return [[[Multinomial alloc] initWithMultinomial:multinomial] autorelease];
}

- (void) symbol: (Symbol*)sym withWeight: (double)weight {
    [self clearCachedValues];
    
    [weights setObject:[NSNumber numberWithDouble:weight] 
                forKey:sym];
}

- (double) weightForSymbol: (Symbol*)symbol {
    return [[weights objectForKey: symbol] doubleValue];
}

- (const Alphabet*) alphabet {
    return alphabet;
}

- (double) entropy:(Symbol*)sym {
	double w, ent;
	if ([self alphabet] == nil) {
		@throw [NSException exceptionWithName:@"SymbolWeightException"
                            reason:@"Symbol alphabet or weight is null!"  userInfo:nil];
	}
	w = [self weightForSymbol: sym];
	
	ent = -w * log2(w);
	if (w == 0) {return 0.0;}
	
	return ent;
}

- (double) totalBits {
	int symCount;
	symCount = [ [ [ self alphabet ] symbols ] count ];
	return log2(symCount);
}

- (double) informationContent {
	double inf = [ self totalBits ];
	for (Symbol* sym in [ [ self alphabet ] symbols] ) {
		inf -= [ self entropy:sym ];
	}
	
	return inf;
}

- (NSArray*) symbolsWithWeightsInDescendingOrder {
	return [ weights keysSortedByValueUsingSelector: @selector(compare:) ];
}

- (NSString*) description {
    NSMutableString *str = [NSMutableString stringWithString:@""];
    //DebugLog(@"Alphabet:%@",alphabet);
    for (Symbol* sym in [alphabet symbols]) {
        [str appendFormat:@"%@ => %.3g ",sym,[self weightForSymbol:sym]];
    }
    [str appendFormat:@" (%.3g bits, alphabet: %@) \n",[self informationContent], [[self alphabet] name]];
    return str;
}

- (Multinomial*) complement {
    Multinomial *m = [[Multinomial alloc] initWithAlphabet:[self alphabet]];
    for (Symbol *sym in [[self alphabet] symbols]) {
        if ([[sym shortName] isEqual:@"a"]) {
            [m symbol:[[self alphabet] symbolWithName:@"t"] 
           withWeight:[self weightForSymbol:sym]];
        } else if ([[sym shortName] isEqual:@"c"]) {
            [m symbol:[[self alphabet] symbolWithName:@"g"] 
           withWeight:[self weightForSymbol:sym]];
        } else if ([[sym shortName] isEqual:@"g"]) {
            [m symbol:[[self alphabet] symbolWithName:@"c"] 
           withWeight:[self weightForSymbol:sym]];
        } else if ([[sym shortName] isEqual:@"t"]) {
            [m symbol:[[self alphabet] symbolWithName:@"a"] 
           withWeight:[self weightForSymbol:sym]];
        }
    }
    return [m autorelease];
}


-(void) setWeightsFromConsensus: (NSString*)c {
    [self clearCachedValues];
    
    if (![alphabet isEqual:[Alphabet dna]]) {
        @throw [NSException exceptionWithName:@"IMInvalidAlphabetException"  
                                       reason:@"Only dna alphabet supported for now" 
                                     userInfo:nil];
    }
    
    for (Symbol *sym in [alphabet symbols]) {
        [self symbol:sym withWeight:0.0];
    }
    
    if ([c isEqual: @"a"]) {
        [self symbol:[[Alphabet dna] symbolWithName:@"a"] withWeight:1.0];
    } else if ([c isEqual: @"c"]) {
        [self symbol:[[Alphabet dna] symbolWithName:@"c"] withWeight:1.0];
    } else if ([c isEqual: @"g"]) {
        [self symbol:[[Alphabet dna] symbolWithName:@"g"] withWeight:1.0];
    } else if ([c isEqual: @"t"]) {
        [self symbol:[[Alphabet dna] symbolWithName:@"t"] withWeight:1.0];
    } else if ([c isEqual: @"r"]) { //purine (a,g)
        [self symbol:[[Alphabet dna] symbolWithName:@"a"] withWeight:0.5];
        [self symbol:[[Alphabet dna] symbolWithName:@"g"] withWeight:0.5];
    } else if ([c isEqual: @"y"]) { //pyrimidine (t,c)
        [self symbol:[[Alphabet dna] symbolWithName:@"t"] withWeight:0.5];
        [self symbol:[[Alphabet dna] symbolWithName:@"c"] withWeight:0.5];
    } else if ([c isEqual: @"w"]) { //a or t
        [self symbol:[[Alphabet dna] symbolWithName:@"a"] withWeight:0.5];
        [self symbol:[[Alphabet dna] symbolWithName:@"t"] withWeight:0.5];
    } else if ([c isEqual: @"s"]) { //g or c
        [self symbol:[[Alphabet dna] symbolWithName:@"g"] withWeight:0.5];
        [self symbol:[[Alphabet dna] symbolWithName:@"c"] withWeight:0.5];
    } else if ([c isEqual: @"m"]) { //a or c
        [self symbol:[[Alphabet dna] symbolWithName:@"a"] withWeight:0.5];
        [self symbol:[[Alphabet dna] symbolWithName:@"c"] withWeight:0.5];
    } else if ([c isEqual: @"k"]) { //g or t
        [self symbol:[[Alphabet dna] symbolWithName:@"g"] withWeight:0.5];
        [self symbol:[[Alphabet dna] symbolWithName:@"t"] withWeight:0.5];
    } else if ([c isEqual: @"h"]) { //a,t,c
        [self symbol:[[Alphabet dna] symbolWithName:@"a"] withWeight:0.333333333];
        [self symbol:[[Alphabet dna] symbolWithName:@"t"] withWeight:0.333333333];
        [self symbol:[[Alphabet dna] symbolWithName:@"c"] withWeight:0.333333333];
    } else if ([c isEqual: @"b"]) { //g,c,t
        [self symbol:[[Alphabet dna] symbolWithName:@"g"] withWeight:0.333333333];
        [self symbol:[[Alphabet dna] symbolWithName:@"c"] withWeight:0.333333333];
        [self symbol:[[Alphabet dna] symbolWithName:@"t"] withWeight:0.333333333];
    } else if ([c isEqual: @"v"]) { //g,a,c
        [self symbol:[[Alphabet dna] symbolWithName:@"g"] withWeight:0.333333333];
        [self symbol:[[Alphabet dna] symbolWithName:@"a"] withWeight:0.333333333];
        [self symbol:[[Alphabet dna] symbolWithName:@"c"] withWeight:0.333333333];
    } else if ([c isEqual: @"d"]) { // g,a,t
        [self symbol:[[Alphabet dna] symbolWithName:@"g"] withWeight:0.333333333];
        [self symbol:[[Alphabet dna] symbolWithName:@"a"] withWeight:0.333333333];
        [self symbol:[[Alphabet dna] symbolWithName:@"t"] withWeight:0.333333333];
    } else if ([c isEqual: @"n"]) {
        for (Symbol *sym in [[self alphabet] symbols]) {
            [self symbol:sym withWeight:1.0/[[alphabet symbols] count]];
        }
    }
}

- (NSXMLElement*) toXMSDistributionNode {
    //DebugLog(@"Motif: toXMSDistributionNode");
    NSXMLElement *distElem = [NSXMLElement elementWithName:@"column"];
    
    for (Symbol *sym in [[self alphabet] symbols]) {
        double w = [self weightForSymbol:sym];
        NSXMLElement *weightNode = [NSXMLElement elementWithName:@"weight" stringValue:[[NSString alloc] initWithFormat:@"%g",w]];
        NSXMLNode *symbolAttribNode = [NSXMLNode attributeWithName:@"symbol" 
                                                       stringValue:[sym longName]];
        [weightNode addAttribute:[symbolAttribNode retain]];
        [distElem addChild:[weightNode retain]];
    }
    
    return [distElem autorelease];
}

-(void) clearCachedValues {
    
}

-(void) addPseudocounts:(double) cnt {
    double sum = 0.0;
    for (Symbol *sym in self.alphabet.symbols) {
        double w = [self weightForSymbol: sym];
        sum += (w + cnt);
        [self symbol: sym withWeight: w + cnt];
    }
    
    for (Symbol *sym in self.alphabet.symbols) {
        double w = [self weightForSymbol: sym];
        [self symbol: sym withWeight: w / sum];
    }
}

@end
