//
//  motif.m
//  objc
//
//  Created by Matias Piipari on 23/03/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Motif.h>
#import <IMNSColorExtras.h>

@implementation Motif

@synthesize name;
@synthesize alphabet;
@synthesize columns;
@synthesize annotations;
@synthesize color;

-(id) initWithAlphabet:(Alphabet*) alpha 
                andColumns:(NSArray*) cols {
    self = [super init];
    
    if (self != nil) {
    	alphabet = [alpha retain];
        columns = [cols retain];
        annotations = [[NSMutableDictionary alloc] init];
        [self setOffset:0];
        [self setColor: nil];
        [self setThreshold: 0.0];        
    }

	return self;
}

-(id)initWithAlphabet:(Alphabet*)alpha
      fromConsensusString:(NSString*)str {
    self = [super init];
    
    if (self != nil) {
        //DebugLog(@"Initialising with alphabet %@ from consensus string %@", alpha, str);
        NSUInteger i,cnt;
        NSMutableArray *cols = [[NSMutableArray alloc] init];
        for (i = 0,cnt = [str length]; i < cnt; i++) {
            NSString* c = [str substringWithRange:NSMakeRange(i, 1)];
            Multinomial *m = [[Multinomial alloc] initWithAlphabet:alpha];
            [m setWeightsFromConsensus:c];
            [cols addObject:m];
            //DebugLog(@"constructed multinomial: %@",m);
        }
        
        return [self initWithAlphabet:alpha 
                           andColumns:[NSArray arrayWithArray: cols]];        
    }
    
    return self;
}

-(id)initWithMotif:(Motif*)motif {
    self = [super init];
    
    if (self != nil) {
        alphabet = [motif.alphabet retain];
        NSMutableArray *cols = [NSMutableArray arrayWithCapacity:motif.columns.count];
        
        for (Multinomial *m in motif.columns) {
            [cols addObject:[[Multinomial alloc] initWithMultinomial:m]]; 
        }
        columns = [[NSMutableArray alloc] initWithArray:cols];
        annotations = [motif.annotations mutableCopy];
        [self setName: [motif.name copy]];
        [self setOffset:motif.offset];
        [self setColor:[motif.color copy]];
        [self setThreshold: motif.threshold];        
    }
    
    return self;
}



- (void)dealloc {
	[name release];
	[alphabet release];
	[columns release];
	[annotations release];
    [color release];
	[super dealloc];
}

- (id) initWithCoder:(NSCoder*) coder {
    [super init];
    //NSLog(@"Motif: initWithCoder");
    name = [[coder decodeObjectForKey:@"name"] retain];
    alphabet = [[coder decodeObjectForKey:@"alphabet"] retain];
    columns = [[coder decodeObjectForKey:@"columns"] retain];
    annotations = [[NSMutableDictionary dictionaryWithDictionary:[coder decodeObjectForKey:@"annotations"]] retain];
    color = [[coder decodeObjectForKey:@"color"] retain];
    offset = [coder decodeIntegerForKey:@"offset"];
    threshold = [coder decodeDoubleForKey:@"threshold"];
    if (annotations == nil) {
        DebugLog(@"Motif: Annotations were nil, this shouldn't happen");
        annotations = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*) coder {
    //NSLog(@"Motif: encodeWithCoder");
    [coder encodeObject:name 
                 forKey:@"name"];
    [coder encodeObject:alphabet 
                 forKey:@"alphabet"];
    [coder encodeObject:columns 
                 forKey:@"columns"];
    [coder encodeObject:annotations 
                 forKey:@"annotations"];
    [coder encodeObject:color
                 forKey:@"color"];
    [coder encodeInteger:offset 
                 forKey:@"offset"];
    [coder encodeDouble:threshold 
                 forKey:@"threshold"];
}

- (Multinomial*) column:(int)index {
    return [columns objectAtIndex:index];
}

- (NSString*) description {
    NSMutableString* str = [NSMutableString stringWithFormat:@"[motif:%@\n",[self name]];
    
    int col = 0;
    double ent = 0;
    for (Multinomial* m in columns) {
        [str appendFormat:@"%d:%@",col++,m];
        ent += [m informationContent];
    }
    
    [str appendFormat:@"(%.3g bits) consensus: %@ offset:%d color:%@]\n",
     ent, 
     [self consensusString], 
     [self offset], 
     [self color]];
    return str;
}

- (int) columnCount {return [columns count];}

- (NSString*) consensusString {
    NSMutableString *str = [NSMutableString stringWithCapacity: [self columnCount]];
    for (Multinomial* m in [self columns]) {
        NSArray* syms = [m symbolsWithWeightsInDescendingOrder];
        Symbol *sym = [syms objectAtIndex: [syms count]-1];
        [str appendString:[sym shortName]];
    }
    return str;
}

-(double) informationContent {
    double infoC = 0;file://localhost/Users/mp4/Projects/imotifs
    for (Multinomial* m in [self columns]) {
        infoC += [m informationContent];
    }
    return infoC;
}

- (NSInteger) offset {
    return offset;
}

- (void) setOffset:(NSInteger) offs {
    offset = offs;
    [[self annotations] setObject:[NSString stringWithFormat:@"%d",offset] 
                           forKey:@"offset"];
}

- (void) setColor:(NSColor*) col {
    [color release];
    color = col;
    if (color) {
        if ([color alphaComponent] > 0.99) {
            color = [[col colorWithAlphaComponent:IMMotifColorAlpha] retain];
        } else {
            color = [col retain];
        }
        
        [[self annotations] setObject:[NSString stringWithFormat:@"%@",[color hexadecimalValue]] 
                               forKey:@"color"];
        
    }
    else 
        [[self annotations] removeObjectForKey:@"color"];
}

- (double) threshold {
    return threshold;
}

- (void) setThreshold:(double) thr {
    threshold = thr;
}

-(void) incrementOffset {
    [self setOffset:[self offset] + 1];
}

-(void) decrementOffset {
    [self setOffset:[self offset] - 1];
}

-(Motif*) reverseComplement {
    //DebugLog(@"Motif: reverseComplement");
    NSInteger cols = [self columnCount];
    
    NSUInteger c;
    NSMutableArray *newCols = [NSMutableArray arrayWithCapacity:cols];
    
    for (c = 0; c < cols; c++) {
        Multinomial *oldCol = [self column:cols - c - 1];
        [newCols addObject: [oldCol complement]];
    }
    
    Motif *motif = [[Motif alloc] initWithAlphabet:[self alphabet] 
                                        andColumns:[NSArray arrayWithArray:newCols]];
    [motif setName:[self name]];
    [motif setColor:[self color]];
    [motif setOffset:[self offset]];
    motif->annotations = [self annotations];
    [[motif annotations] retain];
    
    return [motif autorelease];
}
-(NSMutableDictionary*) annotations {
    if (annotations == nil) {
        annotations = [[NSMutableDictionary alloc] init];
    }
    return annotations;
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    Motif *newM = [[Motif alloc] initWithAlphabet:[self alphabet] 
                                       andColumns:[[self columns] copyWithZone:zone]];
    
    [newM setName: [[self name] copyWithZone:zone]];
    [newM setOffset: [self offset]];
    [newM setColor: [[self color] retain]];
    newM->annotations = [[self annotations] copyWithZone:zone];
    
    return [newM retain];
}

-(NSXMLElement*) toXMSMotifNode {
    //DebugLog(@"Motif: toXMSMotifNode");
    NSXMLElement *motifNode = [NSXMLElement elementWithName:@"motif"];
    NSXMLElement *wmNode = [NSXMLElement elementWithName:@"weightmatrix"];
    NSXMLElement *nameElem = [NSXMLElement elementWithName:@"name" stringValue:[self name]];
    
    NSXMLNode *alphabAttribNode = [NSXMLNode attributeWithName:@"alphabet" 
                                                   stringValue:[[self alphabet] name]];
    [wmNode addAttribute:[alphabAttribNode retain]];
    NSString *columnCountStr = [[[NSString alloc] 
                                 initWithFormat:@"%d",[self columnCount]] retain];;
    [wmNode addAttribute:[[NSXMLNode attributeWithName:@"columns" 
                                      stringValue:columnCountStr] retain]];
    [motifNode addChild: [nameElem retain]];
    [motifNode addChild: [wmNode retain]];
    NSUInteger i = 0;
    for (Multinomial* multi in [self exportedColumns]) {
        NSXMLElement *colElem = [multi toXMSDistributionNode];
        NSXMLNode *posAttribNode = [NSXMLNode attributeWithName:@"pos" 
                                                   stringValue:[[NSString alloc] initWithFormat:@"%d",i++]];
        [colElem addAttribute:[posAttribNode retain]];
        [wmNode addChild:[colElem retain]];
    }
    
    NSXMLElement *thresholdElem = [NSXMLElement elementWithName:@"threshold" 
                                                    stringValue:[NSXMLNode 
                                                                 textWithStringValue:[[NSString alloc] 
                                                                    initWithFormat:@"%e",[self threshold]]]];
    [motifNode addChild:[thresholdElem retain]];
     
    for (NSXMLElement* propElem in [self xmsPropKeyValuePairs]) {
        [motifNode addChild:[propElem retain]];
    }
    
    return [motifNode autorelease];
}

-(NSArray*) xmsPropKeyValuePairs {
    //DebugLog(@"Motif: xmsPropKeyValuePairs");
    [self annotations];
    NSMutableArray *propKeys = [NSMutableArray array];
    for (id key in [[self annotations] keyEnumerator]) {
        NSXMLElement *propElem = [NSXMLElement elementWithName:@"prop"];
        
        NSXMLElement *keyElem = [NSXMLElement elementWithName:@"key" stringValue:key];
        id val = [[self annotations] objectForKey:key];
        NSXMLElement *valElem = [NSXMLElement elementWithName:@"value" stringValue:val];
        
        [propElem addChild:keyElem];
        [propElem addChild:valElem];
        
        [propKeys addObject:propElem];
    }
        
    return propKeys;
}

- (void) setNilValueForKey:(NSString*) str {
    DebugLog(@"Motif: setting nil value for key %@",str);
}

-(NSArray*) annotationValues {
    return [[self annotations] objectsForKeys:[[self annotations] allKeys] notFoundMarker: [NSNull null]];
}

-(void) clearCachedValues {
    //[cachedImage release];
    //cachedImage = nil;
}

- (NSArray*) exportedColumns {
    return self.columns;
}

-(void) addPseudocounts:(double) cnt {
    for (Multinomial *col in self.columns) {
        [col addPseudocounts: cnt];
    }
}
@end