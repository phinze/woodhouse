//
//  WoodhouseKeychain.m
//  Woodhouse
//
//  Created by Paul Hinze on 1/30/12.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import "WoodhouseKeychain.h"

NSString * const WoodhouseKeychainService = @"WoodhouseJenkinsCredentials";
#define DEFAULT_USER_KEYCHAIN NULL

@interface WoodhouseKeychain (Private)
- (UInt32) lengthInBytes: (NSString *)str;
+ (id) handleOSStatusError: (OSStatus)status;
+ (NSString *) convertRefIntoPassword:(SecKeychainItemRef)itemRef;
@end

@implementation WoodhouseKeychain

static WoodhouseKeychain *defaultKeychain = nil;

+ (void) initialize {
  if (self == [WoodhouseKeychain class]) {
    defaultKeychain = [[WoodhouseKeychain alloc] initWithService:WoodhouseKeychainService];
  }
}

+ (WoodhouseKeychain *) sharedKeychain {
  return defaultKeychain;
}

- (WoodhouseKeychain *) initWithService:(NSString *)serviceName {
  if (self = [self init]) {
    service = serviceName;
  }
  return self;
}

- (NSString *) getKeychainPasswordForUsername: (NSString *) username {
  UInt32 passwordLength;
  void *passwordBytes;
  OSStatus result;
  result = SecKeychainFindGenericPassword(DEFAULT_USER_KEYCHAIN,
                                          [self lengthInBytes:service], [service UTF8String],
                                          [self lengthInBytes:username], [username UTF8String],
                                          &passwordLength, &passwordBytes,
                                          NULL);
  if (result != noErr) { return @""; }
  NSString *password = [[NSString alloc] initWithBytes:passwordBytes length:passwordLength encoding:NSUTF8StringEncoding];
  SecKeychainItemFreeContent(NULL, passwordBytes);
  if (password == NULL) { return @""; }
  return password;
}

- (void) setKeychainPassword: (NSString *) password username: (NSString *) username { 
  SecKeychainItemRef item = NULL;
  OSStatus result = SecKeychainFindGenericPassword(NULL,
                                                   [self lengthInBytes:service], [service UTF8String],
                                                   [self lengthInBytes:username], [username UTF8String],
                                                   NULL, NULL, &item);
  if (result == noErr && item) {
    if ([password length] > 0) {
      result = SecKeychainItemModifyAttributesAndData(item, NULL, [self lengthInBytes:password], [password UTF8String]);
    } else {
      result = SecKeychainItemDelete(item);
    }
  } else if (result == errSecItemNotFound) {
    if ([password length] > 0) {
      result = SecKeychainAddGenericPassword(DEFAULT_USER_KEYCHAIN,
                                             [self lengthInBytes:service], [service UTF8String],
                                             [self lengthInBytes:username], [username UTF8String],
                                             [self lengthInBytes:password], [password UTF8String], NULL);
    }
  }
  if (result != noErr) {
    [[self class] handleOSStatusError:result];
  }
}

- (void) clearAllPasswords {
  NSDictionary *accounts = [[self class] genericPasswordsWithService:service];
  for (NSString *username in accounts) {
    [self setKeychainPassword:@"" username:username];
  }
}

- (UInt32) lengthInBytes: (NSString *) str {
  return (UInt32)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark class methods

+ (NSDictionary *)genericPasswordsWithService:(NSString *)service {
  NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                         kSecClassGenericPassword, kSecClass,         
                         kCFBooleanTrue,           kSecReturnAttributes,
                         kCFBooleanTrue,           kSecReturnRef,
                         kSecMatchLimitAll,        kSecMatchLimit,
                         service,                  kSecAttrService,
                         nil];
  CFArrayRef cfresult = NULL;
  CFDictionaryRef cfquery = (__bridge_retained CFDictionaryRef)query;
  
  OSStatus status = SecItemCopyMatching(cfquery, (CFTypeRef *)&cfresult);
  CFRelease(cfquery);

  if (status == errSecItemNotFound) { return NULL; }
  else if (status != noErr) { return [self handleOSStatusError:status]; }  
  
  NSMutableDictionary *accountsAndPasswords = [[NSMutableDictionary alloc] init];
  for (NSDictionary *item in  (__bridge_transfer NSArray *)cfresult) {
    NSString *account = [item objectForKey:kSecAttrAccount];
    NSString *password = [self convertRefIntoPassword:(__bridge SecKeychainItemRef)[item objectForKey:kSecValueRef]];
    [accountsAndPasswords setObject:password forKey:account];
  }
    return accountsAndPasswords;
}

+ (NSString *) convertRefIntoPassword:(SecKeychainItemRef) itemRef {
  void *cfpassword;
  UInt32 cfpasswordlength;
  OSStatus status = SecKeychainItemCopyAttributesAndData(itemRef, NULL, NULL, NULL, &cfpasswordlength, &cfpassword);
  if (status != noErr) { return [self handleOSStatusError:status]; }
  NSString *password = [[NSString alloc] initWithBytes:cfpassword length:cfpasswordlength encoding:NSUTF8StringEncoding];
  SecKeychainItemFreeAttributesAndData(NULL, cfpassword);
  return password;
}

+ (id) handleOSStatusError: (OSStatus) status {
  NSLog(@"status: %s", GetMacOSStatusErrorString(status));
  NSLog(@"status comment: %s", GetMacOSStatusCommentString(status));
  NSLog(@"security status: %@", SecCopyErrorMessageString(status, NULL));
  NSLog(@"%@",[NSThread callStackSymbols]);
  return NULL;
}
@end
