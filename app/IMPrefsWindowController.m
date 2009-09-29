//
//  IMPrefsWindowController.m
//  iMotifs
//
//  Created by Matias Piipari on 31/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IMPrefsWindowController.h"


@implementation IMPrefsWindowController
@synthesize generalPrefsView, vizPrefsView, nmicaPrefsView, ensemblPrefsView;


- (void)setupToolbar
{
    [self addView:generalPrefsView label:@"General"];
    [self addView:vizPrefsView label:@"Visualisation"];
    [self addView:nmicaPrefsView label:@"NMICA"];
    [self addView:ensemblPrefsView label:@"Ensembl"];
}

+ (NSString *)nibName
// Subclasses can override this to use a nib with a different name.
{
    return @"IMPreferences";
}

@end
