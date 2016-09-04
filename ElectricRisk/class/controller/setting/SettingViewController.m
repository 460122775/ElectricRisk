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
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请确认" message:@"确定要注销当前用户吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self clearUserData];
                            [self dismissViewControllerAnimated:YES completion:nil];
                         }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ToModifyPwd"])
    {
        ModifyPwdViewController *modifyPwdViewController = [segue destinationViewController];
        modifyPwdViewController.delegate = self;
    }
}

-(void)modifyPwdSuccess
{
    [self clearUserData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clearUserData
{
    [SystemConfig instance].currentUserId = -1;
    [SystemConfig instance].currentUserPwd = nil;
    [SystemConfig instance].currentUserName = nil;
    [SystemConfig instance].currentUserRole = -1;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserRole"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserPwd"];
}

@end
