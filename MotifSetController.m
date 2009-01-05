//
//  MotifSetController.m
//  iMotifs
//
//  Created by Matias Piipari on 17/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MotifSetController.h"

@interface MotifSetController (private)

@end

@implementation MotifSetController
- (id) init {
    NSLog(@"\n\n\nMotifSetController: initialising MotifSetController\n\n\n");
    self = [super init];
    if (self != nil) {
        shownObjects = [[NSMutableArray alloc] init];
        hiddenObjects = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id) initWithCoder:(NSCoder*) coder {
    NSLog(@"\n\n\nMotifSetController: initialising MotifSetController with coder\n\n\n");
    self = [super initWithCoder: coder];
    
    shownObjects = [[NSMutableArray alloc] init];
    hiddenObjects = [[NSMutableArray alloc] init];
    
    return self;
}

-(void) dealloc {
    [shownObjects release];
    [hiddenObjects release];
    [super dealloc];
}

-(NSArray*) arrangeObjects:(NSArray*) objs {
    if (hiddenObjects.count == 0) {
        NSLog(@"MotifSetController: arranging objects with super",objs.count);
        return [super arrangeObjects: objs];
    }
    
    NSLog(@"MotifSetController: arranging objects: %d",objs.count);
    NSMutableArray *arrObjs = [NSMutableArray arrayWithArray:objs];
    for (id obj in hiddenObjects) {
        [arrObjs removeObject: obj];
    }
    
    if (self.sortDescriptors.count > 0) {
        [arrObjs sortUsingDescriptors: self.sortDescriptors];
    }
    
    if (self.filterPredicate != nil) {
        [arrObjs filterUsingPredicate: self.filterPredicate];
    }
    
    return arrObjs;
    
}

-(id) arrangedObjects {
    if (hiddenObjects.count == 0) {
        NSLog(@"ArrangedObjects: count (super) : %d",[[super arrangedObjects] count]);
        return [super arrangedObjects];
    }
        
    else {
        //[_shownObjects sortUsingDescriptors:self.sortDescriptors];
        NSLog(@"ArrangedObjects: count : %d",shownObjects.count);
        return shownObjects;
    }
}

-(void) rearrangeObjects {
    if (hiddenObjects.count == 0) {
        NSLog(@"Rearranging... (super)");
        return [super rearrangeObjects];
    }
    
    NSLog(@"Rearrange objects");
    [shownObjects release];
    shownObjects = [[NSMutableArray alloc] initWithArray:self.content];
    for (id obj in hiddenObjects) {
        [shownObjects removeObject: obj];
    }
    
    if (self.sortDescriptors.count > 0) {
        [shownObjects sortUsingDescriptors: self.sortDescriptors];
    }
    if (self.filterPredicate != nil) {
        [shownObjects filterUsingPredicate: self.filterPredicate];
    }
    
    [self didChangeValueForKey:@"arrangedObjects"];
}

-(BOOL) objectIsShown:(id)obj {
    return ![hiddenObjects containsObject: obj];
}
-(void) hideObject:(id)obj {
    NSLog(@"Hiding obj %@, hidden count before: %d",[obj name],hiddenObjects.count);
    [hiddenObjects addObject: obj];
}
-(void) showObject:(id)obj {
    [hiddenObjects removeObject: obj];
}
-(void) showAll {
    [hiddenObjects removeAllObjects];
}
@end