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
  [timer release];
}

- (void) updateBuilds:(NSTimer*)theTimer {
  NSLog(@"updating builds");
  
  responseData = [[NSMutableData data] retain];
  
//  [[NSUserDefaults standardUserDefaults] setObject:@"https://user:pass@server/cc.xml" forKey:@"Jenkins URL"];
//  [[NSUserDefaults standardUserDefaults] synchronize];
  
  NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"Jenkins URL"];

  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  [[NSAlert alertWithError:error] runModal];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSString *str =  [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
  NSLog(@"Got results: %@", str);
  
  NSError *error;
  NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:responseData options:NSXMLDocumentTidyXML error:&error];
  
  NSString *xpathQueryString = @"//Projects/Project";

  NSArray *newItemsNodes = [[document rootElement] nodesForXPath:xpathQueryString error:&error];
  if (error)
  {
    [[NSAlert alertWithError:error] runModal];
    return;
  }
  
  [builds release];
  builds = [[[NSMutableArray alloc] init] retain];
  
  for (NSXMLElement *node in newItemsNodes)
  {
    NSString *name = [[node attributeForName:@"name"] stringValue];
    NSString *status = [[node attributeForName:@"lastBuildStatus"] stringValue];
    NSLog(@"%@ %@", name, status); 
    [builds addObject:[[Build alloc] initWithName:name andStatus:status]];
  }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSImage *image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"watchdog-ok" ofType:@"png"]];
  
  statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];

  [statusItem setImage:image];
  [statusItem setHighlightMode:YES];
  
  [statusItem setAction:@selector(handleClick:)];
  [statusItem setTarget:self];

  timer = [[NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(updateBuilds:) userInfo:nil repeats:NO] retain];
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
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
    
    NSWindow *panel = [panelController window];
    [panel makeKeyAndOrderFront:nil];
    
    NSRect panelRect = [panel frame];
    NSRect screenRect = [[panel screen] frame];
    
    panelRect.origin.y = screenRect.origin.y + screenRect.size.height - 30 - panelRect.size.height;
    panelRect.origin.x = screenRect.origin.x + screenRect.size.width - 30 - panelRect.size.width;
    [panel setFrame:panelRect display:YES];
    
    if(builds != nil) 
      panelController.builds = builds;
  
  }
}

@end
