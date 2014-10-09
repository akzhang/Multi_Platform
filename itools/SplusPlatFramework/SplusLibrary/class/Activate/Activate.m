//
//  Activate.m
//  SplusIosSdk
//
//  Created by akzhang on 14-6-13.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "Activate.h"
#import "NSDictionary+QueryBuilder.h"
#import "GetImage.h"

//#define SCREENHEIGHT [GetImage screenSize].height
//#define SCREENWIDTH [GetImage screenSize].width

@interface Activate ()

@end

@implementation Activate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _splusLogo = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 30, 40, 60, 60)];
    _splusLogo.image = [GetImage imagesNamedFromCustomBundle:@"splus_float_icon_normal"];
    [self.view addSubview:_splusLogo];
    
    //设置loading
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.dimBackground = YES;
    _HUD.labelText = @"玩命加载中...";
    [_HUD show: YES];
    
    //激活信息
    NSDictionary *dictionaryBundle = [[NSBundle mainBundle] infoDictionary];
    NSString *partner = [dictionaryBundle objectForKey:@"Partner"];
    NSString *sign = @"";
    sign = [sign stringByAppendingFormat:@"%@%@%@%@%@%@%@", [AppInfo sharedSingleton].gameID, [AppInfo sharedSingleton].sourceID, [dictionaryBundle objectForKey:@"Partner"],[qqMac getMacAddress], [qqMac getMacAddress],[[AppInfo sharedSingleton] getData], [AppInfo sharedSingleton].gameKey];
    
    NSLog(@"sign = %@", sign);
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[AppInfo sharedSingleton].gameID, @"gameid",[AppInfo      sharedSingleton].sourceID,@"referer",
                                partner, @"partner",
                                [qqMac getMacAddress], @"mac",
                                [qqMac getMacAddress], @"imei",
                                [NSString stringWithFormat:@"%f",SCREENWIDTH*scale_screen], @"wpixels",
                                [NSString stringWithFormat:@"%f",SCREENHEIGHT*scale_screen], @"hpixels",
                                [UIDevice currentDevice].model, @"mode",
                                [[UIDevice currentDevice] systemName], @"os",
                                [[UIDevice currentDevice] systemVersion], @"osver",
                                [[AppInfo sharedSingleton] getData], @"time",
                                [MyMD5 md5:sign], @"sign",
                                [[UIDevice currentDevice] identifierForVendor], @"device",nil];
    
    NSString *postData = [dictionary buildQueryString];
    
    httpRequest *_request = [[httpRequest alloc] init];
    _request.dlegate = self;
    _request.success = @selector(active_callback:);
    _request.error = @selector(active_error_callback);
    [_request post:API_URL_ACTIVATE argData:postData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)active_error_callback
{
    if (_HUD != NULL) {
        [_HUD hide:YES];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)active_callback:(NSString*)result
{
    NSLog(@"result = %@", result);
//    NSError *error = nil;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDic = [parser objectWithString:result];
    
//    NSDictionary *rootDic = [parser objectWithString:result error:&error];
    
    NSDictionary *deviceDic = [rootDic objectForKey:@"data"];
    NSString *deviceno = [deviceDic objectForKey:@"deviceno"];
    NSLog(@"deviceno = %@", deviceno);
    
    [ActivateInfo sharedSingleton].deviceno = deviceno;
    [ActivateInfo sharedSingleton].passport = [deviceDic objectForKey:@"passport"];
    [ActivateInfo sharedSingleton].relationships = [deviceDic objectForKey:@"relationships"];
    
    if (_HUD != NULL) {
        [_HUD hide:YES];
    }
    
    sleep(2);
    //激活成功，callback
    [_delegate SplusActivateOnSuccess];
    [self dismissModalViewControllerAnimated:NO];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}







@end
