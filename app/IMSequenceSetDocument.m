//
//  IMSequenceSetDocument.m
//  iMotifs
//
//  Created by Matias Piipari on 03/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IMSequenceSetDocument.h"

#import <BioCocoa/BCSequenceReader.h>
#import <BioCocoa/BCSequenceArray.h>

#import "IMSequenceSetController.h"
#import "IMSequenceView.h"
#import "IMSequenceViewCell.h"
#import "IMSequence.h"

@implementation IMSequenceSetDocument
@synthesize name = _name;
@synthesize sequences = _sequences;
@synthesize numberOfSequencesLabel = _numberOfSequencesLabel;
@synthesize sequenceView = _sequenceView;
@synthesize sequenceSetController = _sequenceSetController;
@synthesize drawer = _drawer;
@synthesize sequenceTable = _sequenceTable;
@synthesize nameColumn = _nameColumn;
@synthesize sequenceColumn = _sequenceColumn;

- (NSString *)windowNibName {
    // Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
    return @"IMSequenceSetDocument";
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

-(void) awakeFromNib {
    _sequenceCell = [[[IMSequenceViewCell alloc] 
                      initImageCell:[[_sequenceColumn dataCell] image]] autorelease];
    [_sequenceColumn setDataCell: _sequenceCell];
}

- (NSData *)dataOfType:(NSString *)typeName 
                 error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    return nil;
}


-(BOOL)readFromURL:(NSURL*) url 
            ofType:(NSString*)type 
             error:(NSError**) outError {
    
    PCLog(@"Reading document of type %@ from URL %@", type, url);
    if ([type isEqual:@"Sequence set"]) {

        NSString *path = [url path];
        BCSequenceReader *sequenceReader = [[[BCSequenceReader alloc] init] autorelease];
        BCSequenceArray *sequenceArray = [sequenceReader readFileUsingPath: path 
                                                                    format: BCFastaFileFormat];
        
        NSMutableArray *seqs = [NSMutableArray array];
        
        NSUInteger i;
        for (i=0; i < [sequenceArray count]; i++) {
            BCSequence *s = [sequenceArray sequenceAtIndex: i];
            PCLog(@"Sequence:%@\nannotations:%@",s,[[s annotations] allKeys]);

            /*
            for (id key in [[s annotations] allKeys]) {
                PCLog(@"Annotation: %@",[[s annotations] objectForKey: key]);
                PCLog(@"Name: '%@'",[[[s annotations] objectForKey: key] name]);
                BCAnnotation *a = [[s annotations] objectForKey: key];
                
                PCLog(@"'%@'=>'%@'",[a name], [a stringValue]);
            }*/
            
            IMSequence *seq = 
                [[[IMSequence alloc] initWithSymbolArray: [s symbolArray]] autorelease];
            seq.name =  [[[s annotations] objectForKey: @">"] stringValue];
            [seqs addObject: seq];
        }
        self.name = path;
        
        self.sequences = [[seqs copy] autorelease];
        
        //this is nil! the Nib hasn't been read yet 
        /*
        PCLog(@"Sequence controller %@ contents: %@", self.sequenceSetController, self.sequenceSetController.content);
        //[self.sequenceSetController setContent: self.sequences];
        */
        PCLog(@"Read %d sequences from file %@", self.sequences.count, path);
        return self.sequences != nil ? YES : NO;
    } else {
        ddfprintf(stderr, @"Trying to read an unsupported type : %@\n", type);
        return NO;
    }
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    PCLog(@"Clicked table %@ column %@", tableView , tableColumn);
}

-(IBAction) toggleDrawer:(id) sender {
    [self.drawer toggle: sender];
}

-(BOOL) isMotifSetDocument {
    return NO;
}

-(BOOL) isSequenceSetDocument {
    return YES;
}

-(BOOL) isAnnotationSetDocument {
    return NO;
}
@end