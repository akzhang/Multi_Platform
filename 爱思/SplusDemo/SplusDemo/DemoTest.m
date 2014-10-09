//
//  DemoTest.m
//  SplusDemo
//
//  Created by akzhang on 14-6-18.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "DemoTest.h"
#import <SplusLibrary/SplusInterfaceKit.h>

@interface DemoTest ()

@end

@implementation DemoTest

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
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
    //Splus SDK初始化
    [[SplusInterfaceKit sharedInstance] setDelegate:self];
    //设置游戏ID， Key ,初始化游戏信息
    NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];
    
    /**
     *  CP商渠道号，游戏ID，游戏ID，渠道号从Splus后台获取
     *
     *  @param AppId       游戏ID
     *  @param argSourceId 渠道ID
     *  @param argGameKey 游戏key
     */
    [[SplusInterfaceKit sharedInstance] setApp:[dictionary objectForKey:@"GameID"] GameKey:[dictionary objectForKey:@"GameKey"] SourceID:[dictionary objectForKey:@"SourceID"] PartnerID:[dictionary objectForKey:@"PartnerGameID"] PartnerKey:[dictionary objectForKey:@"PartnerKey"]];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initLoginView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initLoginView
{
    UILabel *splus = [[UILabel alloc] initWithFrame:CGRectMake(35, 20, 250, 50)];
    splus.text = @"Splus欢迎您，Splus SDK Demo";
    splus.textColor = [UIColor blueColor];
    splus.backgroundColor = [UIColor clearColor];
    [self.view addSubview:splus];
    
    //splus Activate
    _splusActivate = [[UIButton alloc] initWithFrame:CGRectMake(20, 80, 100, 50)];
    [_splusActivate setTitle:@"激活" forState:UIControlStateNormal];
    [_splusActivate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_splusActivate setBackgroundColor:[UIColor orangeColor]];
    [_splusActivate addTarget:self action:@selector(splusStartActivateClick:) forControlEvents: UIControlEventTouchUpInside];//处理点击
    [self.view addSubview:_splusActivate];

    //splus Login
    _splusLoginDemo = [[UIButton alloc] initWithFrame:CGRectMake(130, 80, 100, 50)];
    [_splusLoginDemo setTitle:@"登录" forState:UIControlStateNormal];
    [_splusLoginDemo setBackgroundColor:[UIColor orangeColor]];
    [_splusLoginDemo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_splusLoginDemo addTarget:self action:@selector(splusStartLoginClick:) forControlEvents: UIControlEventTouchUpInside];//处理点击
    [self.view addSubview:_splusLoginDemo];

    //splus Pay
    _splusPayDemo = [[UIButton alloc] initWithFrame:CGRectMake(20, 140, 100, 50)];
    [_splusPayDemo setTitle:@"非定额支付" forState:UIControlStateNormal];
    [_splusPayDemo setBackgroundColor:[UIColor orangeColor]];
    [_splusPayDemo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_splusPayDemo addTarget:self action:@selector(splusStartPayClick:) forControlEvents: UIControlEventTouchUpInside];//处理点击
    [self.view addSubview:_splusPayDemo];

    //splus AcountMember
    _splusAcountMember = [[UIButton alloc] initWithFrame:CGRectMake(130, 140, 150, 50)];
    [_splusAcountMember setTitle:@"个人中心" forState:UIControlStateNormal];
    [_splusAcountMember setBackgroundColor:[UIColor orangeColor]];
    [_splusAcountMember setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_splusAcountMember addTarget:self action:@selector(splusStartAcountClick:) forControlEvents: UIControlEventTouchUpInside];//处理点击
    [self.view addSubview:_splusAcountMember];
    
    _splusCashTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, 150, 50)];
    _splusCashTextField.placeholder = @"请输入金额";
    _splusCashTextField.delegate = self;
    //top view
    UIEdgeInsets topinsets = UIEdgeInsetsMake(10, 10, 10, 10);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage *topimage = [[UIImage imageNamed:@"splus_cash_input"] resizableImageWithCapInsets:topinsets resizingMode:UIImageResizingModeStretch];
    _splusCashTextField.background = topimage;
    _splusCashTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_splusCashTextField];
    
    _splusQuotaPay = [[UIButton alloc] initWithFrame:CGRectMake(130, 200, 150, 50)];
    [_splusQuotaPay setTitle:@"定额支付" forState:UIControlStateNormal];
    [_splusQuotaPay setBackgroundColor:[UIColor orangeColor]];
    [_splusQuotaPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_splusQuotaPay addTarget:self action:@selector(splusQuotaPay:) forControlEvents: UIControlEventTouchUpInside];//处理点击
    [self.view addSubview:_splusQuotaPay];
    
    _splusHideToolBar = [[UIButton alloc] initWithFrame:CGRectMake(130, 260, 150, 50)];
    [_splusHideToolBar setTitle:@"隐藏悬浮窗" forState:UIControlStateNormal];
    [_splusHideToolBar setBackgroundColor:[UIColor orangeColor]];
    [_splusHideToolBar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_splusHideToolBar addTarget:self action:@selector(splusHideBar:) forControlEvents: UIControlEventTouchUpInside];//处理点击
    [self.view addSubview:_splusHideToolBar];
}

-(void)splusHideBar:(id)sender
{
    //yes 表示隐藏悬浮窗， no 表示显示悬浮窗
    [[SplusInterfaceKit sharedInstance] splusHideToolBar:YES];
}

/**
 *  非定额支付
 *
 *  @param sender sender
 */
-(void)splusStartPayClick:(id)sender
{
    /**
     *  不定额充值
     *  @param type支付类型 “0”为不定额充值， 1为定额充值
     *  @param serverid    服务id
     *  @param serverName  服务器名字
     *  @param roleld      游戏ID
     *  @param roleName    游戏名字
     *  @param mOutOrderid 外部订单号
     *  @param mPext       附加信息
     */
    
    [[SplusInterfaceKit sharedInstance] splusPay:@"0" serverID:@"1111" serverName:@"湖南一区" RoleId:@"2222" RoleName:@"ak我杀猪" OutOrderId:@"外部订单号ID" Pext:@"扩展ext"];
}


//定额支付
-(void)splusQuotaPay:(id)sender
{
    if (_splusCashTextField.text.length == 0) {
        [self showMessage:@"请输入充值金额"];
        return;
    }
    NSLog(@"money = %@",_splusCashTextField.text);
    
    /**
     *  定额支付
     *  @param money      充值金额
     *  @param type支付类型 “0”为不定额充值， 1为定额充值
     *  @param serverid    服务id
     *  @param serverName  服务器名字
     *  @param roleld      游戏ID
     *  @param roleName    游戏名字
     *  @param mOutOrderid 外部订单号
     *  @param mPext       附加信息
     */
    
    [[SplusInterfaceKit sharedInstance] splusQuotaPay:_splusCashTextField.text Type:@"1" serverID:@"1111" serverName:@"湖南一区" RoleId:@"2222" RoleName:@"ak我杀猪" OutOrderId:@"外部订单号ID" Pext:@"扩展ext"];
}


/**
 *  激活接口
 *
 *  @param sender sender
 */
- (void)splusStartActivateClick:(id)sender {
    [[SplusInterfaceKit sharedInstance] activate];
}

/**
 *  登录接口
 *
 *  @param sender sender
 */
-(void)splusStartLoginClick:(id)sender
{
    [[SplusInterfaceKit sharedInstance] splusLogin];
}

/**
 *  个人中心
 *
 *  @param sender <#sender description#>
 */
-(void)splusStartAcountClick:(id)sender
{
    [[SplusInterfaceKit sharedInstance] splusAcountManage];
}

/**
 *  激活成功callback
 */
-(void)SplusActivateOnSuccess
{
    [[SplusInterfaceKit sharedInstance] splusLogin];
}

/**
 *  登录成功回调
 *
 *  @param callbackUser callbackUser.uid , sessiond用来跟服务器验证
 */
-(void)SplusLoginOnSuccess:(SplusUser*)callbackUser
{
    NSLog(@"uid = %@", callbackUser.uid);//返回给游戏用户uid
    NSLog(@"sessionID = %@", callbackUser.sessionID);//返回给游戏用户sessiond
    [self showMessage:@"登录成功"];
}

//注销回调
-(void)SplusLogOutOnSuccess
{
    [[SplusInterfaceKit sharedInstance] splusLogin];
}

//支付结果回调
-(void)SplusPayOnResult:(id)sender
{
    int loginPageCode = [sender intValue];//loginPageCode为相应页面关闭后callback 返回值
    switch (loginPageCode) {
        case 1:
            /**
             * 购买成功
             */
            [self showMessage:@"购买成功"];
            break;
            
        case 2:
            /**
             * 用户离线，禁止访问
             */
            [self showMessage:@"用户离线，禁止访问"];
            break;
            
        case 3:
            /**
             * 非法访问，可能用户已经下线
             */
            [self showMessage:@"非法访问，可能用户已经下线"];
            break;
            
        case 4:
            /**
             * 爱思币余额不足 必选参数丢失
             */
            [self showMessage:@"爱思币余额不足 必选参数丢失"];
            break;
            
        case 5:
            /**
             * 消费金额填写不正确
             */
            [self showMessage:@"消费金额填写不正确"];
            break;
            
        default:
            /**
             * 用户中途取消
             */
            [self showMessage:@"用户中途取消"];
            break;
    }
}


//关闭登录或者注册界面
-(void)SplusLeavedWebManage:(id)sender
{
    int loginPageCode = [sender intValue];//loginPageCode为相应页面关闭后callback 返回值
    if (loginPageCode == 1) {
        /**
         * 关闭接口为登录页面
         */
        [self showMessage:@"关闭登录页面回调"];
    }else if (loginPageCode == 2){
        /**
         * 关闭接口为登录页面
         */
        [self showMessage:@"关闭注册页面回调"];
    }
}

//关闭充值界面
-(void)SplusLeavedWebPay:(id)sender
{
    int webPageCode = [sender intValue];
    if (webPageCode == 1) {
        /**
         * 关闭充值页面
         */
        [self showMessage:@"关闭充值页面"];
    }else if (webPageCode == 2){
        /**
         * 关闭兑换页面
         */
        [self showMessage:@"关闭兑换页面"];
    }
}


-(void)showMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];

}


#pragma -mark UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = textField.frame;
    int offset;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {//如果机型是iPhone
        
        if (_orientation == UIDeviceOrientationPortrait) {//是竖屏
            offset = frame.origin.y + 200 - (self.view.frame.size.height -216.0);
        }else{
            offset = frame.origin.y + 230 - (self.view.frame.size.height -216.0);
        }
        
    }else{//机型是ipad
        if (_orientation == UIDeviceOrientationPortrait) {//是竖屏
            offset = frame.origin.y + 100 - (self.view.frame.size.height -216.0);
        }else{
            offset = frame.origin.y + 190 - (self.view.frame.size.height -216.0);
        }
        
    }
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        if (_orientation == UIDeviceOrientationPortrait) {//是竖屏
            self.view.frame =CGRectMake(0.0f, 0,self.view.frame.size.width,self.view.frame.size.height);//-offset 0.0f
        }else{
            self.view.frame =CGRectMake(0, 0.0f,self.view.frame.size.width,self.view.frame.size.height);//-offset 0.0f
        }
    
    [UIView commitAnimations];
    
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height);
}

//触摸view隐藏键盘——touchDown

- (IBAction)View_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//-(BOOL)shouldAutorotate
//{
//    return NO;
//}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
