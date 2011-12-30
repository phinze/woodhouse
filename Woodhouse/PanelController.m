//
//  PanelController.m
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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

-(void) buildsDidUpdate:(NSNotification*)notification {
  self.builds = ((BuildStatusChecker*)notification.object).builds;
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

@end
