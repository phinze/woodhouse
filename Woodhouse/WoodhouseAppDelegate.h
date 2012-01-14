//
//  WoodhouseAppDelegate.h
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2012 Braintree Payments. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PanelController.h"
#import "BuildStatusChecker.h"
@class BuildStatusItemView;

@interface WoodhouseAppDelegate : NSObject <NSApplicationDelegate> {
  NSStatusItem *statusItem;
  BuildStatusChecker *buildStatusChecker;
  BuildStatusItemView *buildStatusItemView;
}

@end