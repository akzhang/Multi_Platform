//
//  SplusCallback.h
//  SplusMutiPlat
//
//  Created by akzhang on 14-7-22.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SplusCallback <NSObject>

-(void)SplusActivateOnSuccess;

-(void)SplusLoginOnSuccess:(id)sender;

-(void)SplusLoginOnCancle;

-(void)SplusClosePage;

-(void)SPlusAcountOnSuccess;

-(void)SplusAcountOnCancle;

-(void)SplusPayOnSuccess:(id)sender;

-(void)SplusPayOnCancle;

-(void)SplusLogOutOnSuccess;

@end
