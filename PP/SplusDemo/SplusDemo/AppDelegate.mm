//
//  AppDelegate.m
//  SplusDemo
//
//  Created by akzhang on 14-6-12.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "AppDelegate.h"
#import <SplusLibrary/SplusInterfaceKit.h>
#import <PPAppPlatformKit/PPAppPlatformKit.h>

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
    
    /**
     *必须写在程序window初始化之后。详情请commad + 鼠标左键 点击查看接口注释
     *初始化应用的AppId和AppKey。从开发者中心游戏列表获取（https://pay.25pp.com）
     *设置是否打印日志在控制台,[发布时请务必改为NO]
     *设置充值页面初始化金额,[必须为大于等于1的整数类型]
     *设置游戏客户端与游戏服务端链接方式是否为长连接【如果游戏服务端能主动与游戏客户端交互。例如发放道具则为长连接。此处设置影响充值并兑换的方式】
     *用户注销后是否自动push出登陆界面
     *是否开放充值页面【操作在按钮被弹窗】
     *若关闭充值响应的提示语
     *初始化SDK界面代码
     */
    NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];
    [[PPAppPlatformKit sharedInstance] setAppId:[[dictionary objectForKey:@"PartnerGameID"] intValue] AppKey:[dictionary objectForKey:@"PartnerKey"]];
    [[PPAppPlatformKit sharedInstance] setIsNSlogData:YES];
    [[PPAppPlatformKit sharedInstance] setRechargeAmount:10];
    [[PPAppPlatformKit sharedInstance] setIsLongComet:YES];
    [[PPAppPlatformKit sharedInstance] setIsLogOutPushLoginView:YES];
    [[PPAppPlatformKit sharedInstance] setIsOpenRecharge:YES];
    [[PPAppPlatformKit sharedInstance] setCloseRechargeAlertMessage:@"关闭充值提示语"];
    [[PPAppPlatformKit sharedInstance] setDelegate:[SplusInterfaceKit sharedInstance]];
    [PPUIKit setIsDeviceOrientationLandscapeLeft:YES];
    [PPUIKit setIsDeviceOrientationLandscapeRight:YES];
    [PPUIKit setIsDeviceOrientationPortrait:YES];
    [PPUIKit setIsDeviceOrientationPortraitUpsideDown:YES];
    [[PPUIKit sharedInstance] checkGameUpdate];

    return YES;
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[SplusInterfaceKit sharedInstance] splusHandleOpenUrl:url SourceApplication:sourceApplication];
    return YES;
}


//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    NSLog(@"urdsfssdfdsfdsfdsfsdfdsfsdfsdfsdfsdfsdf====================l:%@",[url debugDescription]);
////    [self parse:url application:application];
//    [[SplusInterfaceKit sharedInstance] splusOpenUrl:url];
//	return YES;
//}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    //结果处理
    [[PPAppPlatformKit sharedInstance] alixPayResult:url];
    
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
