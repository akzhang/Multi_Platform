//
//  ActivateInfo.h
//  SplusFramework
//
//  Created by akzhang on 14-6-20.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivateInfo : NSObject

+ (ActivateInfo *)sharedSingleton;

@property(nonatomic, strong)NSString *deviceno;

@property(nonatomic, strong)NSString *passport;

@property(nonatomic, strong)NSString *relationships;

@end
