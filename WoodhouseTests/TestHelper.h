//
//  TestHelper.h
//  Woodhouse
//
//  Created by Paul Hinze on 1/28/12.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BuildStatusChecker;

#define OCLog(format, ...) NSLog([NSString stringWithFormat: @"%s:%d:%s:\033[35m%@\033[0m", __PRETTY_FUNCTION__, __LINE__, __FILE__, format], ## __VA_ARGS__)
#define OCOLog(object) OCLog(@"%@", object)

@interface TestHelper : NSObject

+ (BuildStatusChecker *) cannedBuildStatusChecker;

@end
