//
//  LoginTimeOutManager.m
//  TimeOutDemo
//
//  Created by 魏翔 on 2017/11/3.
//  Copyright © 2017年 魏翔. All rights reserved.
//

#import "LoginTimeOutManager.h"

#define LoginTimeOutTime 108000 //30分钟 按照屏幕刷新帧率来计算 1s = 60帧

@interface LoginTimeOutManager()

@property (nonatomic,strong) CADisplayLink *displayLink;

@end

@implementation LoginTimeOutManager

singleton_implementation(LoginTimeOutManager)

-(void)cancelCount
{
    [self.displayLink invalidate];
    self.displayLink = nil;
    _number = 0;
}

-(void)startCount
{
    [self cancelCount];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)handleDisplayLink
{
    if(!self.displayLink) return;
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    dispatch_async(q, ^{
        _number++;
        if(self.number % 60 == 0)
        {
            NSLog(@"time %d",self.number / 60);
        }
        if(self.number > LoginTimeOutTime)
        {
            NSLog(@"登录超时:%d分",self.number / LoginTimeOutTime);
            [self cancelCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginTimeOutNotification object: nil];
            });
        }
    });
}
@end
