//
//  GetImage.h
//  YayawanIOS
//
//  Created by akzhang on 14-3-3.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GetImage : NSObject

+(UIImage *)imagesNamedFromCustomBundle:(NSString *)imgName;

+(UIImage *)getRectImage:(NSString *)imagName;

+(UIImage *)getMiddleRectImage:(NSString *)imagName;

+(UIImage *)getSmallRectImage:(NSString *)imagName;

+(UIImage *)getRightRectImage:(NSString *)imagName;

+(UIImage *)getPayRectImage:(NSString *)imagName;

+(UIImage *)getFloatRectImage:(NSString *)imagName;

+(void)getLoading:(UIView*)tempController Indicator:(UIActivityIndicatorView*)tempIndicatorView;

+(CGSize) screenSize;

+(CGSize) offsetSize;

@end
