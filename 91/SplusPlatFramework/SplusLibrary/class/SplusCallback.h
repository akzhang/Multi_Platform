//
//  SplusCallback.h
//  SplusMutiPlat
//
//  Created by akzhang on 14-7-22.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SplusUser.h"

@protocol SplusCallback <NSObject>

//激活回调
-(void)SplusActivateOnSuccess;

//登录成功回调
-(void)SplusLoginOnSuccess:(SplusUser*)callbackUser;

//注销回调
-(void)SplusLogOutOnSuccess;

//从个人中心离开
-(void)SplusLeavedAcount;

//从支付界面离开
-(void)SplusLeavedPay:(id)sender;

//暂停页面
-(void)SplusPagePause;

@end
