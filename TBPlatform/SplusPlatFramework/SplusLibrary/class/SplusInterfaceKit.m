//
//  SplusInterfaceKit.m
//  SplusMutiPlat
//
//  Created by akzhang on 14-7-22.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "SplusInterfaceKit.h"
#import "AppInfo.h"
#import "OrderInfo.h"
#import "Activate.h"
#import "MyMD5.h"
#import "SplusUser.h"
#import "NSDictionary+QueryBuilder.h"
#import <TBPlatform/TBPlatform.h>

@implementation SplusInterfaceKit

__strong static SplusInterfaceKit *singleton = nil;


/**
 *  API单例
 *
 *  @return 返回单例
 */
+(SplusInterfaceKit*)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        //singleton = [[self alloc] init];
        singleton = [[super allocWithZone:NULL] init];
    });
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

/**
 *  设置委托
 *
 *  @param argDelegate 委托
 */
-(void)setDelegate:(id<SplusCallback>)argDelegate
{
    _delegate = argDelegate;
}

/**
 *  CP商渠道号，游戏ID，游戏ID，渠道号从Splus后台获取
 *
 *  @param AppId       游戏ID
 *  @param argSourceId 渠道ID
 *  @param argGameKey 游戏key
 */
-(void) setApp:(NSString*)AppId GameKey:(NSString*)argGameKey SourceID:(NSString*)argSourceId PartnerID:(NSString*)partnerID PartnerKey:(NSString*)partnerKey
{
    [AppInfo sharedSingleton].gameID = AppId;
    [AppInfo sharedSingleton].gameKey = argGameKey;
    [AppInfo sharedSingleton].sourceID = argSourceId;
    [AppInfo sharedSingleton].partnerGameID = partnerID;
    [AppInfo sharedSingleton].partnerKey = partnerKey;
}

/**
 *  初始化玩家信息
 *
 *  @param serverid    服务id
 *  @param serverName  服务器名字
 *  @param roleld      游戏ID
 *  @param roleName    游戏名字
 *  @param mOutOrderid 外部订单号
 *  @param mPext       附加信息
 */
-(void)setPlayerInfo:(NSString*)serverid serverName:(NSString*)serverName RoleId:(NSString*)roleld RoleName:(NSString*)roleName OutOrderId:(NSString*)mOutOrderid Pext:(NSString*)mPext
{

}

/**
 *  激活接口
 */
-(void)activate
{
    Activate *active = [[Activate alloc] init];
    active.delegate = _delegate;//设置委托
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootViewController presentViewController:active animated:NO completion:nil];
}

/**
 *  初始化
 */
-(void)initSplus
{
    //添加SDK各类通知的观察者
    /*初始化结束通知，登录等操作务必在收到该通知后调用！！*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sdkInitFinished)
                                                 name:kTBInitDidFinishNotification
                                               object:Nil];
    /*登录成功通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginFinished)
                                                 name:kTBLoginNotification
                                               object:nil];
    /*注销通知（个人中心页面的注销也会触发该通知，注意处理*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogout)
                                                 name:kTBUserLogoutNotification
                                               object:nil];
    /*离开平台通知（包括登录页面、个人中心页面、web充值页等*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leavedSDKPlatform:)
                                                 name:kTBLeavePlatformNotification
                                               object:nil];
}

/**
 *  设置SDK屏幕的方向
 *
 *  @param orientation UIInterfaceOrientation
 */
-(void)splusScreenOrientation:(UIInterfaceOrientation)orientation
{
    //SDK初始化，务必放在其他SDK接口的调用之前
    [[TBPlatform defaultPlatform] TBInitPlatformWithAppID:[[AppInfo sharedSingleton].partnerGameID intValue]
                                        screenOrientation:orientation//UIInterfaceOrientationLandscapeLeft
                          isContinueWhenCheckUpdateFailed:NO];
}

/**
 *  登录接口
 *
 *  @param context context
 */
-(void)splusLogin
{
    [[TBPlatform defaultPlatform] TBLogin:0];
}

/**
 *  个人中心
 */
-(void)splusAcountManage
{
    [[TBPlatform defaultPlatform] TBEnterUserCenter:0];
}

-(void)splusHideToolBar:(BOOL)hide
{
    if (hide == YES) {
        [[TBPlatform defaultPlatform] TBHideToolBar];
    }
    else
    {
        //显示浮动工具条
        [[TBPlatform defaultPlatform] TBShowToolBar:TBToolBarAtMiddleLeft
                                      isUseOldPlace:YES];
    }
}

/**
 *  不定额充值
 */
-(void)splusPay:(NSString*)type serverID:(NSString*)serverid serverName:(NSString*)serverName RoleId:(NSString*)roleld RoleName:(NSString*)roleName OutOrderId:(NSString*)mOutOrderid Pext:(NSString*)mPext
{
    [OrderInfo sharedSingleton].serverId = serverid;
    [OrderInfo sharedSingleton].serverName = serverName;
    [OrderInfo sharedSingleton].roleId = roleld;
    [OrderInfo sharedSingleton].roleName = roleName;
    [OrderInfo sharedSingleton].outOrderid = mOutOrderid;
    [OrderInfo sharedSingleton].pext = mPext;
    [OrderInfo sharedSingleton].type = @"0";
    [OrderInfo sharedSingleton].money = @"0";
    [self paySplusCallback];
}

/**
 *  定额支付
 *  @param money      充值金额
 */
-(void)splusQuotaPay:(NSString*)money Type:(NSString*)mType serverID:(NSString*)serverid serverName:(NSString*)serverName RoleId:(NSString*)roleld RoleName:(NSString*)roleName OutOrderId:(NSString*)mOutOrderid Pext:(NSString*)mPext
{
    [OrderInfo sharedSingleton].serverId = serverid;
    [OrderInfo sharedSingleton].serverName = serverName;
    [OrderInfo sharedSingleton].roleId = roleld;
    [OrderInfo sharedSingleton].roleName = roleName;
    [OrderInfo sharedSingleton].outOrderid = mOutOrderid;
    [OrderInfo sharedSingleton].pext = mPext;
    [OrderInfo sharedSingleton].money = money;
    [OrderInfo sharedSingleton].type = mType;
    [self paySplusCallback];
}



#pragma mark - 消息回调处理
/**
 *  SDK初始化结束通知（登录等操作务必放到初始化完成的通知里！！！！）
 */
- (void)sdkInitFinished{
    [[TBPlatform defaultPlatform] TBLogin:0];
}

/**
 *  离开平台
 *
 *  @param notification
 */
- (void)leavedSDKPlatform:(NSNotification *)notification{
    NSDictionary *notifyUserInfo = notification.userInfo;
    TBPlatformLeavedType leavedFromType = (TBPlatformLeavedType)[[notifyUserInfo objectForKey:
                                                                  TBLeavedPlatformTypeKey] intValue];
    switch (leavedFromType) {
            //从登录页离开
        case TBPlatformLeavedFromLogin:{
            [_delegate SplusLeavedAcount];
        }
            break;
            //从个人中心离开
        case TBPlatformLeavedFromUserCenter:{
            [_delegate SplusLeavedAcount];
        }
            break;
            //从充值页面离开
        case TBPlatformLeavedFromUserPay:{
            NSString *orderString = [notifyUserInfo objectForKey:TBLeavedPlatformOrderKey];
            [[TBPlatform defaultPlatform] TBCheckPaySuccess:orderString
                                                   delegate:self];
            _payResultCode = @"2";
            [_delegate SplusLeavedPay:_payResultCode];
        }
            break;
        default:
            break;
    }
}

/**
 *  登录结束通知
 */
- (void)loginFinished{
    if ([[TBPlatform defaultPlatform] TBIsLogined]) {
        TBPlatformUserInfo *userInfo = [[TBPlatform defaultPlatform] TBGetMyInfo];

        //显示浮动工具条
        [[TBPlatform defaultPlatform] TBShowToolBar:TBToolBarAtMiddleLeft
                                      isUseOldPlace:YES];
        
        [self loginSplusCallback:userInfo];
    }
}


/**
 *  请求Splus登录
 *
 *  @param userInfo 用户信息
 */
-(void)loginSplusCallback:(TBPlatformUserInfo*)tbUserInfo
{
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].delegate.window.rootViewController.view];
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:_HUD];
    _HUD.color = [UIColor clearColor];
    [_HUD show: YES];

    // 登录请求
    NSDictionary *dictionaryBundle = [[NSBundle mainBundle] infoDictionary];
    NSString *partner = [dictionaryBundle objectForKey:@"Partner"];
    NSString *sign = @"";
    NSString *deviceNo = [ActivateInfo sharedSingleton].deviceno;
    NSString *gameID = [AppInfo sharedSingleton].gameID;
    NSString *sourceID = [AppInfo sharedSingleton].sourceID;
    NSString *gameKey = [AppInfo sharedSingleton].gameKey;
    
    NSString *mTime = [[AppInfo sharedSingleton] getData];
    NSLog(@"deviceno = %@", [ActivateInfo sharedSingleton].deviceno);
    sign = [sign stringByAppendingFormat:@"%@%@%@%@%@%@", deviceNo, gameID, partner, sourceID, mTime, gameKey];
    
    NSLog(@"Md5 sign = %@", [MyMD5 md5:sign]);
    
    NSString *sessionID = tbUserInfo.sessionID;
    NSString *nickName = tbUserInfo.nickName;
    NSString *userID = tbUserInfo.userID;
    NSLog(@"sessionID =%@", sessionID);
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:gameID, @"gameid",
                                deviceNo, @"deviceno",
                                sourceID,@"referer",
                                partner, @"partner",
                                sessionID, @"partner_sessionid",
                                userID, @"partner_uid",
                                @"", @"partner_token",
                                nickName, @"partner_nickname",
                                @"", @"partner_username",
                                sourceID, @"partner_appid",
                                mTime, @"time",
                                @"1",@"debug",
                                [MyMD5 md5:sign], @"sign",nil];
    
    NSString *postData = [dictionary buildQueryString];
    NSLog(@"postData = %@", postData);
    
    httpRequest *_request = [[httpRequest alloc] init];
    _request.dlegate = self;
    _request.success = @selector(logion_callback:);
    _request.error = @selector(login_error);
    
    NSString *var = [MLOGIN_URL stringByAppendingFormat:@"%@%@", @"?", postData];
    NSLog(@"login = %@", var);
    
    [_request post:MLOGIN_URL argData:postData];
    
}

-(void)logion_callback:(NSString*)result
{
    
    if (_HUD != NULL) {
        [_HUD hide:YES];
    }

    NSLog(@"login info result = %@", result);//登录信息
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDic = [parser objectWithString:result];
    NSString *code = [rootDic objectForKey:@"code"];
    if ([code intValue] == 1) {
        NSDictionary *data = [rootDic objectForKey:@"data"];
        NSString *sessionID = [data objectForKey:@"sessionID"];
        NSString *userID = [data objectForKey:@"uid"];
        [SplusUser sharedSingleton].uid = userID;
        [SplusUser sharedSingleton].sessionID = sessionID;
        //登录成功，callback
        [_delegate SplusLoginOnSuccess:[SplusUser sharedSingleton]];
    }
    else
    {
        NSString *msg = [rootDic objectForKey:@"msg"];
        [self showMessage:msg];
        
        return;
    }
}

-(void)login_error{
    
    if (_HUD != NULL) {
        [_HUD hide:YES];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}



/**
 *  注销通知
 */
- (void)didLogout{
    //    [self quickShowMessage:@"已注销"];
    [[TBPlatform defaultPlatform] TBHideToolBar];
    [_delegate SplusLogOutOnSuccess];//注销回调
}

-(void)paySplusCallback
{
    // 支付请求
    NSDictionary *dictionaryBundle = [[NSBundle mainBundle] infoDictionary];
    NSString *partner = [dictionaryBundle objectForKey:@"Partner"];
    NSString *sign = @"";
    NSString *mTime = [[AppInfo sharedSingleton] getData];
    NSString *payWay = @"";
    NSString *deviceNo = [ActivateInfo sharedSingleton].deviceno;
    NSString *gameID = [AppInfo sharedSingleton].gameID;
    NSString *sourceID = [AppInfo sharedSingleton].sourceID;
    NSString *gameKey = [AppInfo sharedSingleton].gameKey;
    NSString *uid = [SplusUser sharedSingleton].uid;
    NSString *money = [OrderInfo sharedSingleton].money;
    NSString *acount = [SplusUser sharedSingleton].username;
    NSString *serverName = [OrderInfo sharedSingleton].serverName;
    NSString *roleName = [OrderInfo sharedSingleton].roleName;
    NSString *roleId = [OrderInfo sharedSingleton].roleId;
    NSString *serverId = [OrderInfo sharedSingleton].serverId;
    
    if ([partner length] == 0) {
        [self showMessage:@"渠道号不能为空"];
        return;
    }
    
    if ([deviceNo length] == 0) {
        [self showMessage:@"设备号获取异常"];
        return;
    }
    
    if ([uid length] == 0) {
        [self showMessage:@"uid不能为空"];
        return;
    }
    
    if ([mTime length] == 0) {
        [self showMessage:@"时间戳不能为空"];
        return;
    }
    
    if ([[OrderInfo sharedSingleton].type length] == 0) {
        [self showMessage:@"时间戳不能为空"];
        return;
    }

    
    sign = [sign stringByAppendingFormat:@"%@%@%@%@%@%@%@", gameID, deviceNo , partner, uid, money, mTime, gameKey];
    NSLog(@"sign = %@", sign);
    
    NSLog(@"Md5 sign = %@", [MyMD5 md5:sign]);
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:gameID, @"gameid",
                                deviceNo, @"deviceno",
                                sourceID,@"referer",
                                partner, @"partner",
                                uid, @"uid",
                                @"", @"account",//用户名
                                serverName, @"serverName",//游戏服名
                                roleName, @"roleName",//充值角色
                                roleId, @"roleId",//充值角色id
                                serverId, @"serverId",//游戏服名id
                                money, @"money",
                                [OrderInfo sharedSingleton].type, @"type",//充值方式0 非定额 1 定额
                                payWay, @"payway",
                                mTime, @"time",
                                [MyMD5 md5:sign], @"sign",
                                @"1",@"debug",
                                [OrderInfo sharedSingleton].outOrderid ,@"outOrderid",
                                [OrderInfo sharedSingleton].pext, @"pext",nil];
    
    NSString *postData = [dictionary buildQueryString];
    
    NSLog(@"postData = %@", postData);
    
    NSString *var = [MPAY_URL stringByAppendingFormat:@"%@%@", @"?", postData];
    NSLog(@"pay = %@", var);
    
    httpRequest *_request = [[httpRequest alloc] init];
    _request.dlegate = self;
    _request.success = @selector(pay_callback:);
    _request.error = @selector(pay_error);
    [_request post:MPAY_URL argData:postData];

}

-(void)pay_callback:(NSString*)result
{
    NSLog(@"result = %@", result);
    NSLog(@"login info result = %@", result);//登录信息
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDic = [parser objectWithString:result];
    NSString *codeNum = [rootDic objectForKey:@"code"];
    if ([codeNum intValue] == 1)
    {
        NSString *orderid = [rootDic objectForKey:@"orderid"];
        
        if ([[OrderInfo sharedSingleton].type intValue] == 1) {
            //固定金额的购买
            [[TBPlatform defaultPlatform] TBUniPayForCoin:orderid
                                               needPayRMB:[[OrderInfo sharedSingleton].money intValue]
                                           payDescription:@"支付描述会在支付回调中原封不动发回"
                                                 delegate:self];
        }else
        {
            //玩家自选金额兑换
            [[TBPlatform defaultPlatform] TBUniPayForCoin:orderid
                                           payDescription:@"支付描述会在支付回调中原封不动发回"];
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"参数错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)pay_error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)showMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

//支付宝
- (void)alixPayResult:(NSURL *)paramURL{
    NSLog(@"alipay back %@", paramURL);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finish" object:@"0"];
};

#pragma mark - 购买物品回调

/**
 *	@brief	使用推币直接购买商品成功
 *
 *	@param 	order 	订单号
 */
- (void)TBBuyGoodsDidSuccessWithOrder:(NSString*)order{
    
    NSLog(@"支付成功。。。。。。");
    _payResultCode = @"0";
    [_delegate SplusLeavedPay:_payResultCode];
}

/**
 *	@brief	使用推币直接购买商品失败
 *
 *	@param 	order 	订单号
 *	@param 	errorType  错误类型，见TB_BUYGOODS_ERROR
 */
- (void)TBBuyGoodsDidFailedWithOrder:(NSString *)order
                          resultCode:(TB_BUYGOODS_ERROR)errorType{
     _payResultCode = @"1";
    [_delegate SplusLeavedPay:_payResultCode];
}

/**
 *	@brief	推币余额不足，进入充值页面（开发者需要手动查询订单以获取充值购买结果）
 *
 *	@param 	order 	订单号
 */
- (void)TBBuyGoodsDidStartRechargeWithOrder:(NSString*)order{
    
}

/**
 *	@brief  跳提示框时，用户取消
 *
 *	@param	order	订单号
 */
- (void)TBBuyGoodsDidCancelByUser:(NSString *)order{
    
}

#pragma mark - 查询订单回调

/**
 *  查询订单结束
 *
 *  @param orderString 订单号
 *  @param amount      订单金额（单位：分）
 *  @param statusType  订单状态（详见TBPlatformDefines.h）
 */
- (void)TBCheckOrderFinishedWithOrder:(NSString *)orderString
                               amount:(int)amount
                               status:(TBCheckOrderStatusType)statusType{
//    [self quickShowMessage:[NSString stringWithFormat:@"订单号:%@\n金额:%d\n状态:%d",
//                            orderString,amount,statusType]
//                     title:@"查询成功"];
    
    NSLog(@"statusType = %d", statusType);
    
    if (statusType == TBCheckOrderStatusSuccess) {
        _payResultCode = @"0";
    }
    else if(statusType == TBCheckOrderStatusFailed)
    {
        _payResultCode = @"1";
    }
    else if(statusType == TBCheckOrderStatusPaying)
    {
        _payResultCode = @"1";
    }
    else if(statusType == TBCheckOrderStatusWaitingForPay)
    {
        _payResultCode = @"1";
    }
    
}
/**
 *  @brief 查询订单失败（网络不通畅，或服务器返回错误）
 */
- (void)TBCheckOrderDidFailed:(NSString*)order{

}

@end
