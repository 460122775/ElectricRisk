//
//  RiskClassChooseViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/4/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "RiskClassChooseViewController.h"

@interface RiskClassChooseViewController ()

@end

@implementation RiskClassChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewWithStart:(BOOL)_isStart
{
    isStart = _isStart;
}

- (IBAction)classBtnClick:(UIButton*)sender
{
    if (self.delegate != nil) [self.delegate riskClassChooseControl:(int)(sender.tag) withStart:isStart];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
