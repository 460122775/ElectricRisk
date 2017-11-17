//
//  CommonVC.m
//  ElectricRisk
//
//  Created by 魏翔 on 2017/11/3.
//  Copyright © 2017年 com.yasin.electric. All rights reserved.
//

#import "CommonVC.h"
#import "LoginViewController.h"
#import "InputPwdViewController.h"
#import "LogOutModal.h"


@implementation CommonVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(logOut) name:LoginTimeOutNotification object: nil];
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(inputPwd) name:InputPwdNotification object: nil];
}

-(void)logOut
{
    [LogOutModal logOut];
    [[JTToast toastWithText:@"当前会话已超时,请重新登录" configuration:[JTToastConfiguration defaultConfiguration]]show];
    LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle: nil] instantiateViewControllerWithIdentifier: @"LoginViewController"];
    [self presentViewController: loginVC animated: YES completion: nil];
}

//-(void)inputPwd
//{
//  InputPwdViewController *inputVC = [[InputPwdViewController alloc] initWithNibName: @"InputPwdViewController" bundle: nil];
//  [self presentViewController:inputVC animated: YES completion: nil];
//}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
