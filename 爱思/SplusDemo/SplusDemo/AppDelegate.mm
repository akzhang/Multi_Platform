//
//  AppDelegate.m
//  SplusDemo
//
//  Created by akzhang on 14-6-12.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "AppDelegate.h"
#import "AsInfoKit.h"
#include "AsPlatformSDK.h"
#include <SplusLibrary/SplusInterfaceKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    DemoTest *firstDemo =[[DemoTest alloc] init];
    self.window.rootViewController = firstDemo;
    [self.window makeKeyAndVisible];
    
    NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];
    [[AsInfoKit sharedInstance] setAppId:[[dictionary objectForKey:@"PartnerGameID"] intValue]];
    [[AsInfoKit sharedInstance] setAppKey:[dictionary objectForKey:@"PartnerKey"]];
    [[AsInfoKit sharedInstance] setLogData:YES];
    [[AsInfoKit sharedInstance] setCloseRecharge:NO];
    [[AsInfoKit sharedInstance] setCloseRechargeAlertMessage:@"充值功能暂时不开放"];
    /* @noti  只有余额大于道具金额时候才有客户端回调。余额不足的情况取决与LongComet参数，LongComet = YES，则为充值兑换,
     回调给服务端，LongComet = NO ，则只是打开充值界面
     */
    [[AsInfoKit sharedInstance] setLongComet:YES];
    /*
     解决游戏在iOS 5 上 无法显示爱思充值/支付页面、银联支付页面
     若游戏有根视图控制器（RootViewController），则设置为 self.asViewController(为自己的根视图控制器名称)
     若无根视图控制器，则设置为 nil
     */
//    [[AsInfoKit sharedInstance] setRootViewController:firstDemo];
    
    [[AsPlatformSDK sharedInstance] checkGameUpdate];

    return YES;
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[SplusInterfaceKit sharedInstance] splusHandleOpenUrl:url SourceApplication:sourceApplication];
//    if ([sourceApplication isEqualToString:@"com.alipay.iphoneclient"])
//    {
//        [[AsInfoKit sharedInstance] alixPayResult:url];
//    }
//    else if ([sourceApplication isEqualToString:@"com.alipay.safepayclient"])
//    {
//        [[AsInfoKit sharedInstance] alixPayResult:url];
//    }
//    else if ([sourceApplication isEqualToString:@"com.tencent.xin"])
//    {
//        [[AsInfoKit sharedInstance] weChatPayResult:url];
//    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
