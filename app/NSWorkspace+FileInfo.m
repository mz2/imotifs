//
//  NSWorkspace+FileInfo.m
//  iMotifs
//
//  Created by Matias Piipari on 15/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSWorkspace+FileInfo.h"


@implementation NSWorkspace (FileInfo)
-(BOOL)fileAtAPathIsWriteable:(NSString*)path {
    BOOL writeable;
    BOOL removable;
    BOOL unmountable;
    
    if ([self getFileSystemInfoForPath: path 
                           isRemovable: &removable 
                            isWritable: &writeable 
                         isUnmountable: &unmountable 
                           description: NULL
                                  type: NULL]) {
        return writeable;
    } else {
        return NO;
    }
}    
@end
