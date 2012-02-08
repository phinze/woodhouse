//
//  PreferencesController.m
//  Woodhouse
//
//  Created by Paul Hinze on 1/29/12.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import <Sparkle/Sparkle.h>
#import "PreferencesController.h"
#import "WoodhouseKeychain.h"

@interface PreferencesController (Private)
@end

@implementation PreferencesController

- (void)openWindow {
  NSWindow *preferencesWindow = [self window];
  NSString *storedPassword = [[WoodhouseKeychain sharedKeychain] getKeychainPasswordForUsername:nil];
  [passwordField setStringValue:storedPassword];
  [NSApp activateIgnoringOtherApps:YES];
  [preferencesWindow makeKeyAndOrderFront:self];
}

- (IBAction)storePassword:(id)sender {
  [[WoodhouseKeychain sharedKeychain] setKeychainPassword:[passwordField stringValue] username:nil];
}

- (IBAction)checkForUpdates:(id)sender {
  [[SUUpdater sharedUpdater] checkForUpdates:self];
}

@end
