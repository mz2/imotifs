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
//  IMIntMatrix2DIface.h
//  iMotifs
//
//  Created by Matias Piipari on 20/07/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol IMIntMatrix2DIface <NSObject>
-(id<IMIntMatrix2DIface>) transpose;

-(NSUInteger) rows;
-(NSUInteger) columns;
-(NSUInteger) elements;
-(NSInteger) valueAtRow:(NSUInteger)row col:(NSUInteger)col;
-(void) setValue:(NSInteger)v 
             row:(NSUInteger) row 
             col:(NSUInteger) col;

@end