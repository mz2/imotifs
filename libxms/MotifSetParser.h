//
//  MotifSetParser.h
//  XMSParser
//
//  Created by Matias Piipari on 25/06/2008.
//  Copyright 2008 Matias Piipari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MotifSet.h>
#import <Alphabet.h>

@interface MotifSetParser : NSObject {

}

+(MotifSet*) motifSetFromXML:(NSXMLDocument*) xmlDoc;
+(MotifSet*) motifSetFromData:(NSData*) data;
+(MotifSet*) motifSetFromURL:(NSURL*) url;
//+(MetaMotifSet*) metaMotifSetFromURL:(NSURL*) url;
@end
