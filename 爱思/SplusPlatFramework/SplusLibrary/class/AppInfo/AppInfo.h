//
//  AppInfo.h
//  SplusIosSdk
//
//  Created by akzhang on 14-6-13.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

+ (AppInfo *)sharedSingleton;

@property(strong, nonatomic)NSString *gameID;
@property(strong, nonatomic)NSString *gameKey;//mAppkey
@property(strong, nonatomic)NSString *sourceID;//渠道ID

@property(strong, nonatomic)NSString *partnerKey;
@property(strong, nonatomic)NSString *partnerGameID;

@property(strong, nonatomic)NSMutableArray *bankMutableArray;
@property(strong, nonatomic)NSMutableArray *bankNameArray;


-(void)initWithType:(NSString*)gameID GameKey:(NSString*)gameKey SourceID:(NSString*)sourceID;

-(NSString*)getData;

@end
