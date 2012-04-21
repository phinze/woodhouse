#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

@interface SmokeTests : SenTestCase
@end

@implementation SmokeTests

#pragma mark ocmock smoke testing

- (void)testMocksWork {
  id mockString = [OCMockObject mockForClass:[NSString class]];

  [[[mockString stub] andReturn:@"MOCKS ARE UP IN HERE"] lowercaseString];

  STAssertEqualObjects([mockString lowercaseString], @"MOCKS ARE UP IN HERE", nil);
}

@end