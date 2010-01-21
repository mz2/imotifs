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
//  MotifSetParser.m
//  XMSParser
//
//  Created by Matias Piipari on 25/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import "MotifSetParser.h"
#import "MotifSet.h"
#import "Motif.h"
#import "Alphabet.h"
#import "Dirichlet.h"
#import "IMNSColorExtras.h"
#import "Metamotif.h"
#import "DistributionBounds.h"
#import "SymbolBounds.h"

@implementation MotifSetParser
- (id) init
{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

+(NSString*) parseName:(NSXMLNode*)motifNode {
    NSError *nameErr;
    NSArray *nameNodes = [motifNode nodesForXPath:@"name" 
                                       error:&nameErr];
    if (nameErr != nil) {
        @throw [NSException exceptionWithName:@"XMSParsingException" 
                                       reason:[nameErr description] 
                                     userInfo:nil];
    }
    
    if ([nameNodes count] > 1) {
        @throw [NSException exceptionWithName:@"XMSParsingException" 
                                       reason:[NSString stringWithFormat:
                                               @"Unexpected number of <name> child nodes:%d",[nameNodes count]] 
                                     userInfo:nil];
    } else if ([nameNodes count] == 1) {
        NSString *motifName = [[nameNodes objectAtIndex:0] stringValue];
        return motifName;
    } else {
        return nil;
    }
}

+(NSArray*) weightMatrixNodes:(NSXMLNode*) motifNode {
    NSError *wmError;
    NSArray *wms = [motifNode nodesForXPath:@"weightmatrix" 
                                      error:&wmError];
    if (wmError != nil)
        @throw [NSException exceptionWithName:@"XMSParsingException" 
                                       reason:[wmError description] 
                                     userInfo:nil];
    return wms;
}

+(NSArray*) columns:(NSXMLNode*) wmNode {
    NSError *colError;
    NSArray *cols = [wmNode nodesForXPath:@"column" 
                                    error:&colError];
    if (colError != nil)
        @throw [NSException exceptionWithName:@"XMSParsingException" 
                                       reason:[colError description] 
                                     userInfo:nil];
    
    return cols;
}

+(void) setAnnotationsForAnnotable:(id <Annotable>) annotable fromPropNodes:(NSArray*) propNodes {
    for (NSXMLElement *prop in propNodes) {
        NSArray *keys = [prop elementsForName:@"key"];
        NSArray *values = [prop elementsForName:@"value"];
        if ([keys count] != 1) {
            @throw [NSException exceptionWithName:@"XMSParsingException" 
                                           reason:[NSString stringWithFormat:@"Unexpected count of <key> elements: %d",[keys count]] 
                                         userInfo:nil];
        }
        if ([values count] != 1) {
            @throw [NSException exceptionWithName:@"XMSParsingException" 
                                           reason:[NSString stringWithFormat:@"Unexpected count of <value> elements: %d",[values count]] 
                                         userInfo:nil];
        }
        
        [[annotable annotations] setObject:[[values objectAtIndex:0] stringValue] 
                                forKey:[[keys objectAtIndex:0] stringValue]];
    }    
}

+(void) parseAnnotationsForAnnotable:(id <Annotable>)annotable fromNode:(NSXMLElement*) elem {
    NSArray *propNodes = [elem elementsForName:@"prop"];
    
    if ([propNodes count] > 0) {
        //PCLog(@"Parsing %d properties for %@",[propNodes count],annotable);
        [self setAnnotationsForAnnotable:annotable 
                           fromPropNodes:propNodes];
    }
}

+(Multinomial*) parseMultinomial:(NSXMLNode*) distNode alphabet:(Alphabet*) alphabet {
    NSError *weightError;
    NSArray *weights = [distNode nodesForXPath:@"weight" 
                                         error:&weightError];
    
    Multinomial *dist = [[Multinomial alloc] initWithAlphabet: alphabet];
    for (NSXMLElement *weightNode in weights) {
        NSString *sym = [[[weightNode attributeForName:@"symbol"] stringValue] lowercaseString];
        NSString *val = [weightNode stringValue];
        
        //PCLog(@"%@", [weightNode attributeForName:@"symbol"]);
        [dist symbol:[alphabet symbolWithName:sym] withWeight:[val doubleValue]];
    }
    [dist autorelease];
    return dist;
}

+(MotifSet*) motifSetFromData:(NSData*) data error:(NSError**)err {
    NSError *docError;
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] 
                             initWithData:data 
                             options:0 
                             error:&docError];
    MotifSet *ms = nil;
    
    if (docError != nil) {
        [xmlDoc release],xmlDoc = nil;
        PCLog(@"Error parsing an XMS file from input data");
        
        err = &docError;
    } else {
        @try {
            ms = [self motifSetFromXML:xmlDoc error:err];
        } @catch (NSException *e) {
            NSError *excError = [NSError errorWithCode:4 description:[e reason]];
            *err = excError;
        }
    }
    
    [xmlDoc release];
    return ms;
}


+(MotifSet*) motifSetFromURL:(NSURL*) url error:(NSError**) err {
    NSError *docError;
    MotifSet *ms;
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] 
                             initWithContentsOfURL:url 
                             options:0 
                             error:&docError];
    if (docError != nil) {
        [xmlDoc release];
        xmlDoc = nil;
        PCLog(@"Error parsing an XMS file from input data at URL %@", url);
        
        *err = docError;
        return nil;
    } else {
        ms = [self motifSetFromXML: xmlDoc error: err];
    }
    [xmlDoc release],xmlDoc = nil;
    return ms;
}


+(MotifSet*) motifSetFromXML:(NSXMLDocument*) xmlDoc error:(NSError**) err {
    MotifSet* motifSet = [[[MotifSet alloc] init] autorelease];

    NSError *motifSetNodeError;
    NSArray *motifSetNodes = [xmlDoc nodesForXPath:@"/motifset" 
                                             error:&motifSetNodeError];
    
    if (motifSetNodeError != nil) {
        PCLog(@"ERROR: %@",motifSetNodeError);
        [motifSet release];
        motifSet = nil;
        
        err = &motifSetNodeError;
    } else if ([motifSetNodes count] != 1) {
        [motifSet release];
        motifSet = nil;
        
        NSError *e = [NSError errorWithCode:4 description:@"Only one <motifset> element expected"];
        *err = e;
        return nil;
    }
    
    [self parseAnnotationsForAnnotable:motifSet
                              fromNode:[motifSetNodes objectAtIndex:0]];
    
    NSError *motifNodeError;
    NSArray *motifNodes = [xmlDoc nodesForXPath:@"/motifset/motif" 
                                          error:&motifNodeError];
    if (motifNodeError != nil) {
        PCLog(@"ERROR: %@",motifNodeError);
        [motifNodes release];
        motifNodes = nil;
        
        err = &motifNodeError;
        return nil;
    }
    
    for (NSXMLElement *node in motifNodes) {
        NSArray *wmNodes = [self weightMatrixNodes:node];
        if ([wmNodes count] != 1) {            
            NSError *e = [NSError errorWithDomain:@"IMErrorDomain" 
                                             code:2
                                         userInfo:[NSString stringWithFormat: @"Unexpected number of <weightmatrix> nodes: %d",[wmNodes count]]];
            *err = e;
            return nil;
        }
        NSMutableArray *dists = [NSMutableArray array];
        NSXMLElement *wmNode = [wmNodes objectAtIndex:0];
        
        Alphabet *alphabet = [Alphabet withName:[[wmNode attributeForName:@"alphabet"] stringValue]];
        
        NSArray *cols = [self columns:wmNode];
        for (NSXMLNode *col in cols) {
            //PCLog(@"%@:%@", alphabet, col);
            Multinomial *dist = [self parseMultinomial:col alphabet:alphabet];
            [dists addObject:dist];
        }
        
        Motif *motif = [[[Motif alloc] initWithAlphabet:alphabet andColumns:dists] autorelease];
        NSString *mName = [self parseName:node];
        
        [self parseAnnotationsForAnnotable:motif
                                  fromNode:node];
        
        [motif setName:mName];
        
        NSString *offset = [[motif annotations] objectForKey:@"offset"];
        //PCLog(@"Keys: %@",[[motif annotations] allKeys]);
        
        /*
        for (NSString* key in [[motif annotations] allKeys]) {
            PCLog(@"%@ = %@", key, [[motif annotations] objectForKey:key]);
        }*/
        NSString *color = [[[motif annotations] allKeys] containsObject: @"color"] ? 
                                                                          [[motif annotations] objectForKey:@"color"] : nil;
        if (offset) [motif setOffset:[offset intValue]];
        
        if (color != nil) {
            NSColor *col = [NSColor colorFromHexadecimalValue:color];
            [motif setColor:col];
        } else {
            //PCLog(@"Color was nil");
        }
        //if there are any precision values there, you should treat this motif as a metamotif
        if ([[motif annotations] objectForKey:@"alphasum;column:0"]) {
            //PCLog(@"Found precision parameter");
            NSUInteger col,cnt;
            NSMutableArray *dirs = [[NSMutableArray alloc] initWithCapacity:cnt];
            for (col = 0,cnt = [motif columnCount]; col < cnt; col++) {
                Multinomial *multinom = [[motif columns] objectAtIndex: col];
                
                
                 
                NSString *precStr = [[motif annotations] objectForKey:[NSString stringWithFormat:@"alphasum;column:%d",col]];
                double prec = [precStr doubleValue];
                //NSLog(@"Precision : %.3f", prec);
                //PCLog(@"%@",multinom);
                Dirichlet *dir = [[Dirichlet alloc] initWithAlphabet: [motif alphabet] 
                                                               means: multinom 
                                                           precision: prec];
                
                [dirs addObject:dir];
                [dir release];
            }
            
            Metamotif *metam = [[[Metamotif alloc] initWithAlphabet: [motif alphabet] 
                                                        andColumns: dirs] autorelease];
            //PCLog(@"Adding metamotif to set");
            [metam setName: [motif name]];
            [metam setThreshold: [motif threshold]];
            [metam setAnnotations: motif.annotations];
            [motifSet addMotif: metam];
            
        } else {
            //PCLog(@"Adding motif to set");
            [motifSet addMotif:motif];
        }
    }
    
    return motifSet;
}
@end
