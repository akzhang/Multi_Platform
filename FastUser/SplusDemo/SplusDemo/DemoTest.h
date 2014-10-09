//
//  DemoTest.h
//  SplusDemo
//
//  Created by akzhang on 14-6-18.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoTest : UIViewController<UITextFieldDelegate>

@property(nonatomic, strong)IBOutlet UIView *splusDemoView;//背景

@property(nonatomic, strong)IBOutlet UIButton *splusLoginDemo;//登录

@property(nonatomic, strong)IBOutlet UIButton *splusPayDemo;//支付

@property(nonatomic, strong)IBOutlet UIButton *splusAcountMember;//个人中心

@property(nonatomic, strong)IBOutlet UIButton *splusActivate;//激活

@property(nonatomic, strong)UITextField *splusCashTextField;

@property(nonatomic, strong)UIButton *splusQuotaPay;//定额支付

@property(nonatomic, strong)UIButton *splusLoginOut;//注销

@property(nonatomic, assign)UIInterfaceOrientation orientation;

@property(nonatomic, strong)UIButton *splusHideToolBar;//是否隐藏悬浮窗

-(void)initLoginView;

@end
