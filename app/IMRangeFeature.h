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
//  IMRangeAnnotation.h
//  iMotifs
//
//  Created by Matias Piipari on 07/01/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMFeature.h"
#import "IMPositionedFeature.h"

@interface IMRangeFeature : IMPositionedFeature {
    NSInteger _start;
	NSInteger _end;
}

@property(nonatomic,assign) NSInteger start;
@property(nonatomic,assign) NSInteger end;

-(NSInteger) length;

// init
- (id)init;
- (id)initWithStart:(NSInteger)aStart 
                end:(NSInteger)anEnd
              score:(CGFloat)score
             strand:(IMStrand)strand
               type:(NSString*)type;
+ (id)rangeFeatureWithStart:(NSInteger)aStart 
                        end:(NSInteger)anEnd
                      score:(CGFloat)score
                     strand:(IMStrand)strand
                       type:(NSString*)type;

@end