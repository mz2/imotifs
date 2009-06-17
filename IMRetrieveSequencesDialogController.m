//
//  IMRetrieveSequencesDialogController.m
//  iMotifs
//
//  Created by Matias Piipari on 11/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IMRetrieveSequencesDialogController.h"
#import <ActiveRecord/ActiveRecord.h>


@interface IMRetrieveSequencesDialogController (private) 
-(void) setUpMySQLConnection;
@end


@implementation IMRetrieveSequencesDialogController
//@synthesize geneNamePatternString;
@synthesize specifyGenesBySearching, specifyGenesFromFile;

@synthesize searchField;
@synthesize foundGeneListController;
@synthesize selectedGeneListController;
@synthesize organismListController;
@synthesize schemaVersionListController;
@synthesize searchType;

@synthesize organism;

- (void) awakeFromNib {
    NSLog(@"Awakening IMRetrieveSequencesDialogController from Nib");
    self.specifyGenesBySearching = NO;
    self.specifyGenesFromFile = NO;
    
    [self setUpMySQLConnection];
}

- (void) setUpMySQLConnection {
    NSError *err = nil;
    ARMySQLConnection *connection = 
        [ARMySQLConnection openConnectionWithInfo:[NSDictionary dictionaryWithObjectsAndKeys:
               [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblBaseURL"], @"host",
               [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblUser"], @"user",
               [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblPassword"] , @"password",
               [NSNumber numberWithInt:5306], @"port", nil]
                                            error:&err];
	if(err != nil) {
        NSLog(@"There was an error connecting to MySQL: %@", [err description]);
        return;        
    } else {
        NSLog(@"Connected to MySQL database at %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"IMEnsemblBaseURL"]);
    }
	// See if it works
	[ARBase setDefaultConnection:connection];
    
    
    NSLog(@"Organism list: %@",[self organismList]);
    if (self.organismList.count > 0) {
        [self setOrganism:[[self organismList] objectAtIndex: 0]];
        NSLog(@"Schema version list: %@",[self schemaVersionList]);
    } else {
        NSLog(@"No organisms");
    }

}

-(NSArray*) organismList {
    if (_organismList == nil) {
        _organismList = [[[self.schemaVersionsForOrganisms allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] retain];
    }
    
    return _organismList;
}

-(NSArray*) schemaVersionList {
    if (_schemaVersionList == nil) {
        if (self.organism == nil) {
            
            _schemaVersionList == [[NSArray alloc] init];
        }
        else {
            _schemaVersionList = [[self.schemaVersionsForOrganisms objectForKey:self.organism] retain];
        }
    }
    
    return _schemaVersionList;
}

-(NSDictionary*) schemaVersionsForOrganisms  {
    
    if (_schemaVersionsForOrganisms == nil) {
        NSMutableDictionary *versions = [[NSMutableDictionary alloc] init];
        
        NSArray *results = [[ARBase defaultConnection] executeSQL:@"SHOW DATABASES;" substitutions:nil];
        for (NSDictionary *dict in results) {
            NSString *dbName = [dict objectForKey: @"Database"];
            NSRange rangeToCore = [dbName rangeOfString: @"_core_"];
            
            if (rangeToCore.location != NSNotFound) {
                NSString *organismName = [dbName substringToIndex: rangeToCore.location];
                NSRange substrRange = NSMakeRange(rangeToCore.location + rangeToCore.length, dbName.length - rangeToCore.location - rangeToCore.length);
                NSString *schemaVersion = [dbName substringWithRange:substrRange];
                if ([versions objectForKey: organismName] == nil) {
                    [versions setObject:[NSMutableArray array] forKey: organismName];
                }
                NSMutableArray *vs = [versions objectForKey: organismName];
                if ([vs indexOfObject: schemaVersion] == NSNotFound) {
                    [vs addObject: schemaVersion];
                }
                
                //[versions setValue: schemaVersion forKey: organismName];
            }
        }
        
        for (NSString *org in [versions allKeys]) {
            [versions setObject:
                [[versions objectForKey: org] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] forKey: org];
        } 
        
        _schemaVersionsForOrganisms = [versions retain];
    }
        
    return _schemaVersionsForOrganisms;
}


-(NSMutableArray*) foundGeneList {
    
} 

-(NSArray*) selectedGeneList {
    
} 

-(IBAction) addToSelectedGenes:(id) sender {
    
}

-(IBAction) removeFromSelectedGenes:(id) sender {
    
}

-(void) setSpecifyGenesBySearching:(BOOL) b {
    [self willChangeValueForKey:@"enableGeneNameBySearchingCheckbox"];
    [self willChangeValueForKey:@"enableGeneNameFromInputFileCheckbox"];
    specifyGenesBySearching = b;
    [self didChangeValueForKey:@"enableGeneNameBySearchingCheckbox"];
    [self willChangeValueForKey:@"enableGeneNameFromInputFileCheckbox"];
}

-(void) setSpecifyGenesFromInputFileCheckbox:(BOOL) b {
    [self willChangeValueForKey:@"enableGeneNameBySearchingCheckbox"];
    [self willChangeValueForKey:@"enableGeneNameFromInputFileCheckbox"];
    specifyGenesFromFile = b;
    [self didChangeValueForKey:@"enableGeneNameBySearchingCheckbox"];
    [self willChangeValueForKey:@"enableGeneNameFromInputFileCheckbox"];
}

-(BOOL) enableGeneNameBySearchingCheckbox {
    if (self.specifyGenesBySearching) {
        return YES;
    } else if (!self.specifyGenesBySearching &! self.specifyGenesFromFile) {
        return YES;
    }
    
    return NO;
}

-(BOOL) enableGeneNameFromInputFileCheckbox {
    if (self.specifyGenesFromFile) {
        return YES;
    } else if (!self.specifyGenesBySearching &! self.specifyGenesFromFile) {
        return YES;
    }
    
    return NO;
}

-(void) dealloc {
    [_foundGeneList release];
    [_selectedGeneList release];
    [_organismList release];
    [_schemaVersionList release];
    [organism release];
    [_schemaVersionsForOrganisms release];
    
    [super dealloc];
}

@end