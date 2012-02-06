//
//  WoodhouseKeychainTests.m
//  Woodhouse
//
//  Created by Paul Hinze on 2/1/12.
//  Copyright (c) 2012 Braintree. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Cocoa/Cocoa.h>
#import "WoodhouseKeychain.h"

@interface WoodhouseKeychain (TestMethods)
- (void) clearAllPasswords;
@end

@interface WoodhouseKeychainTests : SenTestCase {
  WoodhouseKeychain *keychain;
}

- (NSString *)uniqueUsername;
@end

@implementation WoodhouseKeychainTests

- (void)setUp {
  keychain = [[WoodhouseKeychain alloc] initWithService:@"WoodhouseTests"];
}

- (void)testSettingAndGetting {
  NSString *username = [self uniqueUsername];
  [keychain setKeychainPassword:@"testpassword1" username:username];
  NSString *storedPassword = [keychain getKeychainPasswordForUsername:username];
  STAssertEqualObjects(storedPassword, @"testpassword1", @"retrieved password should match stored one");
}

- (void)testSettingUpdatingAndGetting {
  NSString *username = [self uniqueUsername];
  [keychain setKeychainPassword:@"testpasswordoriginal" username:username];
  [keychain setKeychainPassword:@"testpasswordupdated" username:username];
  NSString *storedPassword = [keychain getKeychainPasswordForUsername:username];
  STAssertEqualObjects(storedPassword, @"testpasswordupdated", @"retrieved password should match updated one");
}

- (void)testListingKeychainItems {
  NSMutableDictionary *expectedOutput = [[NSMutableDictionary alloc] init];
  int listSize = 10;
  NSString *username;
  for (int i = 0; i < listSize; i++) {
    username = [self uniqueUsername];
    [keychain setKeychainPassword:@"testlistingkeychainitem" username:username];
    [expectedOutput setObject:@"testlistingkeychainitem" forKey:username];
  }
  NSDictionary *output = [WoodhouseKeychain genericPasswordsWithService:@"WoodhouseTests"];
  STAssertEqualObjects(output, expectedOutput, @"passwords should match");
}

- (void)testClearAllPasswords {
  NSString *firstUsername = [self uniqueUsername];
  NSString *secondUsername = [self uniqueUsername];
  [keychain setKeychainPassword:@"firstpassword" username:firstUsername];
  [keychain setKeychainPassword:@"secondpassword" username:secondUsername];
  [keychain clearAllPasswords];
  NSDictionary *accounts = [WoodhouseKeychain genericPasswordsWithService:@"WoodhouseTests"];
  STAssertTrue([accounts count] == 0, @"should have all passwords removed");
}

- (void)tearDown {
  [keychain clearAllPasswords];
}

- (NSString *)uniqueUsername {
  return [NSString stringWithFormat:@"user%.0f", [[NSDate date] timeIntervalSince1970] * 1000.0];
}
@end
