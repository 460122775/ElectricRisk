//
//  ModifyPwdViewController.h
//  ElectricRisk
//
//  Created by yasin zhang on 16/9/2.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+MBProgressHUDView.h"
#import "CommonVC.h"

@protocol ModifyPwdDelegate <NSObject>

-(void)modifyPwdSuccess;

@end

@interface ModifyPwdViewController : CommonVC<UITextFieldDelegate>{
    MBProgressHUD *HUD;
}

@property (assign, nonatomic) id<ModifyPwdDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwdNewTextField1;
@property (strong, nonatomic) IBOutlet UITextField *pwdNewTextField2;

- (IBAction)goBackBtnClick:(id)sender;

- (IBAction)saveBtnClick:(id)sender;

@end
