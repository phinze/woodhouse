//
//  WoodhouseAppDelegate.m
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WoodhouseAppDelegate.h"
#import "Build.h"
#import "BuildStatusItemView.h"

@implementation WoodhouseAppDelegate


- (void) dealloc {
  [statusItem release];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  
  statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
  buildStatusChecker = [[BuildStatusChecker alloc] init];
  
  BuildStatusItemView *buildStatusItemView = [[BuildStatusItemView alloc] init];
  buildStatusItemView.statusItem = statusItem;
  buildStatusItemView.buildStatusChecker = buildStatusChecker;
  
  [statusItem setView:buildStatusItemView];
  [buildStatusItemView setTitle:@"HELLO WORLD"];
}


@end
