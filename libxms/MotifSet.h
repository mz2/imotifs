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
@end
