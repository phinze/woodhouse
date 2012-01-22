//
//  Build.m
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2012 Braintree Payments. All rights reserved.
//

#import "Build.h"

NSString * const BuildStatusFailure = @"Failure";
NSString * const BuildStatusSuccess = @"Success";
NSString * const BuildStatusUnknown = @"Unknown";

@implementation Build

@synthesize name, status, url;

- (id)initFromNode:(NSXMLElement *)node {
    self = [super init];
    if (self) {
      name = [[node attributeForName:@"name"] stringValue];
      status = [[node attributeForName:@"lastBuildStatus"] stringValue];
      url = [NSURL URLWithString: [[node attributeForName:@"webUrl"] stringValue]];
    }

    return self;
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