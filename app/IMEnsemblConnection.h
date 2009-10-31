//
//  IMEnsemblConnection.h
//  iMotifs
//
//  Created by Matias Piipari on 30/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IMEnsemblConnection : NSObject {
    NSString *databaseName;
}
@property (copy, readwrite) NSString *databaseName;

- (void) useDatabase:(NSString*)dbName;

-(NSArray*) databases;
- (NSArray*) stableIDDisplayLabelDBPrimaryAccessionTuples;
@end
