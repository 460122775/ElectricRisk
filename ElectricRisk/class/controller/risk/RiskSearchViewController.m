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
    
    classArray = @[@{@"name":@"1级", @"value":@"1"},
                   @{@"name":@"2级", @"value":@"2"},
                   @{@"name":@"3级", @"value":@"3"},
                   @{@"name":@"重要3级", @"value":@"4"},
                   @{@"name":@"4级", @"value":@"5"},
                   @{@"name":@"5级", @"value":@"6"}];
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
        for (int i = 0; i < classArray.count; i++)
        {
            if ([[[classArray objectAtIndex:i] objectForKey:@"value"]
                 isEqualToString:[NSString stringWithFormat:@"%i", classValue]])
            {
                startIndex = i;
                [self.startClassBtn setTitle:[[classArray objectAtIndex:i] objectForKey:@"name"] forState:UIControlStateNormal];
                break;
            }
        }
    }else{
        self.endClassBtn.tag = classValue;
        self.endClass = [NSString stringWithFormat:@"%i", classValue];
        for (int i = 0; i < classArray.count; i++)
        {
            if ([[[classArray objectAtIndex:i] objectForKey:@"value"]
                 isEqualToString:[NSString stringWithFormat:@"%i", classValue]])
            {
                endIndex = i;
                [self.endClassBtn setTitle:[[classArray objectAtIndex:i] objectForKey:@"name"] forState:UIControlStateNormal];
                break;
            }
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
    if (startIndex > endIndex || self.startClassBtn.tag == 0)
    {
        [[JTToast toastWithText:@"项目等级的顺序应从低到高" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }
    if (self.delegate != nil)
    {
        [self.delegate riskSearchWithArea:self.areaNameTextField.text
                             andProjectid:[NSString stringWithFormat:@"%@", (self.currentProject == nil)?@"":[self.currentProject objectForKey:@"projectid"]]
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
