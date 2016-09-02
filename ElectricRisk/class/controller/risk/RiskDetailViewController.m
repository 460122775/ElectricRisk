//
//  RiskDetailViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "RiskDetailViewController.h"

@interface RiskDetailViewController ()

@end

@implementation RiskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewWithData:(NSDictionary*)dataDic
{
    self.riskDataDic = dataDic;
}

- (IBAction)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)writeBtnClick:(id)sender
{
    
}

- (IBAction)stopBtnClick:(id)sender
{
    
}

- (IBAction)dateBtnClick:(id)sender
{
    
}

@end
