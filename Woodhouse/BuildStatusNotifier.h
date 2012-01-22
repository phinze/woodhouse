//
//  BuildStatusNotifier.h
//  Woodhouse
//
//  Created by Paul Hinze on 1/16/12.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Growl/Growl.h"

@interface BuildStatusNotifier : NSObject <GrowlApplicationBridgeDelegate>

-(id)init;

@end
