//
//  LoginViewController.h
//  ElectricRisk
//
//  Created by Yachen Dai on 8/26/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMBase64.h"
#import "MBProgressHUD+MBProgressHUDView.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *pwdTF;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)loginBtnClick:(id)sender;

@end

