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

//激活成功
-(void)SplusActivateOnSuccess;

//登录成功
-(void)SplusLoginOnSuccess:(SplusUser*)callbackUser;

//支付成功回调
-(void)SplusPayOnResult:(id)sender;

//注销回调
-(void)SplusLogOutOnSuccess;

//关闭充值界面
-(void)SplusLeavedWebPay:(id)sender;

//关闭登录或者注册界面
-(void)SplusLeavedWebManage:(id)sender;

//从个人中心离开
-(void)SplusLeavedAcount;

@end
