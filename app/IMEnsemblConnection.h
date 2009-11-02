//
//  IMEnsemblConnection.h
//  iMotifs
//
//  Created by Matias Piipari on 30/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IMEnsemblConnection : NSObject {
    NSString *_organism;
	NSString *_version;
    
    BOOL _activeDatabaseNeedsUpdating;
}
@property (copy, readwrite) NSString *organism;
@property (copy, readwrite) NSString *version;

//-(void) updateActiveOrganismAndVersion;

-(NSArray*) databases;
- (NSArray*) stableIDDisplayLabelDBPrimaryAccessionTuples;

-(NSString*) activeEnsemblDatabaseName;
@end
