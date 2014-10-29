//
//  SplusInterfaceKit.h
//  SplusMutiPlat
//
//  Created by akzhang on 14-7-22.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsInfoKit.h"
#import "AsPlatformSDK.h"
#import "SplusCallback.h"
#import "MBProgressHUD.h"


//<TBBuyGoodsProtocol,TBCheckOrderDelegate>

@interface SplusInterfaceKit : NSObject<AsPlatformSDKDelegate>

@property(nonatomic,retain)id<SplusCallback> delegate;//设置callback委托

@property(nonatomic, strong)NSString *payType;

@property(nonatomic, strong)NSString *loginPageCode;

@property(nonatomic, strong)NSString *payPageCode;

@property(nonatomic, strong)MBProgressHUD *HUD;


/**
 *  API单例
 *
 *  @return 返回单例
 */
+(SplusInterfaceKit*)sharedInstance;

/**
 *  设置委托
 *
 *  @param argDelegate 委托
 */
-(void)setDelegate:(id<SplusCallback>)argDelegate;

/**
 *  CP商渠道号，游戏ID，游戏ID，渠道号从Splus后台获取
 *
 *  @param AppId       游戏ID
 *  @param argSourceId 渠道ID
 *  @param argGameKey 游戏key
 */
-(void) setApp:(NSString*)AppId GameKey:(NSString*)argGameKey SourceID:(NSString*)argSourceId PartnerID:(NSString*)partnerID PartnerKey:(NSString*)partnerKey;

/**
 *  初始化
 */
-(void)initSplus;


/**
 *  激活接口
 */
-(void)activate;


/**
 *  登录接口
 *
 *  @param context context
 */
-(void)splusLogin;


-(void)splusHideToolBar:(BOOL)hide;

/**
 *  个人中心
 */
-(void)splusAcountManage;

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
-(void)setPlayerInfo:(NSString*)serverid serverName:(NSString*)serverName RoleId:(NSString*)roleld RoleName:(NSString*)roleName OutOrderId:(NSString*)mOutOrderid Pext:(NSString*)mPext;

/**
 *  不定额充值
 *  @param type支付类型 “0”为不定额充值， 1为定额充值
 *  @param serverid    服务id
 *  @param serverName  服务器名字
 *  @param roleld      游戏ID
 *  @param roleName    游戏名字
 *  @param mOutOrderid 外部订单号
 *  @param mPext       附加信息
 */
-(void)splusPay:(NSString*)type serverID:(NSString*)serverid serverName:(NSString*)serverName RoleId:(NSString*)roleld RoleName:(NSString*)roleName OutOrderId:(NSString*)mOutOrderid Pext:(NSString*)mPext;

/**
 *  定额支付
 *  @param money      充值金额
 *  @param type支付类型 “0”为不定额充值， 1为定额充值
 *  @param serverid    服务id
 *  @param serverName  服务器名字
 *  @param roleld      游戏ID
 *  @param roleName    游戏名字
 *  @param mOutOrderid 外部订单号
 *  @param mPext       附加信息
 */
-(void)splusQuotaPay:(NSString*)money Type:(NSString*)mType serverID:(NSString*)serverid serverName:(NSString*)serverName RoleId:(NSString*)roleld RoleName:(NSString*)roleName OutOrderId:(NSString*)mOutOrderid Pext:(NSString*)mPext;


/**
 *  open url
 *
 *  @param serverid    url
 */
-(void)splusOpenUrl:(NSURL*)url;

/**
 *  handle url
 *
 *  @param serverid    url
 *  @param sourceApplication
 */
-(void)splusHandleOpenUrl:(NSURL*)url SourceApplication:(NSString*)sourceApplication;

@end
