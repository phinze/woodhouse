#import <Foundation/Foundation.h>
#import "Growl/Growl.h"

@interface BuildStatusNotifier : NSObject <GrowlApplicationBridgeDelegate>

-(id)init;
- (NSDictionary *) registrationDictionaryForGrowl;
- (NSString *) applicationNameForGrowl;


@end
