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

- (void) dealloc {
    [statusItem release];
    [statusMenu release];
    [timer release];
}

- (void) updateBuilds:(NSTimer*)theTimer {
    NSLog(@"updating builds");
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Woodhouse"];
    [statusItem setHighlightMode:YES];
 
    timer = [[NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(updateBuilds:) userInfo:nil repeats:NO] retain];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void) quit:(id)sender {
    [NSApp terminate:sender];
}

@end
