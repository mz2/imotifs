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
//  MotifsBelowDistanceCutoffOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 1/5/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MotifComparisonOperation.h"
@class Motif;
@class MotifSetController;

@interface MotifsBelowDistanceCutoffOperation : MotifComparisonOperation {
    Motif *motif;
    MotifSetController *motifSetController;
}

@property (retain,readonly) Motif* motif;
@property (retain,readonly) MotifSetController *motifSetController;


- (id) initWithComparitor: (MotifComparitor*) comp 
                    motif: (Motif*) motif 
againstMotifsControlledBy: (MotifSetController*) motifSetController;

@end
