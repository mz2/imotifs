//
//  IMAnnotation.m
//  iMotifs
//
//  Created by Matias Piipari on 06/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IMAnnotation.h"


@implementation IMAnnotation
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
    return [NSString stringWithFormat:@"%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@",
            _seqName,
            _source,
            _feature,
            _start,
            _end,
            _score,
            _strand,
            _attributes];
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