//
//  SplusImage.m
//  SplusIosSdk
//
//  Created by akzhang on 14-6-17.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "SplusImage.h"

@implementation SplusImage

//自动处理拉升或者缩放图片纹理
-(UIImage *)HandlingPicturesWithPic:(UIImage *)AImage TopWidth:(CGFloat)ATopWidth LeftWidth:(CGFloat)ALeftWidth BelowWidth:(CGFloat)ABelowWidth RightWidth:(CGFloat)ARightWidth
{
    UIImage *ANewImage;
    if (CurrentSystemVersion >= 5.0)
    {
        ANewImage = [AImage resizableImageWithCapInsets:UIEdgeInsetsMake(ATopWidth, ALeftWidth, ABelowWidth, ARightWidth)];
    }
    else
    {
        ANewImage=[AImage stretchableImageWithLeftCapWidth:ATopWidth topCapHeight:ALeftWidth];
    }
    return ANewImage;
}

@end
