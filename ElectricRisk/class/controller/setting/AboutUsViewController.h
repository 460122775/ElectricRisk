//
//  AboutUsViewController
//  ElectricRisk
//
//  Created by yasin zhang on 16/9/2.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutUsViewController.h"
#import "CommonVC.h"

@interface AboutUsViewController : CommonVC

@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@property (strong, nonatomic) IBOutlet UILabel *phoneCdLabel;

- (IBAction)goBackBtnClick:(id)sender;

@end
