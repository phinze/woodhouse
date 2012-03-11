#import <Foundation/Foundation.h>

@interface BuildStatusChecker : NSObject <NSURLConnectionDelegate> {
  NSTimer *timer;
  NSMutableData *responseData;
  NSMutableArray *oldBuilds;
  NSUInteger runCount;
}

@property(strong, readonly) NSMutableArray *builds;

-(NSArray*)buildsThatJustSucceeded;
-(NSArray*)buildsThatJustFailed;
-(NSArray*)buildsThatJustAppeared;

-(BOOL)isFirstRun;

@end
