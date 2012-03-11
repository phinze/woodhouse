#import <Foundation/Foundation.h>

extern  NSString * const WoodhouseKeychainService;

@interface WoodhouseKeychain : NSObject {
  NSString *service;
}

+(WoodhouseKeychain *)sharedKeychain;
+ (NSDictionary *)genericPasswordsWithService:(NSString *)service;

- (WoodhouseKeychain *)initWithService: (NSString *) serviceName;
- (NSString *) getKeychainPasswordForUsername: (NSString *) username;
- (void) setKeychainPassword: (NSString *) password username: (NSString *) username;
@end
