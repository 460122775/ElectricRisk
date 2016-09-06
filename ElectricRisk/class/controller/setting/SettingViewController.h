//
//  SettingViewController.h
//  ElectricRisk
//
//  Created by yasin zhang on 16/9/2.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModifyPwdViewController.h"

@interface SettingViewController : UIViewController<ModifyPwdDelegate>{
    MBProgressHUD *HUD;
}

- (IBAction)updatePwdBtnClick:(id)sender;

- (IBAction)updateBtnClick:(id)sender;

- (IBAction)aboutBtnClick:(id)sender;

- (IBAction)logoutBtnClick:(id)sender;

@end
