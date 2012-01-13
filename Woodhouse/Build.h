//
//  Build.h
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2012 Braintree Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Build : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *status;

- (id)initWithName:(NSString*)name andStatus:(NSString*)status;

@end
