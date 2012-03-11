#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController {
  IBOutlet NSTextField *passwordField;
  IBOutlet NSTextField *usernameField;
}

- (IBAction)storePassword:(id)sender;
- (void)openWindow;

@end
