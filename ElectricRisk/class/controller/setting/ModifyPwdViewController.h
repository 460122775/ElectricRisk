//
//  ModifyPwdViewController.h
//  ElectricRisk
//
//  Created by yasin zhang on 16/9/2.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPwdViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwdNewTextField1;
@property (strong, nonatomic) IBOutlet UITextField *pwdNewTextField2;

- (IBAction)goBackBtnClick:(id)sender;

- (IBAction)logoutBtnClick:(id)sender;

@end
