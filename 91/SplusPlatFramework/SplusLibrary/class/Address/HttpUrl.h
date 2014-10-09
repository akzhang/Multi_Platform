//
//  HttpUrl.h
//  SplusIosSdk
//
//  Created by akzhang on 14-6-16.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#ifndef SplusIosSdk_HttpUrl_h
#define SplusIosSdk_HttpUrl_h

//获取屏幕分辨率
#define SCREENHEIGHT [GetImage screenSize].height
#define SCREENWIDTH [GetImage screenSize].width

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//激活URL
static const NSString *API_URL_ACTIVATE = @"http://api.splusgame.com/sdk/active.php";
static const NSString *API_URL_LOGIN = @"http://api.splusgame.com/sdk/login.php";
static const NSString *API_URL_REGISTER = @"http://api.splusgame.com/sdk/reg.php";
static const NSString *API_URL_COIN = @"http://api.splusgame.com/sdk/pay_way_ratio.php";

//支付宝快捷支付
static const  NSString *ALIPAY_FAST_PAYWAY = @"alipay_fast";

//支付宝网页
static const  NSString *ALIPAY_WAP_PAYWAY = @"alipay_way";

//银联
static const  NSString *ALIPAY_DEPOSIT_PAYWAY = @"alipay_deposit";

//信用卡
static const  NSString *ALIPAY_CREDIT_PAYWAY = @"alipay_credit";

//银联
static const  NSString *UNION_PAYWAY = @"union_pay";

//神州行
static const  NSString *CHAIN_CMM_PAYWAY = @"szx";

//联通
static const  NSString *CHAIN_UNC_PAYWAY = @"unicom";

//盛大
static const  NSString *CHAIN_SD_PAYWAY = @"sndacard";

//人工
static const  NSString *PERSON_PAYWAY = @"";

//支付URL
static const NSString *PAY_URL = @"http://api.splusgame.com/pay/";

//支付
static const NSString *HTMLWAPPAY_URL = @"http://sy.api.37wan.cn/htmlWapPay_test/payIndex.php";

//http://api.splusgame.com/changepasswd.php

//修改密码
static const NSString *MODIFY_PWD = @"http://api.splusgame.com/sdk/changepasswd.php";

//web支付
//支付URL
static const NSString *PAY_URL_WEB = @"http://api.splusgame.com/sdk/payIndex.php";

//获取验证码
static const NSString *GET_IDENT = @"http://sy.api.37wan.cn/action/bindmobile.php";

//校验绑定手机
static const NSString *BIND_PHONE = @"http://sy.api.37wan.cn/action/bindmobile.php";

//public static final String SQPAGE_URL = "http://api.splusgame.com/dest/feedback.php";
//
//public static final String FORUMPAGE_URL = "http://bbs.splusgame.com";
//
//public static final String ANNOUNCEMENTSPAGE_URL = "http://api.splusgame.com/dest/activity.php";

//客服中心
static const NSString *QPAGE_URL = @"http://api.splusgame.com/dest/feedback.php";

//论坛
static const NSString *FORUMPAGE_URL = @"http://bbs.splusgame.com";

//活动
static const NSString *ANNOUNCEMENTSPAGE_URL = @"http://api.splusgame.com/dest/activity.php";

//获取用户信息
static const NSString *GET_USER_INFO = @"http://api.splusgame.com/sdk/userInfo.php";


//修改用户信息
static const NSString *MODIFY_USER_INOF = @"http://api.splusgame.com/sdk/userInfo.php";

//修改用户信息
static const NSString *MLOGIN_URL = @"http://api.splusgame.com/sdk/login.php";

static const NSString *MACTIVE_URL = @"http://api.splusgame.com/sdk/active.php";

static const NSString *MPAY_URL = @"http://api.splusgame.com/sdk/payIndex.php";

NSString *tipValue;

#endif
