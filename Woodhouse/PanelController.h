//
//  PanelController.h
//  Woodhouse
//
//  Created by pair on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PanelController : NSWindowController <NSTableViewDataSource>

@property (nonatomic, retain) IBOutlet NSTableView *buildTableView;
@property (nonatomic, retain) NSArray *builds;

@end
