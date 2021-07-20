//
//  CBBmob.m
//  CardBin
//
//  Created by 赵勇 on 12/11/16.
//  Copyright © 2016 CB. All rights reserved.
//

#import "CBBmob.h"
#import <BmobSDK/Bmob.h>
#import <SFHFKeychainUtils/SFHFKeychainUtils.h>

static CBBmob *bmobinstance = nil;

@interface CBBmob ()

@property (nonatomic, copy) void(^callback)(BOOL success);

@end

@implementation CBBmob

+ (void)setUp:(void (^)(BOOL))completion {
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		bmobinstance = [[CBBmob alloc] init];
		bmobinstance.callback = completion;
	});
}

+ (int)restNumebr {
	BmobUser *user = BmobUser.currentUser;
	if (user) {
		return [[user objectForKey:@"query_number"] intValue];
	} else {
		return -1;
	}
}

+ (void)addQueryNumber:(int)number completion:(void(^)(BOOL isSuccessful, NSError *error))completion {
	BmobUser *user = BmobUser.currentUser;
	if (user) {
		int rest = [[user objectForKey:@"query_number"] intValue];
		[user setObject:@(rest + number) forKey:@"query_number"];
		[user updateInBackgroundWithResultBlock:completion];
	} else {
		if (completion) completion(NO, [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : @"用户不存在"}]);
	}
}

+ (void)use:(int)number completion:(void(^)(BOOL isSuccessful, NSError *error))completion {
	BmobUser *user = BmobUser.currentUser;
	if (user) {
		int rest = [[user objectForKey:@"query_number"] intValue];
		if (rest - number < 0) {
			if (completion) completion(NO, [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : @"查询次数不足"}]);
		} else {
			rest -= number;
			[user setObject:@(rest) forKey:@"query_number"];
			[user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
				completion(isSuccessful, error);
			}];
		}
	} else {
		if (completion) completion(NO, [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : @"用户不存在"}]);
	}
}

- (instancetype)init {
	self = [super init];
	if (self) {
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(success) name:kBmobInitSuccessNotification object:nil];
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(fail:) name:kBmobInitFailNotification object:nil];
	}
	return self;
}

- (void)success {
	[self fetchUser];
}

- (void)fail:(NSNotification *)noti {
	if (self.callback) self.callback(NO);
}

- (void)fetchUser {
	NSString *idfv = [self getUUID];
	NSString *pwd = @"dsadaj#sdadjh1636";
	[BmobUser loginWithUsernameInBackground:idfv password:pwd block:^(BmobUser *user, NSError *error) {
		if (error) {
			NSLog(@"Sign in failed, error: %@", error);
			if (error.code == 101) {
				[self signUp];
			} else {
				if (self.callback) self.callback(NO);
			}
		} else {
			NSLog(@"Sign in successfully");
			if (self.callback) self.callback(YES);
		}
	}];
}

- (void)signUp {
	NSString *idfv = [self getUUID];
	NSString *pwd = @"dsadaj#sdadjh1636";
	BmobUser *bUser = [[BmobUser alloc] init];
	[bUser setUsername:idfv];
	[bUser setPassword:pwd];
	[bUser setObject:@10 forKey:@"query_number"];
	[bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
		if (isSuccessful){
			NSLog(@"Sign up successfully");
			[BmobUser loginWithUsernameInBackground:idfv password:pwd block:^(BmobUser *user, NSError *error) {
				if (error) {
					NSLog(@"%@", error);
					if (self.callback) self.callback(NO);
				} else {
					NSLog(@"Sign in successfully");
					if (self.callback) self.callback(YES);
				}
			}];
		} else {
			NSLog(@"%@",error);
			if (self.callback) self.callback(NO);
		}
	}];
}

#pragma mark - UUID、Keychain

- (NSString *)getUUID {
    NSString *bundleId = NSBundle.mainBundle.bundleIdentifier;
  NSString *userName = [bundleId stringByAppendingString:@".UserName"];
  NSString *serviceName = [bundleId stringByAppendingString:@".UUID"]; //本条keychains所属的服务(组)
  NSError *error;
  NSString *uuid = [SFHFKeychainUtils getPasswordForUsername:userName andServiceName:serviceName error:&error];
  if (uuid.length == 0) {
    uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    BOOL saved = [SFHFKeychainUtils
                  storeUsername:userName
                  andPassword:uuid
                  forServiceName:serviceName
                  updateExisting:YES
                  error:&error];
    if (!saved) {
      NSLog(@"Keychain保存密码时出错：%@", error);
      return nil;
    }
  }
  return uuid;
}

@end
