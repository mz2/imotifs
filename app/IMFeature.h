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
//  IMFeature.h
//  iMotifs
//
//  Created by Matias Piipari on 08/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IMFeature : NSObject {
	CGFloat _score;
	BOOL _selected;
    IMStrand _strand;
    NSString *_type;
    NSColor *_color;
}

@property(nonatomic,assign) CGFloat score;
@property(nonatomic,assign) BOOL selected;
@property(nonatomic,assign) IMStrand strand;
@property(nonatomic,retain) NSString *type;
@property(nonatomic,retain) NSColor *color;


@end
