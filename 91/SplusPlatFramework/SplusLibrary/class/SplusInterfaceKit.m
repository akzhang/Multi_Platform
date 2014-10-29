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
#import <NdComPlatform/NDComPlatform.h>
#import <NdComPlatform/NdComPlatformAPIResponse.h>
#import <NdComPlatform/NdCPNotifications.h>
#import <NdComPlatform/NdComPlatformError.h>
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
    // 登录
    [[NdComPlatform defaultPlatform] NdLogin:0];
}

-(void)splusPause
{
    [[NdComPlatform defaultPlatform] NdPause];
}

/**
 *  个人中心
 */
-(void)splusAcountManage
{
    [[NdComPlatform defaultPlatform] NdEnterPlatform:0];
}


///**
// *  不定额充值
// */
//-(void)splusQuotaPay:(NSString*)mType serverID:(NSString*)serverid serverName:(NSString*)serverName RoleId:(NSString*)roleld RoleName:(NSString*)roleName OutOrderId:(NSString*)mOutOrderid Pext:(NSString*)mPext ProductID:(NSString*)mProductID
//        ProductPrice:(NSString*)mProductPrice
// ProductOrignalPrice:(NSString*)mProductOrignalPrice
//        ProductCount:(NSString*)mProductCount;
//{
//    [OrderInfo sharedSingleton].serverId = serverid;
//    [OrderInfo sharedSingleton].serverName = serverName;
//    [OrderInfo sharedSingleton].roleId = roleld;
//    [OrderInfo sharedSingleton].roleName = roleName;
//    [OrderInfo sharedSingleton].outOrderid = mOutOrderid;
//    [OrderInfo sharedSingleton].pext = mPext;
//    [OrderInfo sharedSingleton].type = @"0";
//    [OrderInfo sharedSingleton].money = @"0";
//    [self paySplusCallback];
//}

/**
 *  定额支付
 *  @param money      充值金额
 */
-(void)splusQuotaPay:(NSString*)mType serverID:(NSString*)serverid serverName:(NSString*)serverName RoleId:(NSString*)roleld RoleName:(NSString*)roleName OutOrderId:(NSString*)mOutOrderid Pext:(NSString*)mPext ProductID:(NSString*)mProductID
        ProductPrice:(NSString*)mProductPrice
 ProductOrignalPrice:(NSString*)mProductOrignalPrice
        ProductCount:(NSString*)mProductCount
{
    [OrderInfo sharedSingleton].serverId = serverid;
    [OrderInfo sharedSingleton].serverName = serverName;
    [OrderInfo sharedSingleton].roleId = roleld;
    [OrderInfo sharedSingleton].roleName = roleName;
    [OrderInfo sharedSingleton].outOrderid = mOutOrderid;
    [OrderInfo sharedSingleton].pext = mPext;
    [OrderInfo sharedSingleton].money = [NSString stringWithFormat:@"%f",[mProductCount intValue]*[mProductPrice floatValue]];//
    [OrderInfo sharedSingleton].type = mType;
    [OrderInfo sharedSingleton].productID = mProductID;
    [OrderInfo sharedSingleton].productPrice = mProductPrice;
    [OrderInfo sharedSingleton].productOrignalPrice = mProductOrignalPrice;
    [OrderInfo sharedSingleton].productCount = mProductCount;
    [self paySplusCallback];
}


/**
 *  初始化
 */
-(void)initSplus
{
    NdInitConfigure *cfg = [[NdInitConfigure alloc] init];
    cfg.appid = [[AppInfo sharedSingleton].partnerGameID intValue];
    cfg.appKey = [AppInfo sharedSingleton].partnerKey; //单机,弱联网必须关注 versionCheckLevel 的设置说明,详见上面说明
    cfg.orientation = UIDeviceOrientationLandscapeRight;
    cfg.versionCheckLevel = ND_VERSION_CHECK_LEVEL_NORMAL;
    [[NdComPlatform defaultPlatform] NdInit:cfg];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSInitResult:) name:(NSString *)kNdCPInitDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSLoginResult:) name:(NSString *)kNdCPLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSSessionInvalid:) name:(NSString *)kNdCPSessionInvalidNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSleavePlatform:) name:(NSString *)kNdCPLeavePlatformNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSPauseExist:) name:(NSString *)kNdCPPauseDidExitNotification object:nil];
    
    //添加购买结果监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NdUniPayResult:)
                                                 name:kNdCPBuyResultNotification
                                               object:nil];
}

-(void)SNSPauseExist:(id)sender
{
    [_delegate SplusPagePause];//暂停页回调
}


/**
 *  设置SDK屏幕的方向
 *
 *  @param orientation UIInterfaceOrientation
 */
-(void)splusScreenOrientation:(UIInterfaceOrientation)orientation
{
    //SDK初始化，务必放在其他SDK接口的调用之前
    [[NdComPlatform defaultPlatform] NdSetScreenOrientation:orientation];
     [[NdComPlatform defaultPlatform] NdSetAutoRotation:NO];
    
}

-(void)splusHideToolBar:(BOOL)hide
{
    if (hide) {
        [[NdComPlatform defaultPlatform] NdHideToolBar];
    }
}


/**
 *  注销通知
 */
- (void)didLogout{
    //    [self quickShowMessage:@"已注销"];
    [_delegate SplusLogOutOnSuccess];//注销回调
}

-(void)SNSleavePlatform:(id)sender
{
    NSLog(@"leave plat");
    [_delegate SplusLeavedAcount];//退出平台界面callback
}

//初始化完成，调用登录接口
- (void)SNSInitResult:(NSNotification *)notify
{
    //设置悬浮图
    [[NdComPlatform defaultPlatform] NdShowToolBar:NdToolBarAtTopLeft];
    
    // 登录
    [[NdComPlatform defaultPlatform] NdLogin:0];
}

//登录
- (void)SNSLoginResult:(NSNotification *)notify
{
    
    NSDictionary *dict = [notify userInfo];
    BOOL success = [[dict objectForKey:@"result"] boolValue];
    NdGuestAccountStatus* guestStatus = (NdGuestAccountStatus*)[dict objectForKey:@"NdGuestAccountStatus"];
    
    //登录成功后处理
    if([[NdComPlatform defaultPlatform] isLogined] && success) {
        
        //也可以通过[[NdComPlatform defaultPlatform] getCurrentLoginState]判断是否游客登录状态
        if (guestStatus) {
            NSString* strUin = [[NdComPlatform defaultPlatform] loginUin];
            NSString* strTip = nil;
            if ([guestStatus isGuestLogined]) {
                strTip = [NSString stringWithFormat:@"游客账号登录成功,\n uin = %@", strUin];
            }
            else if ([guestStatus isGuestRegistered]) {
                strTip = [NSString stringWithFormat:@"游客成功注册为普通账号,\n uin = %@", strUin];
            }
        }
        else {
            // 普通账号登录成功!
            NSLog(@"登录回调成功ssss");
            [self loginSplusCallback];
        }
        
    }
    //登录失败处理和相应提示
    else {
        int error = [[dict objectForKey:@"error"] intValue];
        NSString* strTip = [NSString stringWithFormat:@"登录失败, error=%d", error];
        switch (error) {
            case ND_COM_PLATFORM_ERROR_USER_CANCEL://用户取消登录
                if (([[NdComPlatform defaultPlatform] getCurrentLoginState] == ND_LOGIN_STATE_GUEST_LOGIN)) {
                    strTip =  @"当前仍处于游客登录状态";
                }
                else {
                    strTip = @"用户未登录";
                }
                break;
                
                // {{ for demo tip
            case ND_COM_PLATFORM_ERROR_APP_KEY_INVALID://appId未授权接入, 或appKey 无效
                strTip = @"登录失败, 请检查appId/appKey";
                break;
            case ND_COM_PLATFORM_ERROR_CLIENT_APP_ID_INVALID://无效的应用ID
                strTip = @"登录失败, 无效的应用ID";
                break;
            case ND_COM_PLATFORM_ERROR_HAS_ASSOCIATE_91:
                strTip = @"有关联的91账号，不能以游客方式登录";	
                break;
                
                // }}
            default:
                break;
        }
    }
}

//91支付成功回调
- (void)NdUniPayResult:(NSNotification*)notify
{
    NSDictionary *dic = [notify userInfo];
    BOOL bSuccess = [[dic objectForKey:@"result"] boolValue]; NSString* str = bSuccess ? @"购买成功" : @"购买失败";
    if (!bSuccess) {
        //TODO: 购买失败处理
        NSString* strError = nil;
        int nErrorCode = [[dic objectForKey:@"error"] intValue]; switch (nErrorCode) {
            case ND_COM_PLATFORM_ERROR_USER_CANCEL: strError = @"用户取消操作";
                break;
            case ND_COM_PLATFORM_ERROR_NETWORK_FAIL: strError = @"网络连接错误";
                break;
            case ND_COM_PLATFORM_ERROR_SERVER_RETURN_ERROR: strError = @"服务端处理失败";
                break;
            default:
                strError = @"购买过程发生错误";
            break; }
        str = [str stringByAppendingFormat:@"\n%@", strError];
        [_delegate SplusLeavedPay:@"1"];
    }
    else {
        //TODO: 购买成功处理
        [_delegate SplusLeavedPay:@"0"];
    }
    //本次购买的请求参数
    NdBuyInfo* buyInfo = (NdBuyInfo*)[dic objectForKey:@"buyInfo"];
    str = [str stringByAppendingFormat:@"\n<productId = %@, productCount = %d, cooOrderSerial = %@>",
           buyInfo.productId, buyInfo.productCount, buyInfo.cooOrderSerial];
    NSLog(@"NdUiPayResult: %@", str);
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
            NdBuyInfo *buyInfo = [NdBuyInfo new]; //订单号必须唯一,推荐为GUID或UUID
            buyInfo.cooOrderSerial = orderid;
            buyInfo.productId = [OrderInfo sharedSingleton].pext; //自定义的产品ID
            buyInfo.productName = [OrderInfo sharedSingleton].pext; //产品名称
            buyInfo.productPrice = [[OrderInfo sharedSingleton].productPrice floatValue]; //产品现价,价格大等于0.01,支付价格以此为准 buyInfo.productOrignalPrice = 0.01
            buyInfo.productOrignalPrice = [[OrderInfo sharedSingleton].productOrignalPrice floatValue];
            buyInfo.productCount = [[OrderInfo sharedSingleton].productCount intValue];
            buyInfo.payDescription = [OrderInfo sharedSingleton].serverName; //服务器分区,不超过20个字符,只允许英文或数字
            
            int res = [[NdComPlatform defaultPlatform] NdUniPay:buyInfo];
            if (res < 0)
            {
                //输入参数有错!无法提交购买请求
                [self showMessage:@"输入参数有错!无法提交购买请求"];
            }
        }else
        {
            NdBuyInfo *buyInfo = [NdBuyInfo new]; //订单号必须唯一,推荐为GUID或UUID
            buyInfo.cooOrderSerial = orderid;
            buyInfo.productId = [OrderInfo sharedSingleton].pext; //自定义的产品ID
            buyInfo.productName = [OrderInfo sharedSingleton].pext; //产品名称
            buyInfo.productPrice = [[OrderInfo sharedSingleton].money intValue]; //产品现价,价格大等于0.01,支付价格以此为准 buyInfo.productOrignalPrice = 0.01; //产品原价,同现价保持一致 buyInfo.productCount = 1; //产品数量
            buyInfo.payDescription = [OrderInfo sharedSingleton].serverName; //服务器分区,不超过20个字符,只允许英文或数字
            
            int res = [[NdComPlatform defaultPlatform] NdUniPay:buyInfo];
            if (res < 0)
            {
                //输入参数有错!无法提交购买请求
                [self showMessage:@"输入参数有错!无法提交购买请求"];
            }
        }
        
    }
}

/**
 *  请求Splus登录
 *
 *  @param userInfo 用户信息
 */
-(void)loginSplusCallback
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
    
    NSString *sessionID = [[NdComPlatform defaultPlatform] sessionId];
    NSString *nickName = [[NdComPlatform defaultPlatform] nickName];
    NSString *userID = [[NdComPlatform defaultPlatform] loginUin];
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
        NSString *partnerUid = [data objectForKey:@"partner_uid"];
        [SplusUser sharedSingleton].uid = userID;
        [SplusUser sharedSingleton].sessionID = sessionID;
        [SplusUser sharedSingleton].partner_uid = partnerUid;
        //登录成功，callback
        NSLog(@"times");
        [_delegate SplusLoginOnSuccess:[SplusUser sharedSingleton]];
    }
    else
    {
        NSString *msg = [rootDic objectForKey:@"msg"];
        [self showMessage:msg];
    }
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
    
}


-(void)login_error{
    
    if (_HUD != NULL) {
        [_HUD hide:YES];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)showMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNdCPBuyResultNotification object:nil];
}

@end

