//
//  LoginTimeOutManager.h
//  TimeOutDemo
//
//  Created by 魏翔 on 2017/11/3.
//  Copyright © 2017年 魏翔. All rights reserved.
//

//#import <QuartzCore/QuartzCore.h>

@interface LoginTimeOutManager :NSObject

singleton_interface(LoginTimeOutManager)

-(void)cancelCount;

-(void)startCount;

@end
