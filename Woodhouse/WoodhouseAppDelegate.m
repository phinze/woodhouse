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



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  buildStatusChecker = [[BuildStatusChecker alloc] init];

  CGRect rect = CGRectMake(0, 0, 1, 1);
  BuildStatusItemView *buildStatusItemView = [[BuildStatusItemView alloc] initWithFrame:rect];
  buildStatusItemView.statusItem = statusItem;

  [statusItem setView:buildStatusItemView];
}

- (void) quit:(id)sender {
  [NSApp terminate:sender];
}

@end
