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
//  BestHitsOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 12/8/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MotifComparisonOperation.h"
@class Motif;
@class MotifSetDocument;

extern NSString* const IMClosestMotifMatchScoreKey;
extern NSString* const IMClosestMotifMatchNameKey;

@interface BestHitsOperation : MotifComparisonOperation {
    NSArray *m1s;
    NSArray *m2s;
    
    MotifSetDocument *_motifSetDocument;
    
    @private
    BOOL isReciprocal;
}

-(id) initWithComparitor: (MotifComparitor*) comp 
                    from: (NSArray*) am1 
                      to: (NSArray*) am2;

-(id) initWithComparitor: (MotifComparitor*) comp 
                    from: (NSArray*) am1 
                      to: (NSArray*) am2
              reciprocal: (BOOL) recip;

@property (retain,readonly) NSArray *m1s;
@property (retain,readonly) NSArray *m2s;
@property (readonly) BOOL isReciprocal;

@property (nonatomic,retain) MotifSetDocument *motifSetDocument;

@end
