//
//  BuildStatusChecker.m
//  Woodhouse
//
//  Created by Paul Hinze on 12/9/11.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import "BuildStatusChecker.h"
#import "Build.h"

#define BUILD_UPDATE_DELAY 5.0

@implementation BuildStatusChecker

@synthesize builds;


- (void) updateBuilds:(NSTimer*)theTimer {
  NSLog(@"updating builds");

  responseData = [NSMutableData data];

//  [[NSUserDefaults standardUserDefaults] setObject:@"https://user:pass@server/cc.xml" forKey:@"Jenkins URL"];
//  [[NSUserDefaults standardUserDefaults] synchronize];

  NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"Jenkins URL"];


  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) scheduleNextCheck {
  timer = [NSTimer timerWithTimeInterval:BUILD_UPDATE_DELAY target:self selector:@selector(updateBuilds:) userInfo:nil repeats:NO];
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (id) init {
  if (self = [super init]){
    [self updateBuilds:nil];
  }
  return self;
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
  [self scheduleNextCheck];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//  NSString *str =  [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
//  NSLog(@"Got results: %@", str);

  NSError *error;
  NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:responseData options:NSXMLDocumentTidyXML error:&error];

  NSString *xpathQueryString = @"//Projects/Project";

  NSArray *newItemsNodes = [[document rootElement] nodesForXPath:xpathQueryString error:&error];
  if (error)
  {
    [[NSAlert alertWithError:error] runModal];
    return;
  }

  builds = [[NSMutableArray alloc] init];

  for (NSXMLElement *node in newItemsNodes)
  {
    NSString *name = [[node attributeForName:@"name"] stringValue];
    NSString *status = [[node attributeForName:@"lastBuildStatus"] stringValue];
//    NSLog(@"%@ %@", name, status);
    [builds addObject:[[Build alloc] initWithName:name andStatus:status]];
  }

  [[NSNotificationCenter defaultCenter] postNotificationName:@"WoodhouseBuildsUpdated" object:self];
  [self scheduleNextCheck];
}


@end
