//
//  Build.h
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2012 Braintree Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const BuildStatusFailure;
extern NSString * const BuildStatusSuccess;
extern NSString * const BuildStatusUnknown;

@interface Build : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, copy, readonly) NSURL *url;

- (id)initFromNode:(NSXMLElement *)node;

- (BOOL)isSuccess;
- (BOOL)isFailure;
- (BOOL)isUnknown;

- (BOOL)isPresent;

@end
