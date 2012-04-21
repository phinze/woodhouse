#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

@class BuildStatusChecker;

#define OCLog(format, ...) NSLog([NSString stringWithFormat: @"%s:%d:%s:\033[35m%@\033[0m", __PRETTY_FUNCTION__, __LINE__, __FILE__, format], ## __VA_ARGS__)
#define OCOLog(object) OCLog(@"%@", object)

@interface TestHelper : NSObject

+ (BuildStatusChecker *) cannedBuildStatusChecker;

@end
