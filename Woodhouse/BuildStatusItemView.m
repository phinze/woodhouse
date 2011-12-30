//
//  BuildStatusItemView.m
//  Woodhouse
//
//  Created by Paul Hinze on 12/10/11.
//  Copyright (c) 2011 Braintree. All rights reserved.
//

#import "BuildStatusItemView.h"

@implementation BuildStatusItemView

@synthesize statusItem;
@synthesize statusMenu;
@synthesize buildStatusChecker;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      statusItem = nil;
      title = @"";
      isMenuVisible = NO;
      statusIcons = [[NSDictionary dictionaryWithObjectsAndKeys:
        [[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"watchdog-ok" ofType:@"png"]] retain], @"ok",
        nil
      ] retain];
      NSLog(@"%@", statusIcons); 
    }
    
    return self;
}


- (void) dealloc {
  [statusItem release];
  [statusMenu release];
  [title release];
  [super dealloc];
}


- (NSColor *)titleForegroundColor {
  if (isMenuVisible) {
    return [NSColor whiteColor];
  }
  else {
    return [NSColor blackColor];
  }    
}

- (NSDictionary *)titleAttributes {
  // Use default menu bar font size
  NSFont *font = [NSFont menuBarFontOfSize:0];
  
  NSColor *foregroundColor = [self titleForegroundColor];
  
  return [NSDictionary dictionaryWithObjectsAndKeys:
          font,            NSFontAttributeName,
          foregroundColor, NSForegroundColorAttributeName,
          nil];
}

- (NSRect)titleBoundingRect {
  return [title boundingRectWithSize:NSMakeSize(1e100, 1e100)
                             options:0
                          attributes:[self titleAttributes]];
}

- (void)setTitle:(NSString *)newTitle {
  if (![title isEqual:newTitle]) {
    [newTitle retain];
    [title release];
    title = newTitle;
    
    // Update status item size (which will also update this view's bounds)
    NSRect titleBounds = [self titleBoundingRect];
    int newWidth = titleBounds.size.width + (2 * StatusItemViewPaddingWidth);
    [statusItem setLength:newWidth];
    
    [self setNeedsDisplay:YES];
  }
}

- (NSString *)title {
  return title;
}

- (void)drawRect:(NSRect)dirtyRect
{
  [[NSGraphicsContext currentContext] setShouldAntialias:YES];
  // Draw status bar background, highlighted if menu is showing
  [statusItem drawStatusBarBackgroundInRect:[self bounds]
                              withHighlight:isMenuVisible];
  
  // Draw title string
  NSPoint origin = NSMakePoint(StatusItemViewPaddingWidth,
                               StatusItemViewPaddingHeight);
  [[statusIcons objectForKey:@"ok"] drawAtPoint:origin fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
  [title drawAtPoint:origin
      withAttributes:[self titleAttributes]];
}

- (void)mouseDown:(NSEvent *)event {
  NSLog(@"got mousedown");
  if(panelController == nil) {
    panelController = [[PanelController alloc] initWithWindowNibName:@"Panel"];
  }
  
  NSWindow *panel = [panelController window];
  
  NSRect panelRect = [panel frame];
  NSRect screenRect = [[panel screen] frame];
  
  panelRect.origin.y = screenRect.origin.y + screenRect.size.height - 30 - panelRect.size.height;
  panelRect.origin.x = screenRect.origin.x + screenRect.size.width - 30 - panelRect.size.width;
  [panel setFrame:panelRect display:YES];
  
  if([buildStatusChecker builds] != nil) 
    panelController.builds = [buildStatusChecker builds];
  
  [panel makeKeyAndOrderFront:nil];
}

- (void)rightMouseDown:(NSEvent *)event {
  [statusItem popUpStatusItemMenu:statusMenu];
}

- (void)menuWillOpen:(NSMenu *)menu {
  isMenuVisible = YES;
  [self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu {
  isMenuVisible = NO;
  [menu setDelegate:nil];    
  [self setNeedsDisplay:YES];
}

- (void) quit:(id)sender {
  [NSApp terminate:sender];
}

@end
