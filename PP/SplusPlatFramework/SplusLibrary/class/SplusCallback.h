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
-(void)SplusPayOnSuccess:(id)sender;

//支付失败回调
-(void)SplusPayOnFailure;

//注销回调
-(void)SplusLogOutOnSuccess;

//从登录页面离开
-(void)SplusLeavedLogin:(id)sender;

//从web页面离开
-(void)SplusLeavedWeb:(id)sender;

@end
