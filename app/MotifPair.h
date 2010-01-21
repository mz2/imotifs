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
//  MotifPair.h
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MotifPair.h"
#import "Motif.h"

@interface MotifPair : NSObject {
    Motif* m1;
    Motif* m2;
    BOOL flipped;
    double score;
    NSInteger offset;
}

@property (readonly) Motif *m1;
@property (readonly) Motif *m2;
@property (readonly) BOOL flipped;
@property (readonly) double score;
@property (readonly) NSInteger offset;

-(MotifPair*) initWithMotif: (Motif*)a 
                   andMotif: (Motif*)b 
                      score: (double)score 
                    flipped: (BOOL)yesno 
                     offset: (NSInteger) offset;
@end
