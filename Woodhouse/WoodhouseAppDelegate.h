#import <Cocoa/Cocoa.h>
#import "PanelController.h"
#import "BuildStatusChecker.h"
@class BuildStatusNotifier;
@class BuildStatusItemView;

@interface WoodhouseAppDelegate : NSObject <NSApplicationDelegate> {
  NSStatusItem *statusItem;
  BuildStatusChecker *buildStatusChecker;
  BuildStatusNotifier *buildStatusNotifier;
  BuildStatusItemView *buildStatusItemView;
}

@end
