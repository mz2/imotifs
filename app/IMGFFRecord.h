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
//  IMAnnotation.h
//  iMotifs
//
//  Created by Matias Piipari on 06/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMFeature;

@interface IMGFFRecord : NSObject {
    NSString *_seqName;
    NSString *_source;
    NSString *_feature;
    NSInteger _start;
    NSInteger _end;
    double _score;
    IMStrand _strand;
    NSString *_attributes;
}
    
@property(nonatomic,retain)NSString *seqName;
@property(nonatomic,retain)NSString *source;
@property(nonatomic,retain)NSString *feature;
@property(nonatomic,assign)NSInteger start;
@property(nonatomic,assign)NSInteger end;
@property(nonatomic,assign)double score;
@property(nonatomic,assign)IMStrand strand;
@property(nonatomic,readonly)NSString *strandString;
@property(nonatomic,retain)NSString *attributes;
@property(readonly) NSUInteger gffStart;
@property(readonly) NSUInteger gffEnd;

- (id)initWithSeqName:(NSString*)aSeqName
               source:(NSString*)aSource
              feature:(NSString*)aFeature
                start:(NSInteger)aStart
                  end:(NSInteger)anEnd
                score:(double)aScore
               strand:(IMStrand)aStrand
           attributes:(NSString*)anAttributes;

-(NSString*) identifier;

-(IMFeature*) toFeature;

@end
