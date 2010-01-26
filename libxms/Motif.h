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
//  motif.h
//  objc
//
//  Created by Matias Piipari on 23/03/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Multinomial.h>
#import <Alphabet.h>
#import <Annotable.h>

#ifndef IMMotifColorAlpha
#define IMMotifColorAlpha (CGFloat) 0.2
#endif

@interface Motif : NSObject <Annotable, NSCopying, NSCoding> {
	NSString* name;
    Alphabet* alphabet;
	NSArray* columns;
    NSMutableDictionary *annotations;
    NSInteger offset;
    NSColor *color;
    double threshold;
    
#ifdef IMOTIFS_COCOA_GUI
    NSImage *cachedImage;
#endif
}

@property (readwrite,copy) NSString* name;
@property (retain, readonly) Alphabet* alphabet;
@property (retain, readonly) NSArray* columns;
@property (retain, readwrite) NSMutableDictionary* annotations;
@property (readwrite) NSInteger offset;
@property (retain,readwrite) NSColor *color;
@property (readwrite) double threshold;

@property (readonly) NSArray *annotationValues;

-(id)initWithAlphabet:(Alphabet*)alpha
               andColumns:(NSArray*)columns;

-(id)initWithAlphabet:(Alphabet*)alpha
      fromConsensusString:(NSString*)str;

-(id)initWithMotif:(Motif*)motif;

-(void) addPseudocounts:(double) cnt;
//-(Motif*) motifByAddingPseudoCounts:(
- (Multinomial*) column:(int)index;

- (NSArray*) exportedColumns;
- (int) columnCount;
-(NSString*)consensusString;
-(double) informationContent;

-(void) incrementOffset;
-(void) decrementOffset;
-(Motif*) reverseComplement;

-(NSXMLElement*) toXMSMotifNode;

-(void) removeColumnAtIndex:(NSInteger) i;

-(void) clearCachedValues;
@end