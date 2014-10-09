//
//  Activate.h
//  SplusIosSdk
//
//  Created by akzhang on 14-6-13.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplusCallback.h"
#import "MBProgressHUD.h"
#import "AppInfo.h"
#import "HttpUrl.h"
#import "qqMac.h"
#import "httpRequest.h"
#import "MyMD5.h"
#import "ActivateInfo.h"
#import "SBJsonParser.h"

@interface Activate : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *splusLogo;

@property (strong, nonatomic) IBOutlet UIButton *splusBt;

@property(nonatomic, retain)id<SplusCallback> delegate;

@property(nonatomic, retain)MBProgressHUD *HUD;

@end
