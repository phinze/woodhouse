#import "TestHelper.h"
#import "Build.h"

@interface BuildTests : SenTestCase
@end

@implementation BuildTests

#pragma mark initFromNode

- (void)testInitializesAttributesFromNode {
  NSString *projectXml = @"<Project name='build-name-in-xml'"
    " webUrl='http://ci.example.com/job/build-name-in-xml'"
    " lastBuildLabel='123'"
    " lastBuildTime='2012-01-17T20:12:47Z'"
    " lastBuildStatus='Failure'"
    " activity='Sleeping'"
    " />";
  NSError *error;
  NSXMLElement *node = [[NSXMLElement alloc] initWithXMLString:projectXml error:&error];
  if (error) {
    STFail(@"error parsing xml: %@", error);
  }

  Build *b = [[Build alloc] initFromNode:node];
  
  STAssertEqualObjects(b.name, @"build-name-in-xml", nil);
  STAssertEqualObjects(b.status, @"Failure", nil);
  NSURL *expectedUrl = [NSURL URLWithString:@"http://ci.example.com/job/build-name-in-xml"];
  STAssertEqualObjects(b.url, expectedUrl, nil);
}

#pragma mark isFailure

- (void)testIsFailureWhenStatusMatches {
  Build *build = [[Build alloc] initWithName:@"" status:@"Failure" url:[NSURL URLWithString:@""]];
  STAssertTrue([build isFailure], nil);
}

#pragma mark isSuccess

- (void)testIsSuccessWhenStatusMatches {
  Build *build = [[Build alloc] initWithName:@"" status:@"Success" url:[NSURL URLWithString:@""]];
  STAssertTrue([build isSuccess], nil);
}

#pragma mark isUnknown

- (void)testIsUnknownWhenStatusMatches {
  Build *build = [[Build alloc] initWithName:@"" status:@"Unknown" url:[NSURL URLWithString:@""]];
  STAssertTrue([build isUnknown], nil);
}

#pragma mark isPresent

- (void)testIsPresentAlwaysReturnsTrue {
  Build *build = [[Build alloc] init];
  STAssertTrue([build isPresent], nil);
}

#pragma mark isEqual

-(void)testBuildsWithSameNameAreEqual {
  Build *buildOne = [[Build alloc] initWithName:@"samename" status:@"one" url:[NSURL URLWithString:@"http://one"]];
  Build *buildTwo = [[Build alloc] initWithName:@"samename" status:@"two" url:[NSURL URLWithString:@"http://two"]];
  STAssertEqualObjects(buildOne, buildTwo, nil);
}

@end
