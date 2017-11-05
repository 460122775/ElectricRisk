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
    [self dismissViewControllerAnimated: YES completion: nil];
}

@end
