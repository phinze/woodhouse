//
//  TestHelper.m
//  Woodhouse
//
//  Created by Paul Hinze on 1/28/12.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import "TestHelper.h"

#import <Cocoa/Cocoa.h>
#import <OCMock/OCMock.h>

#import "BuildStatusChecker.h"

@interface BuildStatusChecker (Test)
- (void) makeRequest:(NSString*)url;
- (void) updateBuilds:(NSTimer *)timer;
@end

@implementation TestHelper

+ (BuildStatusChecker *) cannedBuildStatusChecker {
  NSXMLElement *root = (NSXMLElement *)[NSXMLNode elementWithName:@"Projects"];
  [root addChild:
   [NSXMLNode elementWithName:@"Project"
                     children:nil
                   attributes:[NSArray arrayWithObjects:
                               [NSXMLNode attributeWithName:@"name" stringValue:@"some-build"],
                               [NSXMLNode attributeWithName:@"webUrl" stringValue:@"http://ci.example.com/job/some-build"],
                               [NSXMLNode attributeWithName:@"lastBuildLabel" stringValue:@"66"],
                               [NSXMLNode attributeWithName:@"lastBuildTime" stringValue:@"2012-01-17T20:12:47Z"],
                               [NSXMLNode attributeWithName:@"lastBuildStatus" stringValue:@"Success"],
                               [NSXMLNode attributeWithName:@"activity" stringValue:@"Sleeping"],
                               nil]]];
  NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
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
