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
