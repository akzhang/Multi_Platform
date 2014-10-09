//
//  checkWifi.h
//  YayawanIOS
//
//  Created by akzhang on 14-3-8.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface checkWifi : NSObject

+(BOOL)connectedToNetWork;
+(BOOL)IsEnableWIFI;
//
+(BOOL)IsEnable3G;
@end
