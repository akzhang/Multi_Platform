//
//  User.h
//  SplusFramework
//
//  Created by akzhang on 14-6-23.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SplusUser : NSObject

+ (SplusUser *)sharedSingleton;

@property(nonatomic, strong)NSString *username;
@property(nonatomic, strong)NSString *passwd;
@property(nonatomic, strong)NSString *sessiond;
@property(nonatomic, strong)NSString *uid;

-(void)initWithType:(NSString*)splusName Pwd:(NSString*)splusPwd Sessiond:(NSString*)splusSessiond Uid:(NSString*)splusUid;

@end
