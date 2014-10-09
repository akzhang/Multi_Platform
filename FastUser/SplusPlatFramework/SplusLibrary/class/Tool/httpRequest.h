//
//  httpRequest.h
//  SplusIOS
//
//  Created by akzhang on 14-3-19.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface httpRequest : NSObject<NSURLConnectionDataDelegate,MBProgressHUDDelegate>{

}

@property(nonatomic,retain)id dlegate;

@property(nonatomic, retain)NSMutableData *receivedData;

@property(nonatomic, assign)SEL success;

@property(nonatomic, assign)SEL error;

@property(nonatomic, assign)BOOL HUD_FLAG;

@property(nonatomic, retain)MBProgressHUD *HUD;

@property(nonatomic, retain) NSString *HUD_TITLE;

/**
 *  post 异步请求
 *
 *  @param url  post 异步请求地址
 *  @param data post 请求参数
 */
-(void)post:(NSString*)url argData:(NSString*)data;

/**
 *  get 异步请求
 *
 *  @param tempUrl 请求地址
 */
-(void)getRSAGetResult:(NSString*)tempUrl;


/**
 *  post 同步请求
 *
 *  @param tempUrl    同步请求地址
 *  @param resultData 请求参数
 *
 *  @return post请求返回数据
 */
-(NSString*)postSyncGetResult:(NSString*)tempUrl tempData:(NSString*)resultData;

@end
