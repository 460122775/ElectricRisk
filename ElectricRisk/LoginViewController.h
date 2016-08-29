//
//  LoginViewController.h
//  ElectricRisk
//
//  Created by Yachen Dai on 8/26/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMBase64.h"

@interface LoginViewController : UIViewController{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *pwdTF;

- (IBAction)loginBtnClick:(id)sender;

@end

