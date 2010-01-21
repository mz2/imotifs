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
//  SymbolBounds.h
//  iMotifs
//
//  Created by Matias Piipari on 12/05/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SymbolBounds : NSObject {
    double min;
    double max;
    double mean;
}

@property (readwrite) double min;
@property (readwrite) double max;
@property (readwrite) double mean;

- (id) initWithMin:(double) mi Max:(double)ma mean:(double) me;
+ (SymbolBounds*) boundsWithMin:(double) mi 
                            max:(double)ma 
                           mean:(double) me;

@end
