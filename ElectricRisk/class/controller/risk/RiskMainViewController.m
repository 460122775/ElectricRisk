//
//  RiskMainViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "RiskMainViewController.h"

@interface RiskMainViewController ()

@end

@implementation RiskMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchBtnClick:(id)sender
{
    RiskSearchViewController *riskSearchViewController = [[RiskSearchViewController alloc] initWithNibName:@"RiskSearchViewController" bundle:nil];
    riskSearchViewController.modalPresentationStyle = UIModalPresentationCustom;
    riskSearchViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:riskSearchViewController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
