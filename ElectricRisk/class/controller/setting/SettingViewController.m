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
    if (OFFLINE)
    {
        [self testUpdateData];
    }else{
        [self requestUpdateData];
    }
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

-(void)testUpdateData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"version\":\"1.2.0\", \"uri\":\"itms-services://?action=download-manifest&url=https://phone16.trsd001.com/testapp/manifest.plist\", \"state\": 0}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        [[JTToast toastWithText:@"已经是最新版本了" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请确认" message:[NSString stringWithFormat:@"发现新版本:%@，确认要更新吗？", [result objectForKey:@"version"]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
             {
                 [alert dismissViewControllerAnimated:YES completion:nil];
                 NSURL *url = [NSURL URLWithString:[result objectForKey:@"uri"]];
                 if(url != nil) [[UIApplication sharedApplication] openURL:url];
             }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
             {
                 [alert dismissViewControllerAnimated:YES completion:nil];
             }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)requestUpdateData
{
    if (HUD == nil)
    {
        HUD = [[MBProgressHUD alloc]init];
    }
    [self.view addSubview:HUD];
    HUD.dimBackground =YES;
    HUD.labelText = @"正在检查更新...";
    [HUD removeFromSuperViewOnHide];
    [HUD showByCustomView:YES];
    
    NSDictionary *dict = @{@"c_time":[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000],
                           @"version":VERSION,
                           @"os":@"ios"};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_REPORTDETAIL) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [[JTToast toastWithText:@"已经是最新版本了" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请确认" message:[NSString stringWithFormat:@"发现新版本:%@，确认要更新吗？", [result objectForKey:@"version"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     NSURL *url = [NSURL URLWithString:[result objectForKey:@"uri"]];
                                     if(url != nil) [[UIApplication sharedApplication] openURL:url];
                                 }];
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

-(void)modifyPwdSuccess
{
    [self clearUserData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clearUserData
{
    [SystemConfig instance].currentUserId = nil;
    [SystemConfig instance].currentUserPwd = nil;
    [SystemConfig instance].currentUserName = nil;
    [SystemConfig instance].currentUserRole = -1;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserRole"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserPwd"];
}

@end
