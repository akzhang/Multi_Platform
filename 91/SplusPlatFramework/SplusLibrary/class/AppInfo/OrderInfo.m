//
//  OrderInfo.m
//  SplusFramework
//
//  Created by akzhang on 14-7-1.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "OrderInfo.h"

@implementation OrderInfo

+ (OrderInfo *)sharedSingleton{
    static OrderInfo *sharedSingleton = nil;
    @synchronized(self){
        if (!sharedSingleton) {
            sharedSingleton = [[OrderInfo alloc] init];
            return sharedSingleton;
        }
    }
    return sharedSingleton;
}

//自定义ActivateInfo
-(void)initWithType:(NSString*)mServerId serverName:(NSString*)mServerName RoleId:(NSString*)mRoleId RoleName:(NSString*)mRoleName OutOrderId:(NSString*)mOutOrderid Pext:(NSString*)mPext Money:(NSString*)mMoney Type:(NSString*)mType ProductID:(NSString*)mProductID
       ProductPrice:(NSString*)mProductPrice
ProductOrignalPrice:(NSString*)mProductOrignalPrice
       ProductCount:(NSString*)mProductCount
{
    _serverId = mServerId;
    _serverName = mServerName;
    _roleId = mRoleId;
    _roleName = mRoleName;
    _outOrderid = mOutOrderid;
    _pext = mPext;
    _money = mMoney;
    _type = mType;
    _productID = mProductID;
    _productPrice = mProductPrice;
    _productOrignalPrice = mProductOrignalPrice;
    _productCount = mProductCount;
}

@end
