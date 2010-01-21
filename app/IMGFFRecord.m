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
//  IMAnnotation.m
//  iMotifs
//
//  Created by Matias Piipari on 06/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IMGFFRecord.h"
#import "IMFeature.h"
#import "IMRangeFeature.h"
#import "IMPointFeature.h"

@implementation IMGFFRecord
@synthesize seqName = _seqName;
@synthesize source = _source;
@synthesize feature = _feature;
@synthesize start = _start;
@synthesize end = _end;
@synthesize score = _score;
@synthesize strand = _strand;
@synthesize attributes = _attributes;


// init
- (id)init
{
    if (self = [super init]) {
        [self setSeqName: @""];
        [self setSource: @""];
        [self setFeature: @""];
        [self setStart: 1];
        [self setEnd: 1];
        [self setScore: 0];
        [self setStrand: IMStrandNA];
        [self setAttributes: @""];
    }
    return self;
}

- (id)initWithSeqName:(NSString*)aSeqName
               source:(NSString*)aSource
              feature:(NSString*)aFeature
                start:(NSInteger)aStart
                  end:(NSInteger)anEnd
                score:(double)aScore
               strand:(IMStrand)aStrand
           attributes:(NSString*)anAttributes 
{
    if (self = [super init]) {
        [self setSeqName:aSeqName];
        [self setSource:aSource];
        [self setFeature:aFeature];
        [self setStart:aStart];
        [self setEnd:anEnd];
        [self setScore:aScore];
        [self setStrand:aStrand];
        [self setAttributes:anAttributes];
    }
    return self;
}

-(NSString*) strandString {
    if (self.strand == IMStrandPositive) {
        return @"Positive";
    } else if (self.strand == IMStrandNegative) {
        return @"Negative";
    }
    return @"Undefined";
}

-(NSString*) description {
    return [NSString stringWithFormat:
            @"%@\t%@\t%@\t%d\t%d\t%f\t%d\t%@",
            _seqName,
            _source,
            _feature,
            _start,
            _end,
            _score,
            _strand,
            _attributes];
}

-(NSString*) identifier {
	//GFFs start counting at 1
    return [NSString stringWithFormat:@"%@_%@_%d_%d_%d",self.seqName,self.feature,self.start+1,self.end+1,self.score];
}

-(IMFeature*) toFeature {
    if (self.start == self.end) {
        return [IMPointFeature pointFeatureWithPosition:self.start 
												 strand:self.strand
                                                   type:self.feature];
    } else {
        return [IMRangeFeature rangeFeatureWithStart:self.start 
												 end:self.end 
											   score:self.score 
											  strand:self.strand
                                                type:self.feature];
    }
    return nil;
}

-(NSUInteger) gffStart {
    return [self start] + 1;
}

-(NSUInteger) gffEnd{
    return [self end] + 1;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [_seqName release], _seqName = nil;
    [_source release], _source = nil;
    [_feature release], _feature = nil;
    [_attributes release], _attributes = nil;
    
    [super dealloc];
}

@end