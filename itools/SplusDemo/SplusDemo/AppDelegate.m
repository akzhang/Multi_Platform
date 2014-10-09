//
//  AppDelegate.m
//  SplusDemo
//
//  Created by akzhang on 14-6-12.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "AppDelegate.h"
#import "HXAppPlatformKitPro.h"
#import <SplusIosSdk/SplusInterfaceKit.h>

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

    //设置充值平台分配的appid和appkey
    [HXAppPlatformKitPro setAppId:1 appKey:@"58C6A68DDDEE471AA43266E427F38D92"];
    //设置支持的旋转方向
    [HXAppPlatformKitPro setSupportOrientationPortrait:YES portraitUpsideDown:NO landscapeLeft:YES landscapeRight:YES];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[SplusInterfaceKit sharedInstance] alixPayResult:url];
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
