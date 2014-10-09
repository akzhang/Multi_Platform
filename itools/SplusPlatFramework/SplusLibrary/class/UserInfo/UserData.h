//
//  User.h
//  yywaniosSDK
//
//  Created by akzhang on 14-2-22.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "NSData+ASE128.h"
#import "NSData+hexRepresentationWithSpaces_AS.h"
#import "NSString+dataFromHexString.h"

@interface UserData : NSObject{
//    NSString *username;
//    NSString *uid;
//    NSString *token;
}

+ (UserData *)sharedSingleton;

@property(strong, nonatomic)NSString *username;
@property(strong, nonatomic)NSString *uid;
@property(strong, nonatomic)NSString *token;
@property(nonatomic, retain)NSString *amount;

+(void)push:(NSString*)username password:(NSString*)argPassword;
+(NSDictionary *)get;
+(void)pop:(NSString*)username;
+(NSDictionary *)get;
+(void)update:(NSString*)username;
@end
