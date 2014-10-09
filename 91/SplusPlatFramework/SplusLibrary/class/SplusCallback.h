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

-(void)SplusActivateOnSuccess;

-(void)SplusLoginOnSuccess:(SplusUser*)callbackUser;

-(void)SplusAcountOnSuccess;

-(void)SplusLogOutOnSuccess;

//从个人中心离开
-(void)SplusLeavedAcount;

//从登录页面离开
-(void)SplusLeavedLogin;

//从支付界面离开
-(void)SplusLeavedPay:(id)sender;

//暂停页面
-(void)SplusPagePause;

@end
