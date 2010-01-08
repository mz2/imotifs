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
}


@property(nonatomic,assign) CGFloat score;
@property(nonatomic,assign) BOOL selected;


@end
