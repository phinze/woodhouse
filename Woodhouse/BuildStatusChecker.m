//
//  BuildStatusChecker.m
//  Woodhouse
//
//  Created by Paul Hinze on 12/9/11.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import "BuildStatusChecker.h"
#import "Build.h"

#define BUILD_UPDATE_DELAY_SECONDS 15.0

@interface BuildStatusChecker ()
- (Build *)buildFromPreviousRun:(Build *)currentBuild;
- (NSArray *)buildsThatJust:(SEL)statusSelector;
- (void)updateBuilds:(NSTimer*)theTimer;
- (void)scheduleNextCheck;
- (NSError *)parseResponseData;
@end

@implementation BuildStatusChecker

@synthesize builds;

- (id)init {
  if (self = [super init]){
    [self updateBuilds:nil];
    runCount = 0;
  }
  return self;
}

- (BOOL)isFirstRun {
  return runCount <= 1;
}

- (void)updateBuilds:(NSTimer*)theTimer {
  NSLog(@"updating builds");

  responseData = [NSMutableData data];

//  [[NSUserDefaults standardUserDefaults] setObject:@"https://user:pass@server/cc.xml" forKey:@"Jenkins URL"];
//  [[NSUserDefaults standardUserDefaults] synchronize];

  NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"Jenkins URL"];

  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) scheduleNextCheck {
  timer = [NSTimer timerWithTimeInterval:BUILD_UPDATE_DELAY_SECONDS
                                  target:self
                                selector:@selector(updateBuilds:)
                                userInfo:nil
                                 repeats:NO];
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

# pragma mark build diff methods

- (NSArray *)buildsThatJustAppeared {
  return [self buildsThatJust:@selector(isPresent)];
}

- (NSArray *)buildsThatJustFailed {
  return [self buildsThatJust:@selector(isFailure)];
}

- (NSArray *)buildsThatJustSucceeded {
  return [self buildsThatJust:@selector(isSuccess)];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (NSArray *)buildsThatJust:(SEL)statusSelector {
  return [builds objectsAtIndexes: [builds indexesOfObjectsPassingTest:
           ^BOOL(id obj, NSUInteger _idx, BOOL *_stop) {
             Build *build = (Build *)obj;
             BOOL matchesStatus = (BOOL)[build performSelector:statusSelector];
             Build *previousBuild = [self buildFromPreviousRun:build];
             BOOL statusChanged = !(BOOL)[previousBuild performSelector:statusSelector];
             return matchesStatus && statusChanged;
           }
         ]];
}
#pragma clang diagnostic pop

- (Build *)buildFromPreviousRun:(Build *)currentBuild {
  for (Build *oldBuild in oldBuilds) {
    if ([oldBuild isEqual: currentBuild]) {
      return oldBuild;
    }
  }
  return nil;
}


#pragma mark connection delegate methods

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
  NSError *parsingError = [self parseResponseData];
  if (parsingError) {
    [[NSAlert alertWithError:parsingError] runModal];
  } else {
    runCount++;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WoodhouseBuildsUpdated" object:self];
  }
  [self scheduleNextCheck];
}

- (NSError *) parseResponseData {
  NSError *error;

  NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:responseData options:NSXMLDocumentTidyXML error:&error];
  if (error) {return error;}

  NSString *xpathQueryString = @"//Projects/Project";
  NSArray *newItemsNodes = [[document rootElement] nodesForXPath:xpathQueryString error:&error];
  if (error) {return error;}

  oldBuilds = builds;
  builds = [[NSMutableArray alloc] init];
  for (NSXMLElement *node in newItemsNodes) {
    [builds addObject:[[Build alloc] initFromNode:node]];
  }
  return nil;
}

@end
