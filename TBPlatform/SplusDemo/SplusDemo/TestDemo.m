//
//  TestDemo.m
//  SplusDemo
//
//  Created by akzhang on 14-6-12.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "TestDemo.h"
#import <SplusIosSdk/hero.h>

@interface TestDemo ()

@end

@implementation TestDemo

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testClick:(id)sender {
//    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"splus" withExtension:@"bundle"]];
    
    hero *testHero = [[hero alloc] initWithNibName:@"hero" bundle:nil];
    [self.navigationController pushViewController:testHero animated:YES];
    
}
@end
