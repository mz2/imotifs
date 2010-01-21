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
//  MotifPair.m
//  iMotifs
//
//  Created by Matias Piipari on 19/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "MotifPair.h"

@implementation MotifPair
@synthesize m1,m2,flipped,score,offset;

-(MotifPair*) initWithMotif: (Motif*)a 
                   andMotif: (Motif*)b 
                      score: (double)s 
                    flipped: (BOOL)yesno
                     offset: (NSInteger) offs {
    m1 = [a retain];
    m2 = [b retain];
    flipped = yesno;
    score = s;
    offset = offs;
    return self;
}

-(BOOL) isEqual:(id)o {
    if ([o isKindOfClass:[MotifPair class]]) {
        return false;
    }
    
    MotifPair *po = (MotifPair*) o;
    return m1 == po.m1 && m2 == po.m2;
}

-(NSUInteger) hash {
    return [m1 hash] * 37 + [m2 hash];
}

-(void) dealloc {
    [m1 release];
    m1 = nil;
    [m2 release];
    m2 = nil;
    [super dealloc];
}
@end
