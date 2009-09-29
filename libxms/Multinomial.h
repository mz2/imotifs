//
//  multinomial.h
//  objc
//
//  Created by Matias Piipari on 23/03/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Alphabet.h>
#import <Symbol.h>
#import <math.h>

@interface Multinomial : NSObject <NSCoding> {
	BOOL highlighted;

    @protected 
    Alphabet* alphabet;
    NSMutableDictionary* weights;
    
}

@property (readwrite) BOOL highlighted;
- (id) initWithAlphabet:(Alphabet*) alpha;
- (id) initWithMultinomial:(Multinomial*) multinomial;

+ (id) multinomialWithAlphabet:(Alphabet*) alpha;
+ (id) multinomialWithMultinomial:(Multinomial*) multinomial;
- (Multinomial*) complement;
//- (Multinomial*) uniformAcrossAlphabet:(Alphabet*) alpha;

- (void)symbol: (Symbol*)symbol withWeight: (double)weight;
- (double)weightForSymbol: (Symbol*)symbol;
-(void) setWeightsFromConsensus: (NSString*)c;

- (double) totalBits;
- (double) informationContent;
- (NSArray*) symbolsWithWeightsInDescendingOrder;

- (Alphabet*) alphabet;

-(void) addPseudocounts:(double) cnt;

- (NSXMLElement*) toXMSDistributionNode;
-(void) clearCachedValues;
@end
