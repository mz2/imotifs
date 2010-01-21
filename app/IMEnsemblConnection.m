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
@synthesize organism = _organism;
@synthesize version = _version;

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

-(void) updateActiveOrganismAndVersion {
    NSLog(@"Updating active organism and version to %@",[self activeEnsemblDatabaseName]);
    [[ARBase defaultConnection] executeSQL: [NSString stringWithFormat:@"USE %@",[self activeEnsemblDatabaseName]] 
                             substitutions: nil];
}

-(NSArray*) databases {
    NSArray *results = [[ARBase defaultConnection] executeSQL:@"SHOW DATABASES;" substitutions:nil];
    return results;
}

-(NSArray*) stableIDDisplayLabelDBPrimaryAccessionTuples {
    NSLog(@"Retrieving gene name tuple");
    if (_activeDatabaseNeedsUpdating) {
        [self updateActiveOrganismAndVersion];        
    }
    
    NSArray *results = [[ARBase defaultConnection] executeSQL:
                        @"SELECT gene_stable_id.stable_id,xref.display_label,xref.dbprimary_acc \
                        FROM gene,xref,gene_stable_id \
                        WHERE gene.display_xref_id = xref.xref_id \
                        AND gene_stable_id.gene_id = gene.gene_id \
                        ORDER BY stable_id;" substitutions:nil];
    return results;
}

-(void) setVersion:(NSString *) str {
    if (![str isEqual:_version]) _activeDatabaseNeedsUpdating = YES;
    
    NSLog(@"Setting version %@", str);
	NSString *newVal = [str copy];
	[_version release];
	_version = newVal;
	
    /*
	if ((_version != nil) && (_organism != nil)) {
		[self updateActiveOrganismAndVersion];
	}*/
}

-(void) setOrganism:(NSString *) str {
    if (![str isEqual:_organism]) _activeDatabaseNeedsUpdating = YES;
    
	NSLog(@"Setting organism %@", str);
    NSString *newVal = [str copy];
	[_organism release];
	_organism = newVal;
	
    /*
	if ((_version != nil) && (_organism != nil)) {
		[self updateActiveOrganismAndVersion];
	}*/
}


-(NSString*) activeEnsemblDatabaseName {
    NSLog(@"Active Ensembl database name: %@_core_%@",self.organism,self.version);
	return [NSString stringWithFormat:@"%@_core_%@",self.organism,self.version];
}
@end
