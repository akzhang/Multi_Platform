//
//  User.m
//  SplusFramework
//
//  Created by akzhang on 14-6-23.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "SplusUser.h"

@implementation SplusUser

+ (SplusUser *)sharedSingleton
{
    static SplusUser *sharedSingleton = nil;
    @synchronized(self){
        if (!sharedSingleton) {
            sharedSingleton = [[SplusUser alloc] init];
            return sharedSingleton;
        }
    }
    return sharedSingleton;
}

-(void)initWithType:(NSString*)splusName Pwd:(NSString*)splusPwd Sessiond:(NSString*)splusSessiond Uid:(NSString*)splusUid
{
    _username = splusName;
    _passwd = splusPwd;
    _uid = splusUid;
    _sessiond = splusSessiond;
}

@end
