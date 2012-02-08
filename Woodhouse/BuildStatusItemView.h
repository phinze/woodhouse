//
//  BuildStatusItemView.h
//  Woodhouse
//
//  Created by Paul Hinze on 12/10/11.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PanelController.h"
#import "PreferencesController.h"
#import "BuildStatusChecker.h"

@interface BuildStatusItemView : NSView <NSMenuDelegate> {
  NSDictionary *statusIcons;
  PanelController *panelController;
  PreferencesController *preferencesController;
  NSWindow *panelWindow;
  NSMutableDictionary *buildCounts;
}

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) BuildStatusChecker *buildStatusChecker;

@property (nonatomic, strong) NSMenu *statusMenu;

#define StatusItemViewPaddingWidth  6
#define StatusItemViewInternalPaddingWidth 3
#define StatusItemViewPaddingHeight 3

-(void)deactivate;

@end