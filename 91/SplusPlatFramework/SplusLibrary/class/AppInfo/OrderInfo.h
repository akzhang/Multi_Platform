//
//  OrderInfo.h
//  SplusFramework
//
//  Created by akzhang on 14-7-1.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject

+ (OrderInfo *)sharedSingleton;

@property(nonatomic, strong)NSString *serverId;

@property(nonatomic, strong)NSString *serverName;

@property(nonatomic, strong)NSString *roleId;

@property(nonatomic, strong)NSString *roleName;

@property(nonatomic, strong)NSString *outOrderid;

@property(nonatomic, strong)NSString *pext;

@property(nonatomic, strong)NSString *money;

@property(nonatomic, strong)NSString *type;

@property(nonatomic, strong)NSString *transNum;

@property(nonatomic, strong)NSString *productID;

@property(nonatomic, strong)NSString *productPrice;

@property(nonatomic, strong)NSString *productOrignalPrice;

@property(nonatomic, strong)NSString *productCount ;

-(void)initWithType:(NSString*)mServerId serverName:(NSString*)mServerName RoleId:(NSString*)mRoleId RoleName:(NSString*)mRoleName OutOrderId:(NSString*)mOutOrderid Pext:(NSString*)mPext Money:(NSString*)mMoney Type:(NSString*)mType
          ProductID:(NSString*)mProductID
       ProductPrice:(NSString*)mProductPrice
ProductOrignalPrice:(NSString*)mProductOrignalPrice
       ProductCount:(NSString*)mProductCount;

@end
