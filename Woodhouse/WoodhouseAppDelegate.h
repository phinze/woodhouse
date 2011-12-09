//
//  WoodhouseAppDelegate.h
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WoodhouseAppDelegate : NSObject <NSApplicationDelegate> {
    NSStatusItem *statusItem;
    NSTimer *timer;
}

@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;

- (IBAction) quit:(id)sender;

@end
