//
//  Build.m
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2012 Braintree Payments. All rights reserved.
//

#import "Build.h"

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

@end
