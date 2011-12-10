//
//  BuildStatusChecker.h
//  Woodhouse
//
//  Created by Paul Hinze on 12/9/11.
//  Copyright (c) 2011 Braintree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildStatusChecker : NSObject <NSURLConnectionDelegate> {
  NSTimer *timer;
  NSMutableData *responseData;
  NSMutableArray *builds;
}

@property(readonly) NSMutableArray *builds;

@end
