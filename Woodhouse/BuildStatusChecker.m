//
//  BuildStatusChecker.m
//  Woodhouse
//
//  Created by Paul Hinze on 12/9/11.
//  Copyright (c) 2011 Braintree. All rights reserved.
//

#import "BuildStatusChecker.h"
#import "Build.h"

@implementation BuildStatusChecker

@synthesize builds;

- (void) dealloc {
  [timer release];
}

- (id) init {
  if (self = [super init]){
    timer = [[NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateBuilds:) userInfo:nil repeats:NO] retain];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
  }
  return self;
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


@end