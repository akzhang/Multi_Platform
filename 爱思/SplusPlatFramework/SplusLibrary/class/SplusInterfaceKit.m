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
#import "SvUDIDTools.h"
#import "GetImage.h"
#import "NSDictionary+QueryBuilder.h"


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
 *  设置委托ƒ
 *
 *  @param argDelegate 委托
 */
-(void)setDelegate:(id<SplusCallback>)argDelegate
{
    _delegate = argDelegate;
    [[AsPlatformSDK sharedInstance] setDelegate:self];
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
//    [OrderInfo sharedSingleton].serverId = serverid;
//    [OrderInfo sharedSingleton].serverName = serverName;
//    [OrderInfo sharedSingleton].roleId = roleld;
//    [OrderInfo sharedSingleton].roleName = roleName;
//    [OrderInfo sharedSingleton].outOrderid = mOutOrderid;
//    [OrderInfo sharedSingleton].pext = mPext;
}

/**
 *  激活接口
 */
-(void)activate
{
    [self activateToSplus];//激活
}

-(void)activateToSplus
{
    //激活信息
    NSDictionary *dictionaryBundle = [[NSBundle mainBundle] infoDictionary];
    NSString *partner = [dictionaryBundle objectForKey:@"Partner"];
    NSString *sign = @"";
    sign = [sign stringByAppendingFormat:@"%@%@%@%@%@%@%@", [AppInfo sharedSingleton].gameID, [AppInfo sharedSingleton].sourceID, [dictionaryBundle objectForKey:@"Partner"], [SvUDIDTools UDID], [SvUDIDTools UDID],[[AppInfo sharedSingleton] getData], [AppInfo sharedSingleton].gameKey];
    
    NSLog(@"sign = %@", sign);
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[AppInfo sharedSingleton].gameID, @"gameid",[AppInfo      sharedSingleton].sourceID,@"referer",
                                partner, @"partner",
                                [SvUDIDTools UDID], @"mac",
                                [SvUDIDTools UDID], @"imei",
                                [NSString stringWithFormat:@"%f",SCREENWIDTH*scale_screen], @"wpixels",
                                [NSString stringWithFormat:@"%f",SCREENHEIGHT*scale_screen], @"hpixels",
                                [SvUDIDTools deviceName], @"mode",
                                [[UIDevice currentDevice] systemName], @"os",
                                [[UIDevice currentDevice] systemVersion], @"osver",
                                [[AppInfo sharedSingleton] getData], @"time",
                                [MyMD5 md5:sign], @"sign",
                                [[UIDevice currentDevice] identifierForVendor], @"device",nil];
    
    NSString *postData = [dictionary buildQueryString];
    httpRequest *_request = [[httpRequest alloc] init];
    _request.dlegate = self;
    _request.success = @selector(active_callback:);
    _request.error = @selector(active_error_callback);
    [_request post:API_URL_ACTIVATE argData:postData];
}


-(void)active_error_callback
{
    [self showMessage:@"网络连接超时"];
}

-(void)active_callback:(NSString*)result
{
    NSLog(@"result = %@", result);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDic = [parser objectWithString:result];
    NSDictionary *deviceDic = [rootDic objectForKey:@"data"];
    NSString *deviceno = [deviceDic objectForKey:@"deviceno"];
    NSLog(@"deviceno = %@", deviceno);
    
    [ActivateInfo sharedSingleton].deviceno = deviceno;
    [ActivateInfo sharedSingleton].passport = [deviceDic objectForKey:@"passport"];
    [ActivateInfo sharedSingleton].relationships = [deviceDic objectForKey:@"relationships"];
    
    //激活成功，callback
    [_delegate SplusActivateOnSuccess];
}


/**
 *  登录接口
 *
 *  @param context context
 */
-(void)splusLogin
{
    [[AsPlatformSDK sharedInstance] showLogin];
}

/**
 *  个人中心
 */
-(void)splusAcountManage
{
    [[AsPlatformSDK sharedInstance] showCenter];
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
    [self ppPayToSplus];
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
    [self ppPayToSplus];
}




#pragma mark    ---------------SDK CALLBACK---------------
////字符串登录成功回调【实现其中一个就可以】
//-SDK 1.5.2 - 新增的支付宝支付的回调
- (void)asAlixPayResultCallBack:(int)statusCode
{
    //    * 9000     订单支付成功
    //    * 8000     正在处理
    //    * 4000     订单支付失败
    //    * 6001     用户中途取消
    //    * 6002     网络连接出错
    
    switch (statusCode) {
        case 9000:
            NSLog(@"支付宝的回调 - 订单支付成功 : %d", statusCode);
            _payPageCode = @"0";
            [_delegate SplusLeavedPay:_payPageCode];//支付结果回调
            break;
        case 8000:
            NSLog(@"支付宝的回调 - 正在处理 : %d", statusCode);
            _payPageCode = @"1";
            [_delegate SplusLeavedPay:_payPageCode];//支付结果回调
            break;
        case 4000:
            NSLog(@"支付宝的回调 - 订单支付失败 : %d", statusCode);
            _payPageCode = @"1";
            [_delegate SplusLeavedPay:_payPageCode];//支付结果回调
            break;
        case 6001:
            NSLog(@"支付宝的回调 - 用户中途取消 : %d", statusCode);
            _payPageCode = @"2";
            [_delegate SplusLeavedPay:_payPageCode];//支付结果回调
            break;
        case 6002:
            NSLog(@"支付宝的回调 - 网络连接出错 : %d", statusCode);
            _payPageCode = @"1";
            [_delegate SplusLeavedPay:_payPageCode];//支付结果回调
            break;
        default:
            break;
    }
}


//-SDK 1.5.2 - 新增的银联支付的回调
- (void)asUPPayPluginResultCallBack:(NSString *)result
{
    //    * success  支付成功
    //    * fail     支付失败
    //    * cancel   用户取消支付
    if ([result isEqualToString:@"success"]) {
        NSLog(@"银联支付的回调 - 支付成功 : %@", result);
        _payPageCode = @"0";
        [_delegate SplusLeavedPay:_payPageCode];//支付结果回调
    }
    if ([result isEqualToString:@"fail"]) {
        NSLog(@"银联支付的回调 - 支付失败 : %@", result);
        _payPageCode = @"1";
        [_delegate SplusLeavedPay:_payPageCode];//支付结果回调
    }
    if ([result isEqualToString:@"cancel"]){
        NSLog(@"银联支付的回调 - 用户取消支付 : %@", result);
        _payPageCode = @"2";
        [_delegate SplusLeavedPay:_payPageCode];//支付结果回调
    }
    
}




//-SDK 1.4.1 - 新增的关闭用户中心回调
- (void)asClosedCenterViewCallBack
{
    // 点击按钮关闭用户中心的回调
    NSLog(@"点击按钮关闭用户中心的回调");
    [_delegate SplusLeavedAcount];
    
}

- (void)asPayResultCallBack:(AsPayResultCode)paramPayResultCode
{
    if (paramPayResultCode == 0) {
        _payPageCode = @"0";
    }else{
        _payPageCode = @"1";
    }
    
    [_delegate SplusLeavedPay:_payPageCode];//支付结果回调
}

- (void)asLogOffCallBack
{
    NSLog(@"注销回掉");
    static BOOL isPad;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    });
    float delay = isPad ? 1.2 : 0.6;
    [[AsPlatformSDK sharedInstance] performSelector:@selector(showLogin) withObject:nil afterDelay:delay];
    [_delegate SplusLogOutOnSuccess];
    
    //    NSURLErrorNetworkConnectionLost
}

- (void)asClosePageViewCallBack:(AsPageCode)paramPPPageCode
{
    [_delegate SplusLeavedAcount];
}


- (void)asCloseWebViewCallBack:(AsWebViewCode)paramWebViewCode
{
        _payPageCode = @"2";
    [_delegate SplusLeavedPay:_payPageCode];//关闭支付界面
}

- (void)asVerifyingUpdatePassCallBack
{
    [_delegate SplusCheckUpdate];
}

- (void)asLoginCallBack:(NSString *)paramToken
{
    NSLog(@"登陆回调 - %@",paramToken);
    NSLog(@"爱思助手");
    NSLog(@"paramStrToKenkey =%@", paramToken);
    //此URL为测试demo。请自行更改地址
    NSString *requestURLStr = [NSString stringWithFormat:@"http://api.splusgame.com/sdk/login.php?token=%@",paramToken];
    NSURL *requestUrl = [[NSURL alloc] initWithString:[requestURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];

    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    int status = [[resultDic objectForKey:@"status"] intValue];
    
    //为0为正常
    if (status == 0)
    {
        [self loginSplusCallback:paramToken];//请求灿和
    }
}

/**
 *  请求Splus登录
 *
 *  @param userInfo 用户信息
 */
-(void)loginSplusCallback:(NSString*)paramToken
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
    NSString *gameUid = [NSString stringWithFormat:@"%llu",[[AsPlatformSDK sharedInstance] currentUserId]];
    NSString *gameUserName = [[AsPlatformSDK sharedInstance] currentUserName];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:gameID, @"gameid",
                                deviceNo, @"deviceno",
                                sourceID,@"referer",
                                partner, @"partner",
                                @"", @"partner_sessionid",
                                gameUid, @"partner_uid",
                                paramToken, @"partner_token",
                                @"", @"partner_nickname",
                                gameUserName, @"partner_username",
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
    NSLog(@"get Login url  = %@", var);
    
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
        NSString *partnerUid = [data objectForKey:@"partner_uid"];
        [SplusUser sharedSingleton].uid = userID;
        [SplusUser sharedSingleton].sessionID = sessionID;
        [SplusUser sharedSingleton].partner_uid = partnerUid;
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

-(void)ppPayToSplus
{
    // 登录请求
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
    NSString *outOrderId = [OrderInfo sharedSingleton].outOrderid;
    NSString *pext = [OrderInfo sharedSingleton].pext;
    
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
                                outOrderId ,@"gameOrderid",
                                pext, @"pext",nil];
    
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
        [[AsPlatformSDK sharedInstance] exchangeGoods:[[OrderInfo sharedSingleton].money intValue] BillNo:orderid BillTitle:[OrderInfo sharedSingleton].pext RoleId:[OrderInfo sharedSingleton].roleId ZoneId:[[OrderInfo sharedSingleton].serverId intValue]];
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

/**
 *  初始化
 */
-(void)initSplus
{
    [[AsPlatformSDK sharedInstance] setDelegate:self];
}

/**
 *  open url
 *
 *  @param serverid    url
 */
-(void)splusOpenUrl:(NSURL*)url
{

}

/**
 *  handle url
 *
 *  @param serverid    url
 *  @param sourceApplication
 */
-(void)splusHandleOpenUrl:(NSURL*)url SourceApplication:(NSString*)sourceApplication
{
    NSLog(@"sourceApplication== %@", sourceApplication);
    if ([sourceApplication isEqualToString:@"com.alipay.iphoneclient"])
    {
        [[AsInfoKit sharedInstance] alixPayResult:url];
    }
    else if ([sourceApplication isEqualToString:@"com.alipay.safepayclient"])
    {
        [[AsInfoKit sharedInstance] alixPayResult:url];
    }
    else if ([sourceApplication isEqualToString:@"com.tencent.xin"])
    {
        [[AsInfoKit sharedInstance] weChatPayResult:url];
    }
}


@end
