//
//  AppDelegate.m
//  CardBin
//
//  Created by 赵勇 on 12/28/15.
//  Copyright © 2015 CB. All rights reserved.
//

#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
#import "CBQueryViewController.h"
@import Pendo;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([[url scheme] containsString:@"pendo"]) {
        [[PendoManager sharedManager] initWithUrl:url];
        return YES;
    }
    //  your code here ...
    return YES;
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts  API_AVAILABLE(ios(13.0)){
    NSURL * url = URLContexts.allObjects[0].URL;
    if ([[url scheme] containsString:@"pendo"]) {
        [[PendoManager sharedManager] initWithUrl:url];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	NSLog(@"%@", docPath);
    
    [Bmob registerWithAppKey:@"8aa465059133e2d2d2229d2278ec8c8d"];
	
	[[UINavigationBar appearance] setTintColor:UIColor.blackColor];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor}];
		
	CBQueryViewController *vc = [[CBQueryViewController alloc] init];
	UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:vc];
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.backgroundColor = UIColor.whiteColor;
	self.window.rootViewController = root;
	[self.window makeKeyAndVisible];
    
    PendoInitParams *initParams = [[PendoInitParams alloc] init];
    [initParams setVisitorId:@"Ying Zhou"];
    [initParams setVisitorData:@{@"Age":@38, @"Country":@"China", @"Gender":@"Male"}];
    [initParams setAccountId:@"ACME"];
    [initParams setAccountData:@{@"Tier":@1, @"Timezone":@"CST", @"Size":@"Enterprise"}];

    NSString * appKey = @"eyJhbGciOiJSUzI1NiIsImtpZCI6IiIsInR5cCI6IkpXVCJ9.eyJkYXRhY2VudGVyIjoidXMiLCJrZXkiOiI4MzZmOGJiMTM0ODI4ZjIzMTE4MzdkNTIzOTZjOTUwMWZiZGE4ZGIyMWEwMDAwODNkZmRiMDg2MTAyZDZhMGZkODRmMDYwZDU5OGMxYTc5ZTI0OTE3NjU3MDU1YjU3OWRkZjgzMDZlYzBkMDYwOWIxMTY5Mzg4ODkyNTMyOGY4Zi45ODVhOTQ5ZTBiMGE4NzA3ZmUyMzQ3YTY5N2YyMmNlOS5jN2QxYjA3NWQyM2U2MDY0ZDZhZDY4MTJiNzNiZjIzMGVkZmY1MjhkODdlOGIxNGYzOWU0MzhjYjJlMzFiY2I1In0.b1O22zjGsXzy1n13Mb_a0THj42yzQjixEF9bgR44TeXTi0qUfq8mUO5szwHQeg1-KrIdRT7737qwcB9lSPZTjnHjSh7-De2xxnJdGNs6hseJgC8vr1Vf1hPcS-E48imdRb-TPsEH_v3V3HKvK7QLS8dByXsnbvrkOOInHuZwd98";
    [[PendoManager sharedManager] initSDK: appKey
                                  initParams: initParams];
	
	return YES;
}


//@implementation AppDelegate

//
//
//- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
//{
//
//
//
//    self.viewController = [[MainViewController alloc] init];
//    return [super application:application didFinishLaunchingWithOptions:launchOptions];
//}


@end
