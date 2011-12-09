//
//  PanelController.m
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PanelController.h"
#import "Build.h"

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

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  Build *build = [builds objectAtIndex:row];
  if ([[tableColumn identifier] isEqualToString:@"build"]) {
    return build.name;
  } else {
    return build.status;
  }
}

//- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//  if([tableColumn identifier] isEqualToString:<#(NSString *)#>
//  return [[NSCell alloc] initTextCell:[builds objectAtIndex:row]];
//}



@end
