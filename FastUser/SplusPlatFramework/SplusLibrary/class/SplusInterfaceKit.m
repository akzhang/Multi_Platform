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
#import <AlipaySDK/AlipaySDK.h>
#import "KYSDK.h"
#import "KYMobilePay.h"


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
    [[KYSDK instance]setSdkdelegate:self];
}

/**
 *  登录接口
 *
 *  @param context context
 */
-(void)splusLogin
{
    [[KYSDK instance] logWithLastUser];
}

/**
 *  注销接口
 *
 *  @return <#return value description#>
 */
-(void)splusLoginOut
{
    [[KYSDK instance] userLogOut];
}

//检查更新，点击去掉的回调
-(void)cancelUpdateCallBack
{
    __isClick5 = YES;
}


/**
 *  个人中心
 */
-(void)splusAcountManage
{
    [[KYSDK instance] setUpUser];
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

#pragma mark --KyUserSDKDelegate--
-(void)loginCallBack:(NSString *)tokenKey{
    NSLog(@"fastuser =  %@", tokenKey);
    [self loginSplusCallback:tokenKey];//登录成功后，发送token给Splus后台
    
}

-(void)quickLogCallBack:(NSString *)tokenKey{
    
    NSLog(@"fastuser =  %@", tokenKey);
    [self loginSplusCallback:tokenKey];//登录成功后，发送token给Splus后台
}

-(void)gameLogBack:(NSString *)username passWord:(NSString *)password
{
    
    //游戏判断返回用户名密码是否正确，如果错误，将错误信息和类型传入sdk
    
}

//注销回调
-(void)logOutCallBack
{
    [_delegate SplusLogOutOnSuccess];
}

//用户关闭支付界面回调接口
-(void)closePayCallback
{
    _payResultCode = @"2";//关闭支付页面
    [_delegate SplusLeavedPay:_payResultCode];
}

//支付宝回调
-(void)alipayCallBack:(ALIPAYRESULT)alipayresult
{
    NSLog(@"支付宝支付");
    NSLog(@"alipayresult = %u", alipayresult);
    if (alipayresult == 0) {
        _payResultCode = @"1";//失败
    }else{
        _payResultCode = @"0";//支付宝支付成功
    }
    
    [_delegate SplusLeavedPay:_payResultCode];
}

-(void)UPPayPluginResult:(UNIPAYTYPE)result
{
    NSLog(@"银联支付");
    if (result == 0) {
        _payResultCode = @"0";
    }else{
        _payResultCode = @"1";
    }
    [_delegate SplusLeavedPay:_payResultCode];
}

-(void)logSendSMSCallback:(NSString *)phoneNO
{
    if (![phoneNO isEqualToString:@"13562765425"]) {
        [[KYSDK instance]showStateGame:@"用户不正确"];
    }
}

/**
 *  请求Splus登录
 *
 *  @param userInfo 用户信息
 */
-(void)loginSplusCallback:(NSString*)tokenKey
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
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:gameID, @"gameid",
                                deviceNo, @"deviceno",
                                sourceID,@"referer",
                                partner, @"partner",
                                @"", @"partner_sessionid",
                                @"", @"partner_uid",
                                tokenKey, @"partner_token",
                                @"", @"partner_nickname",
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
            //定额支付
            [[KYSDK instance] showPayWith:orderid fee:[OrderInfo sharedSingleton].money game:[AppInfo sharedSingleton].partnerGameID gamesvr:@"" subject:[OrderInfo sharedSingleton].pext md5Key:@"8mt1oH6pqQr5nmgQqOahqQISmC1c0hA9" userId:[SplusUser sharedSingleton].uid  appScheme:@"SplusAlipay"];
            
            
        }else
        {
            //玩家自选金额兑换
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

#pragma mark --KYMobilePayDelegate--
-(void)onBillingResult:(BillingResultType)resultCode billingIndex:(NSString *)index message:(NSString *)message
{
    NSLog(@"ssss");
    [_delegate SplusLeavedPay:[OrderInfo sharedSingleton]];
}

-(void)showMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
