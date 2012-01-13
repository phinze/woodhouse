//
//  BuildStatusChecker.h
//  Woodhouse
//
//  Created by Paul Hinze on 12/9/11.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildStatusChecker : NSObject <NSURLConnectionDelegate> {
  NSTimer *timer;
  NSMutableData *responseData;
}

@property(strong, readonly) NSMutableArray *builds;

@end
