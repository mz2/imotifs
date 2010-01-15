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
