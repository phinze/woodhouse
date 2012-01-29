//
//  BuildStatusCheckerTests.m
//  Woodhouse
//
//  Created by Paul Hinze on 1/22/12.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import "BuildStatusCheckerTests.h"
#import "BuildStatusChecker.h"
#import "TestHelper.h"

#import <Cocoa/Cocoa.h>
#import <OCMock/OCMock.h>

@interface BuildStatusChecker (Test)
-(void)updateBuilds:(NSTimer *)t;
@end

@implementation BuildStatusCheckerTests

#pragma mark ocmock smoke testing

- (void)testMocksWork {
  id mockString = [OCMockObject mockForClass:[NSString class]];

  [[[mockString stub] andReturn:@"MOCKS ARE UP IN HERE"] lowercaseString];

  STAssertEqualObjects([mockString lowercaseString], @"MOCKS ARE UP IN HERE", nil);
}

#pragma mark isFirstBuild

- (void)testIsFirstBuildWhenFirstInitialized {
  BuildStatusChecker *bsc = [[BuildStatusChecker alloc] init];
  STAssertTrue([bsc isFirstRun], @"should be first run");
}

- (void)testIsFirstBuildWhenRunOnce {
  BuildStatusChecker *bsc = [TestHelper cannedBuildStatusChecker];
  [bsc updateBuilds:nil];
  STAssertTrue([bsc isFirstRun], @"should be first run");
}

- (void)testIsNoLongerFirstBuildWhenRunTwice {
  BuildStatusChecker *bsc = [TestHelper cannedBuildStatusChecker];
  [bsc updateBuilds:nil];
  [bsc updateBuilds:nil];
  STAssertFalse([bsc isFirstRun], @"should no longer be first run");
}

@end
