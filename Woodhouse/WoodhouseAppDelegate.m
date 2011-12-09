//
//  WoodhouseAppDelegate.m
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WoodhouseAppDelegate.h"

@implementation WoodhouseAppDelegate

@synthesize statusMenu;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Woodhouse"];
    [statusItem setHighlightMode:YES];
    
}

- (void) quit:(id)sender {
    [NSApp terminate:sender];
}

@end
