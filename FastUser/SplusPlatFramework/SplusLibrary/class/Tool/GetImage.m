//
//  GetImage.m
//  YayawanIOS
//
//  Created by akzhang on 14-3-3.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "GetImage.h"

@implementation GetImage

+(UIImage *)imagesNamedFromCustomBundle:(NSString *)imgName
{
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"splus.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *img_path = [bundle pathForResource:imgName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:img_path];
}

+(UIImage *)getRectImage:(NSString *)imagName{
    UIEdgeInsets frameinsets = UIEdgeInsetsMake(35, 60, 60, 60);
    UIImage *tempImage = [[GetImage imagesNamedFromCustomBundle:imagName] resizableImageWithCapInsets:frameinsets resizingMode:UIImageResizingModeStretch];
    return tempImage;
}

+(UIImage *)getMiddleRectImage:(NSString *)imagName{
    UIEdgeInsets frameinsets = UIEdgeInsetsMake(44, 100, 9, 28);//30, 80, 80, 30   60, 60, 60, 30
    UIImage *tempImage = [[GetImage imagesNamedFromCustomBundle:imagName] resizableImageWithCapInsets:frameinsets resizingMode:UIImageResizingModeStretch];
    return tempImage;
}

+(UIImage *)getRightRectImage:(NSString *)imagName{
    UIEdgeInsets frameinsets = UIEdgeInsetsMake(44, 28, 9, 100);//30, 80, 80, 30   60, 60, 60, 30
    UIImage *tempImage = [[GetImage imagesNamedFromCustomBundle:imagName] resizableImageWithCapInsets:frameinsets resizingMode:UIImageResizingModeStretch];
    return tempImage;
}

+(UIImage *)getPayRectImage:(NSString *)imagName{
    UIEdgeInsets frameinsets = UIEdgeInsetsMake(10, 10, 35, 30);
    UIImage *tempImage = [[GetImage imagesNamedFromCustomBundle:imagName] resizableImageWithCapInsets:frameinsets resizingMode:UIImageResizingModeStretch];
    return tempImage;
}

+(UIImage *)getSmallRectImage:(NSString *)imagName{
    UIEdgeInsets frameinsets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *tempImage = [[GetImage imagesNamedFromCustomBundle:imagName] resizableImageWithCapInsets:frameinsets resizingMode:UIImageResizingModeStretch];
    return tempImage;
}

+(UIImage *)getFloatRectImage:(NSString *)imagName{
    UIEdgeInsets frameinsets = UIEdgeInsetsMake(0, 22, 0, 22);
    UIImage *tempImage = [[GetImage imagesNamedFromCustomBundle:imagName] resizableImageWithCapInsets:frameinsets resizingMode:UIImageResizingModeStretch];
    return tempImage;
}

+(void)getLoading:(UIView*)tempController Indicator:(UIActivityIndicatorView*)tempIndicatorView{
//    tempIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [tempIndicatorView setFrame:CGRectMake(tempController.frame.size.width*3/8, tempController.frame.size.height*3/8, tempController.frame.size.width/2, tempController.frame.size.height/2)];
    [tempController addSubview:tempIndicatorView];
    tempIndicatorView.color = [UIColor blackColor];
    [tempIndicatorView startAnimating]; // 开始旋转
}

static CGSize appScreenSize;
static UIInterfaceOrientation lastOrientation;

+(CGSize) screenSize{
    UIInterfaceOrientation orientation =[UIApplication sharedApplication].statusBarOrientation;
    if(appScreenSize.width==0 || lastOrientation != orientation){
        appScreenSize = CGSizeMake(0, 0);
        CGSize screenSize = [[UIScreen mainScreen] bounds].size; // 这里如果去掉状态栏，只要用applicationFrame即可。
        if(orientation == UIDeviceOrientationLandscapeLeft ||orientation == UIDeviceOrientationLandscapeRight){
            // 横屏，那么，返回的宽度就应该是系统给的高度。注意这里，全屏应用和非全屏应用，应该注意自己增减状态栏的高度。
            appScreenSize.width = screenSize.height;
            appScreenSize.height = screenSize.width;
        }else{
            appScreenSize.width = screenSize.width;
            appScreenSize.height = screenSize.height;
        }
        lastOrientation = orientation;
    }
    return appScreenSize;
}

//+(CGSize) offsetSize{
//    CGSize _offsetSize =CGSizeMake(0, 0);
//    
//    CGFloat screen_scale_x = (UI_DESIGN_WIDTH / UI_DESIGN_HEIGHT);
//    CGFloat screen_scale_y = (UI_SCREEN_WIDTH / UI_SCREEN_HEIGHT);
//    
//    if (screen_scale_x > screen_scale_y) {
//        _offsetSize.width = (UI_DESIGN_WIDTH - UI_SCREEN_WIDTH * UI_DESIGN_HEIGHT / UI_SCREEN_HEIGHT) * 0.5;
//    }else{
//        _offsetSize.height = (UI_DESIGN_HEIGHT - UI_SCREEN_HEIGHT * UI_DESIGN_WIDTH / UI_SCREEN_WIDTH) * 0.5;
//    }
//    return _offsetSize;
//}

@end
