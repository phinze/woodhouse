#import <Cocoa/Cocoa.h>

@interface PanelController : NSWindowController <NSTableViewDataSource>

@property (nonatomic, unsafe_unretained) IBOutlet NSTableView *buildTableView;
@property (nonatomic, strong) NSArray *builds;

-(IBAction)openBuildURL:(id)sender;

@end
