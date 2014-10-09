//
//  SplusImage.h
//  SplusIosSdk
//
//  Created by akzhang on 14-6-17.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define CurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface SplusImage : NSObject

-(UIImage *)HandlingPicturesWithPic:(UIImage *)AImage TopWidth:(CGFloat)ATopWidth LeftWidth:(CGFloat)ALeftWidth BelowWidth:(CGFloat)ABelowWidth RightWidth:(CGFloat)ARightWidth;

@end
