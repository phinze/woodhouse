//
//  WoodhouseAppDelegate.h
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PanelController.h"

@interface WoodhouseAppDelegate : NSObject <NSApplicationDelegate, NSURLConnectionDelegate> {
  NSStatusItem *statusItem;
  NSTimer *timer;
  NSMutableData *responseData;
  PanelController *panelController;
  NSMutableArray *builds;
}

@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;

- (IBAction) quit:(id)sender;

- (IBAction) handleClick:(id)sender;

@end
