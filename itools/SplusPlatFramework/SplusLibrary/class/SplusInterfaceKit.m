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
#import "SplusUser.h"
#import "HXAppPlatformKitPro.h"
#import "NSDictionary+QueryBuilder.h"

@implementation SplusInterfaceKit

__strong static SplusInterfaceKit *singleton = nil;

/**
 *  API单例
 *q
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
    [OrderInfo sharedSingleton].serverId = serverid;
    [OrderInfo sharedSingleton].serverName = serverName;
    [OrderInfo sharedSingleton].roleId = roleld;
    [OrderInfo sharedSingleton].roleName = roleName;
    [OrderInfo sharedSingleton].outOrderid = mOutOrderid;
    [OrderInfo sharedSingleton].pext = mPext;
}

/**
 *  激活接口
 */
-(void)activate
{
    Activate *active = [[Activate alloc] init];
    active.delegate = _delegate;//设置委托
//    [self initSplus];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootViewController presentViewController:active animated:NO completion:nil];
}


/**
 *  登录接口
 *
 *  @param context context
 */
-(void)splusLogin
{
    [HXAppPlatformKitPro showLoginView];
}

/**
 *  个人中心
 */
-(void)splusAcountManage
{
    [HXAppPlatformKitPro showPlatformView];
}


/**
 *  不定额充值
 */
-(void)splusPay:(NSString*)type
{
    [self ppPayToSplus];
}

/**
 *  定额支付
 *  @param money      充值金额
 */
-(void)splusQuotaPay:(NSString*)money Type:(NSString*)mType
{
    [OrderInfo sharedSingleton].money = money;
    [self ppPayToSplus];
}

-(void)logion_callback:(NSString*)result
{
    
    NSLog(@"login info result = %@", result);//登录信息
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDic = [parser objectWithString:result];
    NSString *code = [rootDic objectForKey:@"code"];
    
    if ([code intValue] == 1) {
        NSDictionary *data = [rootDic objectForKey:@"data"];
        NSString *uid = [data objectForKey:@"uid"];
        [SplusUser sharedSingleton].uid = uid;
        //登录成功，callback
        [_delegate SplusLoginOnSuccess:result];
    }
}

-(void)login_error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)ppPayToSplus
{
    // 支付
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
    
    if ([[OrderInfo sharedSingleton].type intValue] == 0) {
        _payType = @"";
    }
    else
    {
        _payType = @"1";
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
                                [OrderInfo sharedSingleton].money, @"money",
                                _payType, @"type",//充值方式0 非定额 1 定额
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
        [HXAppPlatformKitPro setPayViewAmount:[[OrderInfo sharedSingleton].money floatValue] orderIdCom:orderid];
    }
}

-(void)pay_error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

/**
 *  初始化
 */
-(void)initSplus
{
    //监听注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNotification:) name:HX_NOTIFICATION_REGISTER object:nil];
    
    //监听登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification:) name:HX_NOTIFICATION_LOGIN object:nil];
    
    //视图关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeViewNotification:) name:HX_NOTIFICATION_CLOSEVIEW object:nil];
    
    //注销通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:HX_NOTIFICATION_LOGOUT object:nil];
    
    //处理支付视图时关闭的附加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePayViewNotification:) name:HX_NOTIFICATION_CLOSE_PAYVIEW object:nil];
    
    //监听服务器有可更新App的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateApp:) name:HX_NOTIFICATION_UPDATE_APP object:nil];
    
}

-(void)toSplusLogin:(NSNotification *)notification
{
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
                                [notification.object objectForKey:@"sessionId"], @"partner_sessionid",
                                [notification.object objectForKey:@"userId"], @"partner_uid",
                                @"", @"partner_token",
                                @"", @"partner_nickname",
                                @"", @"partner_username",
                                [AppInfo sharedSingleton].gameID, @"partner_appid",
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
    NSLog(@"pay = %@", var);
    
    [_request post:MLOGIN_URL argData:postData];
}


#pragma mark - 处理 SDK 通知
//注册通知处理
- (void)registerNotification:(NSNotification *)notification
{
    NSLog(@"userId: %@", [notification.object objectForKey:@"userId"]);
    NSLog(@"userName: %@", [notification.object objectForKey:@"userName"]);
    NSLog(@"sessionId: %@", [notification.object objectForKey:@"sessionId"]);
    
    [self toSplusLogin:notification];
}

//登录通知处理
- (void)loginNotification:(NSNotification *)notification
{
    NSLog(@"userId: %@", [notification.object objectForKey:@"userId"]);
    NSLog(@"userName: %@", [notification.object objectForKey:@"userName"]);
    NSLog(@"sessionId: %@", [notification.object objectForKey:@"sessionId"]);
    
    [self toSplusLogin:notification];
}

//关闭窗口通知处理
- (void)closeViewNotification:(NSNotification *)notification
{
    [_delegate SplusClosePage];
}

//注销通知处理
- (void)logoutNotification:(NSNotification *)notification
{
//    [_delegate SplusLoginOnCancle];//注销回调
    [_delegate SplusClosePage];
}

- (void)closePayViewNotification:(NSNotification *)notification
{
    [_delegate SplusPayOnSuccess:[notification object]];//itools  没有回调通知，需游戏客户端做处理
}

//监听服务器有可更新App的通知处理
- (void)updateApp:(NSNotification *)notification
{
    NSLog(@"server has app update");
    NSLog(@"userId: %@", [notification.object objectForKey:@"userId"]);
    NSLog(@"userName: %@", [notification.object objectForKey:@"userName"]);
    NSLog(@"sessionId: %@", [notification.object objectForKey:@"sessionId"]);
}

@end
