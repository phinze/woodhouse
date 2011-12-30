//
//  Build.m
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Build.h"

@implementation Build

@synthesize name, status;

- (id)initWithName:(NSString*)aName andStatus:(NSString*)aStatus
{
    self = [super init];
    if (self) {
      name = aName;
      status = aStatus;
    }

    return self;
}

@end
