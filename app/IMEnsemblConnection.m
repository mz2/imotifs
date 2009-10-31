//
//  IMEnsemblConnection.m
//  iMotifs
//
//  Created by Matias Piipari on 30/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IMEnsemblConnection.h"
#import <ActiveRecord/ActiveRecord.h>

@interface IMEnsemblConnection (private)
-(void) setUpMySQLConnection;
@end


@implementation IMEnsemblConnection
@synthesize databaseName;

-(id) init {
    self = [super init];
    if (self == nil) return nil;
    
    [self setUpMySQLConnection];
    
    return self;
}

- (void) setUpMySQLConnection {
    NSError *err = nil;
    ARMySQLConnection *connection = 
    [ARMySQLConnection openConnectionWithInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblBaseURL"], @"host",
                                               [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblUser"], @"user",
                                               [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblPassword"] , @"password",
                                               [[NSUserDefaults standardUserDefaults] objectForKey:@"IMEnsemblPort"], @"port", nil]
                                        error:&err];
	if(err != nil) {
        NSLog(@"There was an error connecting to MySQL: %@", [err description]);
        return;        
    } else {
        NSLog(@"Connected to MySQL database at %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblBaseURL"]);
    }
	// See if it works
	[ARBase setDefaultConnection:connection];
}

-(void) useDatabase:(NSString*) dbName {
    self.databaseName = dbName;
    [[ARBase defaultConnection] executeSQL: [NSString stringWithFormat:@"USE %@",dbName] 
                             substitutions: nil];
}

-(NSArray*) databases {
    NSArray *results = [[ARBase defaultConnection] executeSQL:@"SHOW DATABASES;" substitutions:nil];
    return results;
}

-(NSArray*) stableIDDisplayLabelDBPrimaryAccessionTuples {
    NSArray *results = [[ARBase defaultConnection] executeSQL:
                        @"SELECT gene_stable_id.stable_id,xref.display_label,xref.dbprimary_acc \
                        FROM gene,xref,gene_stable_id \
                        WHERE gene.display_xref_id = xref.xref_id \
                        AND gene_stable_id.gene_id = gene.gene_id \
                        ORDER BY stable_id;" substitutions:nil];
    return results;
}

@end
