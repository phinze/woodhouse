//
//  PanelController.m
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PanelController.h"

@implementation PanelController 

@synthesize buildTableView;
@synthesize builds;

- (void) setBuilds:(NSArray *)newBuilds {
  builds = newBuilds;
  [buildTableView reloadData];
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
  return [builds count];
}


- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return [[NSCell alloc] initTextCell:[builds objectAtIndex:row]];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return [builds objectAtIndex:row];
}

@end
