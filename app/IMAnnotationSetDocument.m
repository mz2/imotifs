//
//  IMAnnotationSetDocument.m
//  iMotifs
//
//  Created by Matias Piipari on 06/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IMAnnotationSetDocument.h"
#import "IMAnnotation.h"
#import "IMAnnotationSetController.h"

@implementation IMAnnotationSetDocument
@synthesize annotationSetController = _annotationSetController;
@synthesize annotations = _annotations;
@synthesize name = _name;

- (NSString *)windowNibName {
    // Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
    return @"IMAnnotationSetDocument";
}

- (NSString *)displayName {
    if ([self fileURL] == nil) {
        if (self.name.length > 0) {
            return self.name;
        } else {
            return [super displayName];
        }
    } else {
        return [super displayName];
    }
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    return nil;
}


-(BOOL)readFromURL:(NSURL*) url 
            ofType:(NSString*)type 
             error:(NSError**) outError {
    self.name = [url path];
    PCLog(@"Reading document of type %@ from URL %@", type, url);
    if ([type isEqual:@"GFF annotation set"]) {
        NSError *error = nil;
        
        NSMutableArray *results = [NSMutableArray array];
        
        NSString *str = [[NSString alloc]
                             initWithContentsOfFile:[url path]
                             encoding:NSUTF8StringEncoding
                             error:&error];
        
        if (error != nil) {
            NSAlert *theAlert = [NSAlert alertWithError:error];
            [theAlert runModal]; // Ignore return value.
        }
        
        NSArray *components = [str componentsSeparatedByString:@"\n"];
        for (NSString *line in components) {
            if ([[line substringToIndex:1] isEqual:@"#"]) {
                PCLog(@"Ignoring comment line %@", line);
                continue;
            }
            NSArray *cols = [line componentsSeparatedByString:@"\t"];
            if (cols.count < 7) {
                ddfprintf(stderr, @"Invalid GFF record: %@\n", line);                
                return NO;
            }
            
            IMStrand strand;
            NSString *strandStr = [cols objectAtIndex:6];
            if ([strandStr isEqual:@"+"]) {
                strand = IMStrandPositive;
            } else if ([strandStr isEqual:@"-"]) {
                strand = IMStrandNegative;
            } else {
                strand = IMStrandNA;
            }
            
            NSString *attrStr;
            if (cols.count >= 8) {
                attrStr = [cols objectAtIndex:7];
            } else {
                attrStr = @"";
            }
            
            IMAnnotation* annotation = 
                [[[IMAnnotation alloc] initWithSeqName:[cols objectAtIndex:0]
                                               source:[cols objectAtIndex:1] 
                                              feature:[cols objectAtIndex:2] 
                                                start:[[cols objectAtIndex:3] intValue] 
                                                  end:[[cols objectAtIndex:4] intValue]
                                                score:[[cols objectAtIndex: 5] doubleValue] 
                                               strand:strand
                                           attributes:attrStr] autorelease];
            [results addObject: annotation];
        }
        
        self.annotations = [[results copy] autorelease];
        
        return YES;
    } else {
        ddfprintf(stderr, @"Trying to read an unsupported type : %@\n", type);
        
    }
    
    return NO;
}

-(BOOL) isMotifSetDocument {
    return NO;
}

-(BOOL) isSequenceSetDocument {
    return NO;
}

-(BOOL) isAnnotationSetDocument {
    return NO;
}

@end
