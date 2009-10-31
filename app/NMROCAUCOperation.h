//
//  NMROCAUCOperation.h
//  iMotifs
//
//  Created by Matias Piipari on 31/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMTaskOperation.h"

@interface NMROCAUCOperation : IMTaskOperation {

    NSString *_motifsFile;
    NSString *_positiveSeqsFile;
    NSString *_negativeSeqsFile;
    NSString *_outputFile;
    
    NSUInteger _bootstraps;
}

@property (retain, readwrite) NSString *motifsFile;
@property (retain, readwrite) NSString *positiveSeqsFile;
@property (retain, readwrite) NSString *negativeSeqsFile;
@property (retain, readwrite) NSString *outputFile;

@property (readwrite) NSUInteger bootstraps;

-(BOOL) motifsFileExists;
-(BOOL) positiveSeqsFileExists;
-(BOOL) negativeSeqsFileExists;

-(IBAction) cancel:(id) sender;
-(IBAction) ok:(id) sender;

@end