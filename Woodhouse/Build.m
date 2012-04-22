#import "Build.h"

NSString * const BuildStatusFailure = @"Failure";
NSString * const BuildStatusSuccess = @"Success";
NSString * const BuildStatusUnknown = @"Unknown";

@implementation Build

@synthesize name, status, url;

- (id)initWithName:(NSString *)aName status:(NSString *)aStatus url:(NSURL *)aUrl {
  self = [super init];
  if (self) {
    name = aName;
    status = aStatus;
    url = aUrl;
  }
  return self;
}

- (id)initFromNode:(NSXMLElement *)node {
  return [self initWithName:[[node attributeForName:@"name"] stringValue]
                     status:[[node attributeForName:@"lastBuildStatus"] stringValue]
                        url:[NSURL URLWithString: [[node attributeForName:@"webUrl"] stringValue]]];
}

- (BOOL)isFailure {
  return [[self status] isEqualToString: BuildStatusFailure];
}

- (BOOL)isSuccess {
  return [[self status] isEqualToString: BuildStatusSuccess];
}

- (BOOL)isUnknown {
  return [[self status] isEqualToString: BuildStatusUnknown];
}

- (BOOL)isPresent {
  return YES;
}

- (BOOL)isEqual:(id)object {
  return [[self name] isEqualToString:[(Build *)object name]];
}

- (NSUInteger)hash {
  return [[self name] hash];
}

@end
