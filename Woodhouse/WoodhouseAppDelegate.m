//
//  WoodhouseAppDelegate.m
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WoodhouseAppDelegate.h"
#import "Build.h"

@implementation WoodhouseAppDelegate

@synthesize statusMenu;

- (void) dealloc {
  [statusItem release];
  [statusMenu release];
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSImage *image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"watchdog-ok" ofType:@"png"]];
  
  statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];

  [statusItem setImage:image];
  [statusItem setHighlightMode:YES];
  
  [statusItem setAction:@selector(handleClick:)];
  [statusItem setTarget:self];
  
  buildStatusChecker = [[BuildStatusChecker alloc] init];
}

- (void) quit:(id)sender {
  [NSApp terminate:sender];
}

- (void) handleClick:(id)sender {
  NSEvent *event = [NSApp currentEvent];
  if([event modifierFlags] & NSAlternateKeyMask) {
    [statusItem popUpStatusItemMenu:statusMenu];
  } else {
    if(panelController == nil) {
      panelController = [[PanelController alloc] initWithWindowNibName:@"Panel"];
    }

    if(panelWindow == nil) {
      panelWindow = [panelController window];
      NSRect panelRect = [panelWindow frame];
      NSRect screenRect = [[panelWindow screen] frame];
      
      panelRect.origin.y = screenRect.origin.y + screenRect.size.height - 30 - panelRect.size.height;
      panelRect.origin.x = screenRect.origin.x + screenRect.size.width - 30 - panelRect.size.width;
      [panelWindow setFrame:panelRect display:YES];
      [panelWindow setLevel:NSFloatingWindowLevel];
      
      if([buildStatusChecker builds] != nil) 
        panelController.builds = [buildStatusChecker builds];
    } else {
      if([panelWindow isVisible]) {
        panelWindow.isVisible = FALSE;
      } else {
        [panelWindow makeKeyAndOrderFront:nil];
      }
    }
  }
}

@end
