//
//  PanelController.m
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2012 Braintree Payments. All rights reserved.
//

#import "PanelController.h"
#import "Build.h"
#import "BuildStatusChecker.h"

@implementation PanelController

@synthesize buildTableView;
@synthesize builds;

- (id)initWithWindowNibName:(NSString *)windowNibName {
  if (self = [super initWithWindowNibName:windowNibName]) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildsDidUpdate:) name:@"WoodhouseBuildsUpdated" object:nil];
  }
  return self;
}

-(void) windowDidLoad {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *lastSortKey = [defaults objectForKey:@"last_sort_key"];

  NSSortDescriptor *descriptor;
  if(lastSortKey) {
    NSNumber *lastSortAscending = [defaults objectForKey:@"last_sort_ascending"];
    descriptor = [NSSortDescriptor sortDescriptorWithKey:lastSortKey ascending:[lastSortAscending boolValue]];
  } else {
    descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  }
  [buildTableView setSortDescriptors:[NSArray arrayWithObject:descriptor]];
  [buildTableView setTarget:self];
  [buildTableView setDoubleAction:@selector(openBuildURL:)];
}

-(IBAction)openBuildURL:(id)sender {
  NSInteger row = [buildTableView clickedRow];
  (void) [[NSWorkspace sharedWorkspace] openURL: [[builds objectAtIndex:row] url]];
}

-(void) buildsDidUpdate:(NSNotification*)notification {
  NSArray *temp = ((BuildStatusChecker*)notification.object).builds;
  self.builds = [temp sortedArrayUsingDescriptors:[buildTableView sortDescriptors]];
  [buildTableView reloadData];
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
  return [builds count];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  Build *build = [builds objectAtIndex:row];
  if ([[tableColumn identifier] isEqualToString:@"build"]) {
    return build.name;
  } else {
    return build.status;
  }
}

- (void) tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors {
  NSArray *current = [tableView sortDescriptors];
  self.builds = [self.builds sortedArrayUsingDescriptors:current];
  [buildTableView reloadData];

  if([current count] > 0) {
    NSSortDescriptor *descriptor = [current objectAtIndex:0];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[descriptor key] forKey:@"last_sort_key"];
    [defaults setObject:[NSNumber numberWithBool:[descriptor ascending]] forKey:@"last_sort_ascending"];
    [defaults synchronize];
  }
}

@end
