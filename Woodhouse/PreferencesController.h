//
//  PreferencesController.h
//  Woodhouse
//
//  Created by Paul Hinze on 1/29/12.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController {
  IBOutlet NSTextField *passwordField;
  IBOutlet NSTextField *usernameField;
}

- (IBAction)storePassword:(id)sender;
- (void)openWindow;

@end
