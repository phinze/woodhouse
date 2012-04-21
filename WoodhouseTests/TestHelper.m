//
//  TestHelper.m
//  Woodhouse
//
//  Created by Paul Hinze on 1/28/12.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import "TestHelper.h"

#import "BuildStatusChecker.h"

@interface BuildStatusChecker (Test)
- (void) makeRequest:(NSString*)url;
- (void) updateBuilds:(NSTimer *)timer;
@end

@implementation TestHelper

+ (BuildStatusChecker *) cannedBuildStatusChecker {
  NSError *parsingError;

  NSString *xml =@"<Projects>\n"
    "<Project name='some-build'"
    "         webUrl='http://ci.example.com/job/some-build'"
    "         lastBuildLabel='66'"
    "         lastBuildTime='2012-01-17T20:12:47Z'"
    "         lastBuildStatus='Success'"
    "         activity='Sleeping'"
    "         />"
    "</Projects>";

  NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithXMLString:xml options:0 error:&parsingError];

  if (parsingError) {
    NSLog(@"parsing error for canned test response!");
    return NULL;
  }
  NSData *xmlData = [xmlDoc XMLData];

  BuildStatusChecker *actual = [[BuildStatusChecker alloc] init];
  id partialMock = [OCMockObject partialMockForObject:actual];
  [[[partialMock stub] andDo:^(NSInvocation *i) {
    [partialMock connection:nil didReceiveData:xmlData];
    [partialMock connectionDidFinishLoading:nil];
  }] makeRequest:OCMOCK_ANY];

  return partialMock;
}

@end