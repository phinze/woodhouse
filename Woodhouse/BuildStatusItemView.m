//
//  BuildStatusItemView.m
//  Woodhouse
//
//  Created by Paul Hinze on 12/10/11.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import "BuildStatusItemView.h"
#import "Build.h"
#import "Notifications.h"

@implementation BuildStatusItemView

@synthesize statusItem;
@synthesize statusMenu;
@synthesize buildStatusChecker;

#define SUCCESSFUL_BUILDS 0
#define FAILED_BUILDS 1

@interface BuildStatusItemView (Private)
-(int)measureWidth;
-(void)drawIcons;
@end

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.statusItem = nil;
      statusIcons = [NSDictionary dictionaryWithObjectsAndKeys:
        [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"watchdog-ok" ofType:@"png"]], @"Success",
        [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"watchdog-error" ofType:@"png"]], @"Failure",
        nil
      ];

      self.statusMenu = [[NSMenu alloc] initWithTitle:@""];
      [[statusMenu addItemWithTitle:@"Check Now" action:@selector(checkNow:) keyEquivalent:@""] setTarget:self];
      [[statusMenu addItemWithTitle:@"Preferences" action:@selector(openPreferences:) keyEquivalent:@""] setTarget:self];
      [[statusMenu addItemWithTitle:@"About" action:@selector(about:) keyEquivalent:@""] setTarget:self];
      [[statusMenu addItemWithTitle:@"Quit" action:@selector(quit:) keyEquivalent:@""] setTarget:self];

      panelController = [[PanelController alloc] initWithWindowNibName:@"Panel"];
      preferencesController = [[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
      buildCounts = [[NSMutableDictionary alloc] init];
      [buildCounts setObject:@"?" forKey:@"Success"];
      [buildCounts setObject:@"?" forKey:@"Failure"];

      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildsDidUpdate:) name:@"WoodhouseBuildsUpdated" object:nil];
    }

    return self;
}

- (BOOL) isPanelVisible {
  return panelWindow != nil && [panelWindow isVisible];
}

- (void)deactivate {
  panelWindow.isVisible = FALSE;
  [self setNeedsDisplay:YES];
}

- (NSColor *)textForegroundColor {
  if ([self isPanelVisible]) {
    return [NSColor whiteColor];
  }
  else {
    return [NSColor blackColor];
  }
}

- (NSDictionary *) textAttributes {
  // Use default menu bar font size
  NSFont *font = [NSFont menuBarFontOfSize:0];

  NSColor *foregroundColor = [self textForegroundColor];

  return [NSDictionary dictionaryWithObjectsAndKeys:
          font,            NSFontAttributeName,
          foregroundColor, NSForegroundColorAttributeName,
          nil];
}

- (int) widthOfText:(NSString *)string {
  return [string boundingRectWithSize:NSMakeSize(1e100, 1e100)
                             options:0
                          attributes:[self textAttributes]].size.width;
}

- (void) buildsDidUpdate:(NSNotification*)notification {
  for(NSString *key in [buildCounts allKeys]) {
    [buildCounts setObject:[NSDecimalNumber zero] forKey:key];
  }

  BuildStatusChecker *bsc = ((BuildStatusChecker*) notification.object);
  for(Build *b in bsc.builds) {
    NSDecimalNumber *count = [buildCounts objectForKey:b.status];
    if(count == nil) {
      count = [NSDecimalNumber zero];
    }
    [buildCounts setObject:[count decimalNumberByAdding:[NSDecimalNumber one]] forKey:b.status];
  }

  [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
  [[NSGraphicsContext currentContext] setShouldAntialias:YES];
  [statusItem setLength:[self measureWidth]];
  [statusItem drawStatusBarBackgroundInRect:[self bounds] withHighlight:[self isPanelVisible]];
  [self drawIcons];
}

-(int)measureWidth {
  NSImage *icon;
  int new_width = StatusItemViewPaddingWidth;

  for(NSString *key in buildCounts) {
    if((icon = [statusIcons objectForKey:key])) {
      new_width += icon.size.width + StatusItemViewInternalPaddingWidth;
      new_width += [self widthOfText:[NSString stringWithFormat:@"%@",[buildCounts objectForKey:key]]] + StatusItemViewPaddingWidth;
    }
  }
  return new_width;

}

-(void)drawIcons {
  NSImage *icon;  
  NSPoint draw_cursor = NSMakePoint(StatusItemViewPaddingWidth, StatusItemViewPaddingHeight);

  for(NSString *key in buildCounts) {
    if((icon = [statusIcons objectForKey:key])) {
      [icon drawAtPoint:draw_cursor fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
      draw_cursor.x += icon.size.width + StatusItemViewInternalPaddingWidth;
      
      NSString *text = [NSString stringWithFormat:@"%@",[buildCounts objectForKey:key]];
      [text drawAtPoint:draw_cursor withAttributes:[self textAttributes]];
      draw_cursor.x += [self widthOfText:text] + StatusItemViewPaddingWidth;
    }
  }
}

- (void)mouseDown:(NSEvent *)event {
  if(panelWindow != nil && [panelWindow isVisible]) {
    [self deactivate];
  } else {
    panelWindow = [panelController window];
    NSRect panelRect = panelWindow.frame;
    NSRect screenRect = [self.window convertRectToScreen:self.frame];

    panelRect.origin.x = NSMidX(screenRect) - panelRect.size.width/2;
    panelRect.origin.y = NSMinY(screenRect) - panelRect.size.height;

    [panelWindow setFrame:panelRect display:YES];
    [panelWindow setLevel:NSFloatingWindowLevel];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES]; /* need to "activate" app on every show otherwise
                                                                        * blur-hiding will not work after the first time */
    [panelWindow makeKeyAndOrderFront:self];
  }
  [self setNeedsDisplay:YES];
}

- (void)rightMouseDown:(NSEvent *)event {
  [statusItem popUpStatusItemMenu:statusMenu];
}

- (void)menuWillOpen:(NSMenu *)menu {
  [self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu {
  [menu setDelegate:nil];
  [self setNeedsDisplay:YES];
}

- (void) checkNow:(id)sender {
  [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_BUILDS_NOW object:nil];
}

- (void) openPreferences:(id)sender {
  [preferencesController openWindow];
}

- (void) about:(id)sender {
  [NSApp orderFrontStandardAboutPanel:sender];
}

- (void) quit:(id)sender {
  [NSApp terminate:sender];
}

@end
