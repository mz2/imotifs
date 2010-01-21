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
//  MotifSet.h
//  Motif
//
//  Created by Matias Piipari on 25/03/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Annotable.h>
#ifdef IMOTIFS_COCOA_GUI
@class MotifSetDocument;
#endif

@class Motif;

@interface MotifSet : NSObject <Annotable,NSCoding> {
    NSMutableDictionary *annotations;
    NSMutableArray* motifs;
    
#ifdef IMOTIFS_COCOA_GUI
    MotifSetDocument *motifSetDocument;
#endif
}
@property (copy) NSString *name;
@property (copy) NSString *desc;
@property (readonly) NSMutableDictionary *annotations;
@property (readonly) NSMutableArray *motifs;

#ifdef IMOTIFS_COCOA_GUI
@property (assign,readwrite) MotifSetDocument *motifSetDocument;
#endif

+(MotifSet*) motifSet;

-(void) addMotif:(Motif*) motif;
-(void) addMotif:(Motif*)ms atIndex:(NSUInteger)row;
-(void) addMotifs:(NSArray*)ms atIndex:(NSUInteger)row;
-(void) replaceMotifAtIndex:(NSUInteger) index
                  withMotif:(Motif*) motif;
-(Motif*) motifWithIndex:(NSInteger)i;
-(NSInteger) indexForMotif:(Motif*)m;
-(void) removeMotif:(Motif*) motif;
-(void) removeMotifWithIndex:(NSInteger) i;
-(NSUInteger) count;
-(NSInteger) minOffset;
-(NSInteger) maxColumnIndex;
-(NSInteger) columnCountWithOffsets;
-(void) alignToLeftEnd;
-(NSXMLDocument*) toXMS;
-(NSString*) stringValue;
@end
