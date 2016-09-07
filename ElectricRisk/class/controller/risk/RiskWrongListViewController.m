//
//  RiskExecutiveTimeListViewController.m
//  ElectricRisk
//
//  Created by Yachen Dai on 9/4/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "RiskWrongListViewController.h"

@interface RiskWrongListViewController ()

@end

@implementation RiskWrongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initViewWithData:self.wrongDataArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewWithData:(NSArray*) wrongDataArray
{
    self.wrongDataArray = wrongDataArray;
    if (self.tableView == nil) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.wrongDataArray == nil) return 0;
    return self.wrongDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RiskExecutiveTimeCell = @"RiskExecutiveTimeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RiskExecutiveTimeCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: RiskExecutiveTimeCell];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [(NSDictionary*)[self.wrongDataArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.delegate != nil)
    {
        [self.delegate wrongListChooseControl:[self.wrongDataArray objectAtIndex:indexPath.row]];
    }
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
