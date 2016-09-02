//
//  SettingViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/9/2.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updatePwdBtnClick:(id)sender
{
    [self performSegueWithIdentifier:@"ToModifyPwd" sender:self];
}

- (IBAction)updateBtnClick:(id)sender
{
    
}

- (IBAction)aboutBtnClick:(id)sender
{
    [self performSegueWithIdentifier:@"ToAboutUs" sender:self];
}

- (IBAction)logoutBtnClick:(id)sender
{
    
}

@end
