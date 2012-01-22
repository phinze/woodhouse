//
//  BuildStatusNotifier.m
//  Woodhouse
//
//  Created by Paul Hinze on 1/16/12.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import "BuildStatusNotifier.h"
#import "BuildStatusChecker.h"
#import "Build.h"

#define BuildFailureNotificationName @"Build Failure"
#define BuildSuccessNotificationName @"Build Success"

@interface BuildStatusNotifier ()
- (void) buildsDidUpdate:(NSNotification *)notification;
- (void) crashAndBurn;
- (void) initGrowl;
- (void) notifyFailedBuild:(Build *)build;
- (void) notifySuccessfulBuild:(Build *)build;
- (void) notifyWithName:(NSString *)name title:(NSString *)title description: (NSString *)description;
- (void) watchForUpdatedBuilds;
@end

@implementation BuildStatusNotifier

- (id) init {
  self = [super init];
  if (self) {
    [self initGrowl];
    [self watchForUpdatedBuilds];
  }
  return self;
}

-(void)initGrowl {
	NSString *growlPath = [[[NSBundle mainBundle] privateFrameworksPath] stringByAppendingPathComponent:@"Growl.framework"];
	NSBundle *growlBundle = [NSBundle bundleWithPath:growlPath];
	if (growlBundle && [growlBundle load]) {
		[GrowlApplicationBridge setGrowlDelegate:self];
	}
	else {
    [self crashAndBurn];
	}
}

- (void) watchForUpdatedBuilds {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildsDidUpdate:) name:@"WoodhouseBuildsUpdated" object:nil];
}

- (void) buildsDidUpdate:(NSNotification*)notification {
  BuildStatusChecker *bsc = ((BuildStatusChecker *) notification.object);
  if ([bsc isFirstRun]) { return; }

  for (Build *failedBuild in [bsc buildsThatJustFailed]) {
    [self notifyFailedBuild:failedBuild];
  }
  for (Build *successfulBuild in [bsc buildsThatJustSucceeded]) {
    [self notifySuccessfulBuild:successfulBuild];
  }
}

- (void) notifyFailedBuild:(Build *)build {
  [self notifyWithName:BuildFailureNotificationName
                 title:@"Build Failed"
           description:[build name]];
}

- (void) notifySuccessfulBuild:(Build *)build {
  [self notifyWithName:BuildSuccessNotificationName
                 title:@"Build Succeeded"
           description:[build name]];
}

- (void) notifyWithName:(NSString *)name title:(NSString *)title description: (NSString *)description {
  [GrowlApplicationBridge notifyWithTitle:title
                              description:description
                         notificationName:name
                                 iconData:nil
                                 priority:0
                                 isSticky:NO
                             clickContext:nil];
}

- (void) crashAndBurn {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert addButtonWithTitle:@"Quit"];
  [alert setMessageText:@"Whoops, could not load Growl!"];
  [alert setInformativeText:@"Please figure out what's wrong with your Growl install, or what's wrong with Woodhouse."];
  [alert setAlertStyle:NSCriticalAlertStyle];
  [alert runModal];
  [NSApp terminate: nil];
}

@end