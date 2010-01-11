//
//  MotifSet.m
//  Motif
//
//  Created by Matias Piipari on 25/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <MotifSet.h>
#import <Motif.h>


@interface MotifSet (private)
//-(void) startObservingMotif:(Motif*)m;
//-(void) stopObservingMotif:(Motif*)m;
@end

@implementation MotifSet
//@synthesize name, desc;
@synthesize annotations;
@synthesize motifs;
#ifdef IMOTIFS_COCOA_GUI
@synthesize motifSetDocument;
#endif

- (id) init
{
    self = [super init];
    if (self != nil) {
        motifs = [[NSMutableArray alloc] init];
        annotations = [[NSMutableDictionary alloc] init];
#ifdef IMOTIFS_COCOA_GUI
        motifSetDocument = nil;
#endif
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)coder {
    [super init];
    PCLog(@"MotifSet: initWithCoder");
    //name = [[coder decodeObjectForKey:@"name"] retain];
    annotations = [[coder decodeObjectForKey:@"annotations"] retain];
    motifs = [[coder decodeObjectForKey:@"motifs"] retain];
    return self;
}

- (void) encodeWithCoder:(NSCoder *) coder {
    PCLog(@"MotifSet: encodeWithCoder");
    [coder encodeObject:[self name] forKey:@"name"];
    [coder encodeObject:[self annotations] forKey:@"annotations"];
    [coder encodeObject:motifs forKey:@"motifs"];
}

+(MotifSet*) motifSet {
    return [[[MotifSet alloc] init] autorelease];
}

- (void) dealloc {
    //[name release];
    [motifs release];
    [annotations release];
    [super dealloc];
}

#pragma mark NSCopying
- (id) copyWithZone:(NSZone*) zone {
    MotifSet *copy = [[MotifSet allocWithZone:zone] init];
    [copy setName: [[self name] copyWithZone:zone]];
    copy->annotations = [[self annotations] copyWithZone:zone];
    copy->motifs = [self->motifs copyWithZone:zone];
    return copy;
}

#pragma mark accessors
-(void) addMotif:(Motif*) motif {
    //[self startObservingMotif:motif];
    [motifs addObject: motif];
}

-(void) addMotif:(Motif*) m atIndex:(NSUInteger)i {
    //[self startObservingMotif:m];
    [motifs insertObject:m 
                 atIndex:i];
}
-(void) addMotifs:(NSArray*) ms atIndex:(NSUInteger)i {
    NSInteger mI;
    for (mI = [ms count] - 1; mI >= 0; mI--) {
        Motif *motif = [ms objectAtIndex:mI];
        //[self startObservingMotif:motif];
        [self addMotif:motif  atIndex:i];
    } 
}

-(void) replaceMotifAtIndex:(NSUInteger)index 
                  withMotif:(Motif*) motif {
    [motifs replaceObjectAtIndex:index 
                      withObject:motif];
}

-(void) removeMotif:(Motif*) motif {
    //[self stopObservingMotif:motif];
    [motifs removeObject: motif];
}
-(void) removeMotifWithIndex:(NSInteger) i {
    //Motif *motif = [motifs objectAtIndex:i];
    //[self stopObservingMotif:motif];
    [motifs removeObjectAtIndex:i];
}
-(NSUInteger) count {
    return [motifs count];
}
-(Motif*) motifWithIndex:(NSInteger)index {
    return [motifs objectAtIndex:index];
}
-(NSInteger) indexForMotif:(Motif*)m {
    return [motifs indexOfObject:m];
}

-(NSInteger) minOffset {
    NSInteger offset = positiveInfinity;
    for (Motif* m in motifs)
        if ([m offset] < offset) offset = [m offset];
    
    return offset;
}

-(NSInteger) maxColumnIndex {
    NSInteger column = negativeInfinity;
    for (Motif* m in motifs) {
        int col = [m offset] + [m columnCount];
        if (col > column) column = col;
    }
    return column;
}

-(NSInteger) columnCountWithOffsets {
    return [self maxColumnIndex] - [self minOffset] + 1;
}
    
-(NSString*) name {
    return [[self annotations] objectForKey:@"motifset-name"];
}

-(void) setName:(NSString*) n {
    [[self annotations] setObject:n forKey:@"motifset-name"];
}

-(NSString*) desc {
    return [[self annotations] objectForKey:@"motifset-description"];
}

-(void) setDesc:(NSString*) desc {
    [[self annotations] setObject: desc forKey:@"motifset-description"];
}

-(NSString*) description {
    NSMutableString *str = [NSMutableString stringWithFormat:@"[MotifSet name: %@, %i motifs\n",self.name, [motifs count]];
    int i = 0;
    for (Motif *m in motifs) {
        [str appendFormat:@"#%d:\n%@",i++, m];
    }
    [str appendFormat:@"]"];
    return str;
}

-(NSXMLDocument*) toXMS {
    //PCLog(@"MotifSet: toXMS");
    NSXMLElement *elem = [[NSXMLElement elementWithName:@"motifset"] retain];
    NSXMLDocument *doc = [NSXMLDocument documentWithRootElement:elem];
    [doc setVersion:@"1.0"];
    [doc setCharacterEncoding:@"UTF-8"];
    [doc XMLDataWithOptions:NSXMLNodePrettyPrint];
    NSXMLNode *xmlnsAttribNode = [NSXMLNode attributeWithName:@"xmlns" 
                                                  stringValue:@"http://biotiffin.org/XMS/"];
    [elem addAttribute:xmlnsAttribNode];
    
    for (Motif *m in motifs) {
        [elem addChild:[m toXMSMotifNode]];
    }
    
    for (NSXMLElement* propElem in [self xmsPropKeyValuePairs]) {
        [elem addChild:propElem];
    }
    
    return doc;
}

- (NSArray*) xmsPropKeyValuePairs {
    //PCLog(@"Motif: xmsPropKeyValuePairs");
    [self annotations];
    NSMutableArray *propKeys = [NSMutableArray array];
    for (id key in [[self annotations] keyEnumerator]) {
        NSXMLElement *propElem = [NSXMLElement elementWithName:@"prop"];
        
        NSXMLElement *keyElem = [NSXMLElement elementWithName:@"key" stringValue:key];
        id val = [[self annotations] objectForKey:key];
        NSXMLElement *valElem = [NSXMLElement elementWithName:@"value" stringValue:val];
                
        [propElem addChild:[keyElem retain]];
        [propElem addChild:[valElem retain]];
        
        [propKeys addObject:[propElem retain]];
    }
    return propKeys;
}

/*
#pragma mark Key/value observing
-(void) startObservingMotif:(Motif*) m {
    [m addObserver:self 
        forKeyPath:@"name" 
           options:NSKeyValueObservingOptionOld
           context:NULL];
    
    [m addObserver:self 
        forKeyPath:@"offset" 
           options:NSKeyValueObservingOptionOld
           context:NULL];
    
    [m addObserver:self 
        forKeyPath:@"color" 
           options:NSKeyValueObservingOptionOld
           context:NULL];
}

-(void) stopObservingMotif:(Motif*) m {
    [m removeObserver:self forKeyPath:@"name"];
    [m removeObserver:self forKeyPath:@"offset"];
    [m removeObserver:self forKeyPath:@"color"];
}*/

-(void) alignToLeftEnd {
    NSInteger minOffset = [self minOffset];
    for (Motif *m in motifs) {
        [m setOffset:[m offset] - minOffset];
    }
}

- (void) setNilValueForKey:(NSString*) str {
    PCLog(@"MotifSet: setting nil value for key %@",str);
    [super setNilValueForKey:str];
}

- (NSComparisonResult) compare:(MotifSet*) other {
    NSParameterAssert(other != nil);
    return ([self.name compare: other.name]);
    //if (ownDist < otherDist) return NSOrderedAscending;
    //if (ownDist > otherDist) return NSOrderedDescending;
    //return NSOrderedSame;
}

-(NSString*) stringValue {
    NSXMLDocument *doc = [self toXMS];
    NSData *data = [doc XMLData];
    return [[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding] autorelease];
}

@end