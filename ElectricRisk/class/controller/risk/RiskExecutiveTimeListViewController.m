//
//  RiskExecutiveTimeListViewController.m
//  ElectricRisk
//
//  Created by Yachen Dai on 9/4/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "RiskExecutiveTimeListViewController.h"

@interface RiskExecutiveTimeListViewController ()

@end

@implementation RiskExecutiveTimeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timeTableView.delegate = self;
    self.timeTableView.dataSource = self;
    
    dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"yyyy-MM-dd"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initViewWithData:self.timeArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewWithData:(NSArray*) timeArray
{
    self.timeArray = timeArray;
    if (self.timeTableView == nil) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.timeTableView reloadData];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.timeArray == nil) return 0;
    return self.timeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RiskExecutiveTimeCell = @"RiskExecutiveTimeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RiskExecutiveTimeCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: RiskExecutiveTimeCell];
    }
    NSDate *executiveTimeDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[(NSDictionary*)[self.timeArray objectAtIndex:indexPath.row] objectForKey:@"creat_time"] doubleValue] / 1000.0)];
    cell.textLabel.text = [dtfrm stringFromDate:executiveTimeDate];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.delegate != nil)
    {
        [self.delegate timeChooseControl:[(NSNumber*)[(NSDictionary*)[self.timeArray objectAtIndex:indexPath.row] objectForKey:@"creat_time"] doubleValue]];
    }
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
