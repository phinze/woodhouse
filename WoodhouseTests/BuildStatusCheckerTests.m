#import "BuildStatusChecker.h"
#import "TestHelper.h"

#import <SenTestingKit/SenTestingKit.h>
#import <Cocoa/Cocoa.h>
#import <OCMock/OCMock.h>

@interface BuildStatusChecker (Test)
-(void)updateBuilds:(NSTimer *)t;
- (double)buildDelaySeconds;
@end

@interface BuildStatusCheckerTests : SenTestCase
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

- (void)testBuildDelaySecondsWhenNoPreferenceIsSet {
  BuildStatusChecker *bsc = [[BuildStatusChecker alloc] init];
  STAssertEquals([bsc buildDelaySeconds], 90.0, @"should default to 90 seconds");
}

- (void)testBuildDelaySecondsWhenPreferenceIsSet {
  [[NSUserDefaults standardUserDefaults] setObject:@"120" forKey:@"Build Update Delay"];
  BuildStatusChecker *bsc = [[BuildStatusChecker alloc] init];
  STAssertEquals([bsc buildDelaySeconds], 120.0, @"should return the set number of seconds");
}

@end
