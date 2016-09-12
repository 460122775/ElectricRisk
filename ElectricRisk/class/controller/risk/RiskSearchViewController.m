//
//  RiskSearchViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "RiskSearchViewController.h"

@interface RiskSearchViewController ()

@end

@implementation RiskSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.areaNameTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewWithData:(NSArray*) projectArray
{
    self.projectArray = projectArray;
}

- (IBAction)goBackBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chooseProjectBtnClick:(id)sender
{
    RiskProjectChooseViewController *riskProjectChooseViewController = [[RiskProjectChooseViewController alloc] initWithNibName:@"RiskProjectChooseViewController" bundle:nil];
    riskProjectChooseViewController.modalPresentationStyle = UIModalPresentationCustom;
    riskProjectChooseViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    riskProjectChooseViewController.delegate = self;
    [riskProjectChooseViewController initViewWithData:self.projectArray];
    [self presentViewController:riskProjectChooseViewController animated:YES completion:nil];
}

-(void)projectChooseControl:(NSDictionary*)project
{
    self.currentProject = project;
    [self.chooseProjectBtn setTitle:[project objectForKey:@"name"] forState:UIControlStateNormal];
}

- (IBAction)startBtnClick:(id)sender
{
    RiskClassChooseViewController *riskClassChooseViewController = [[RiskClassChooseViewController alloc] initWithNibName:@"RiskClassChooseViewController" bundle:nil];
    riskClassChooseViewController.modalPresentationStyle = UIModalPresentationCustom;
    riskClassChooseViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    riskClassChooseViewController.delegate = self;
    [riskClassChooseViewController initViewWithStart:YES];
    [self presentViewController:riskClassChooseViewController animated:YES completion:nil];
}

- (IBAction)endClassBtnClick:(id)sender
{
    RiskClassChooseViewController *riskClassChooseViewController = [[RiskClassChooseViewController alloc] initWithNibName:@"RiskClassChooseViewController" bundle:nil];
    riskClassChooseViewController.modalPresentationStyle = UIModalPresentationCustom;
    riskClassChooseViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    riskClassChooseViewController.delegate = self;
    [riskClassChooseViewController initViewWithStart:NO];
    [self presentViewController:riskClassChooseViewController animated:YES completion:nil];
}

-(void)riskClassChooseControl:(int)classValue withStart:(BOOL)isStart
{
    if (isStart)
    {
        self.startClassBtn.tag = classValue;
        self.startClass = [NSString stringWithFormat:@"%i", classValue];
        switch (classValue)
        {
            case 4: [self.startClassBtn setTitle:@"重要3级" forState:UIControlStateNormal]; break;
            case 5: [self.startClassBtn setTitle:@"4级" forState:UIControlStateNormal]; break;
            case 6: [self.startClassBtn setTitle:@"5级" forState:UIControlStateNormal]; break;
            default: [self.startClassBtn setTitle:[NSString stringWithFormat:@"%i级", classValue] forState:UIControlStateNormal]; break;
        }
    }else{
        self.endClassBtn.tag = classValue;
        self.endClass = [NSString stringWithFormat:@"%i", classValue];
        switch (classValue)
        {
            case 4: [self.endClassBtn setTitle:@"重要3级" forState:UIControlStateNormal]; break;
            case 5: [self.endClassBtn setTitle:@"4级" forState:UIControlStateNormal]; break;
            case 6: [self.endClassBtn setTitle:@"5级" forState:UIControlStateNormal]; break;
            default: [self.endClassBtn setTitle:[NSString stringWithFormat:@"%i级", classValue] forState:UIControlStateNormal]; break;
        }
    }
}

- (IBAction)resetBtnClick:(id)sender
{
    self.currentProject = nil;
    [self.chooseProjectBtn setTitle:@"选择项目" forState:UIControlStateNormal];
    self.startClass = @"";
    self.startClassBtn.tag = 0;
    [self.startClassBtn setTitle:@"选择等级" forState:UIControlStateNormal];
    self.endClass = @"";
    self.endClassBtn.tag = 0;
    [self.endClassBtn setTitle:@"选择等级" forState:UIControlStateNormal];
    self.areaNameTextField.text = @"";
}

- (IBAction)searchBtnClick:(id)sender
{
    if (self.startClassBtn.tag >= self.endClassBtn.tag && self.startClassBtn.tag != 0)
    {
        [[JTToast toastWithText:@"项目等级的顺序应从低到高" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }
    if (self.delegate != nil)
    {
        [self.delegate riskSearchWithArea:self.areaNameTextField.text
                             andProjectid:[NSString stringWithFormat:@"%@", (self.currentProject == nil)?@"":[self.currentProject objectForKey:@"id"]]
                                andSLevel:self.startClass
                              andEndLevel:self.endClass];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.areaNameTextField isFirstResponder])
    {
        [self.areaNameTextField resignFirstResponder];
    }
    return YES;
}

@end
