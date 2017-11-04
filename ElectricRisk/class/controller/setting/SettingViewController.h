//
//  SettingViewController.h
//  ElectricRisk
//
//  Created by yasin zhang on 16/9/2.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModifyPwdViewController.h"
#import "MBProgressHUD+MBProgressHUDView.h"
#import "CommonVC.h"

@interface SettingViewController : CommonVC<ModifyPwdDelegate>{
    MBProgressHUD *HUD;
}

- (IBAction)updatePwdBtnClick:(id)sender;

- (IBAction)updateBtnClick:(id)sender;

- (IBAction)aboutBtnClick:(id)sender;

- (IBAction)logoutBtnClick:(id)sender;

@end
