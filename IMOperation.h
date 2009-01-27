//
//  IMOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 12/9/08.
//  Copyright 2008 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IMOperation : NSOperation {
    @protected
    BOOL isExecuting;
    BOOL isFinished;
}
@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;

-(void) run; //override this in subclasses
@end
