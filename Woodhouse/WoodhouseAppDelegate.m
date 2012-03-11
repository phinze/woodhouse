#import "WoodhouseAppDelegate.h"
#import "Build.h"
#import "BuildStatusItemView.h"
#import "BuildStatusNotifier.h"

@implementation WoodhouseAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  buildStatusChecker = [[BuildStatusChecker alloc] init];

  CGRect rect = CGRectMake(0, 0, 1, 1);
  buildStatusItemView = [[BuildStatusItemView alloc] initWithFrame:rect];
  buildStatusItemView.statusItem = statusItem;

  buildStatusNotifier = [[BuildStatusNotifier alloc] init];

  [statusItem setView:buildStatusItemView];
}

- (void)applicationWillResignActive:(NSNotification *)aNotification {
  [buildStatusItemView deactivate];
}

@end
