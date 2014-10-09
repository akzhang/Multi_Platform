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
    [[SplusInterfaceKit sharedInstance] setApp:[dictionary objectForKey:@"GameID"] GameKey:[dictionary objectForKey:@"GameKey"] SourceID:[dictionary objectForKey:@"SourceID"] PartnerID:[dictionary objectForKey:@"PartnerGameID"] PartnerKey:[dictionary objectForKey:@"PartnerKey"]];
    [[SplusInterfaceKit sharedInstance] setPlayerInfo:@"1111" serverName:@"湖南一区" RoleId:@"2222" RoleName:@"ak我杀猪" OutOrderId:@"外部订单号ID" Pext:@"扩展ext"];
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
}

/**
 *  非定额支付
 *
 *  @param sender sender
 */
-(void)splusStartPayClick:(id)sender
{
    [[SplusInterfaceKit sharedInstance] splusPay:@"0"];
}


//定额支付
-(void)splusQuotaPay:(id)sender
{
    if (_splusCashTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"%@请输入充值金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSLog(@"money = %@",_splusCashTextField.text);
    [[SplusInterfaceKit sharedInstance] splusQuotaPay:_splusCashTextField.text Type:@"1"];
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
    [[SplusInterfaceKit sharedInstance] initSplus];
}

///注销成功回调
-(void)SplusLoginOutSuccess
{
    [[SplusInterfaceKit sharedInstance] splusLogin];
}

-(void)SplusLoginOnCancle
{
    [self showMessage:@"取消登录"];
}

-(void)SPlusAcountOnSuccess
{
    [self showMessage:@"个人中心"];
}

-(void)SplusAcountOnCancle
{
    [self showMessage:@"退出个人中心"];
    
}

-(void)SplusPayOnSuccess:(id)sender
{

    [self showMessage:@"支付成功"];
}

-(void)SplusPayOnCancle
{
    [self showMessage:@"支付取消"];
}

-(void)SplusClosePage
{
    [self showMessage:@"关闭SDK界面"];
}

-(void)showMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];

}


-(void)SplusLoginOnSuccess:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
