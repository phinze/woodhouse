//
//  BuildStatusItemView.h
//  Woodhouse
//
//  Created by Paul Hinze on 12/10/11.
//  Copyright (c) 2011 Braintree. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PanelController.h"
#import "BuildStatusChecker.h"

@interface BuildStatusItemView : NSView <NSMenuDelegate> {
  NSDictionary *statusIcons;
  PanelController *panelController;
  NSWindow *panelWindow;
}

@property (retain, nonatomic) NSStatusItem *statusItem;
@property (retain, nonatomic) BuildStatusChecker *buildStatusChecker;
@property (retain, nonatomic) NSString *title;

@property (nonatomic, retain) NSMenu *statusMenu;

#define StatusItemViewPaddingWidth  6
#define StatusItemViewPaddingHeight 3

@end
