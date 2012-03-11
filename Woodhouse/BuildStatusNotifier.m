#import "BuildStatusNotifier.h"
#import "BuildStatusChecker.h"
#import "Build.h"
#import "Notifications.h"

#define GROWL_BUILD_FAILED @"Build Failure"
#define GROWL_BUILD_SUCCEEDED @"Build Success"
#define GROWL_BUILD_APPEARED @"New Build"
#define GROWL_BUILD_CHECK_ERROR @"Error Checking Builds"

@interface BuildStatusNotifier ()
- (void) buildsDidFailToUpdate:(NSNotification *)notification;
- (void) buildsDidUpdate:(NSNotification *)notification;
- (void) crashAndBurn;
- (void) initGrowl;
- (void) notifyErrorUpdatingBuilds:(NSError *)error;
- (void) notifyFailedBuild:(Build *)build;
- (void) notifySuccessfulBuild:(Build *)build;
- (void) notifyWithName:(NSString *)name title:(NSString *)title description: (NSString *)description;
- (void) watchForErrors;
- (void) watchForUpdatedBuilds;
@end

@implementation BuildStatusNotifier

- (id) init {
  self = [super init];
  if (self) {
    [self initGrowl];
    [self watchForUpdatedBuilds];
    [self watchForErrors];
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

- (void) watchForErrors {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildsDidFailToUpdate:) name:BUILDS_FAILED_TO_UPDATE object:nil];
}

- (void) watchForUpdatedBuilds {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildsDidUpdate:) name:BUILDS_UPDATED object:nil];
}

- (void) buildsDidFailToUpdate:(NSNotification *)notification {
  NSError *error = ((NSError *) notification.object);
  [self notifyErrorUpdatingBuilds:error];
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

- (void) notifyErrorUpdatingBuilds:(NSError *)error {
  [self notifyWithName:GROWL_BUILD_CHECK_ERROR
                 title:@"Error Updating Builds"
           description:[error localizedDescription]];
}

- (void) notifyFailedBuild:(Build *)build {
  [self notifyWithName:GROWL_BUILD_FAILED
                 title:@"Build Failed"
           description:[build name]];
}

- (void) notifyNewBuild:(Build *)build {
  [self notifyWithName:GROWL_BUILD_APPEARED
                 title:@"New Build Detected"
           description:[build name]];
}

- (void) notifySuccessfulBuild:(Build *)build {
  [self notifyWithName:GROWL_BUILD_SUCCEEDED
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

- (NSDictionary *) registrationDictionaryForGrowl
{
  NSArray * notifications = [NSArray arrayWithObjects:
                             GROWL_BUILD_APPEARED,
                             GROWL_BUILD_CHECK_ERROR,
                             GROWL_BUILD_FAILED,
                             GROWL_BUILD_SUCCEEDED,
                             nil];
  return [NSDictionary dictionaryWithObjectsAndKeys: notifications, GROWL_NOTIFICATIONS_ALL,
          notifications, GROWL_NOTIFICATIONS_DEFAULT, nil];
}

- (NSString *) applicationNameForGrowl
{
    return @"Woodhouse";
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
