//
//  InpuPwdViewController.m
//  ElectricRisk
//
//  Created by 魏翔 on 2017/11/5.
//  Copyright © 2017年 com.yasin.electric. All rights reserved.
//

#import "InputPwdViewController.h"

@interface InputPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@end

@implementation InputPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView
{
    self.userNameTF.userInteractionEnabled = NO;
}

- (IBAction)didClickCommit:(id)sender
{
    NSString *inputPwdStr = self.pwdTF.text;
    if([inputPwdStr isEqualToString: @""])
    {
        [[JTToast toastWithText: @"请输入登录密码" configuration: [JTToastConfiguration defaultConfiguration]] show];
    }else {
        if (![[SystemConfig instance].currentUserPwd isEqualToString: inputPwdStr])
        {
            [[JTToast toastWithText: @"登录密码不正确，请重新输入" configuration: [JTToastConfiguration defaultConfiguration]] show];
            self.pwdTF.text = @"";
        } else {
            [self dismissViewControllerAnimated: YES completion: nil];
        }
    }
}

@end
