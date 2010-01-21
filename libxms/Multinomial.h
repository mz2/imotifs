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
