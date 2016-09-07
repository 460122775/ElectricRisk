//
//  RiskProjectChooseViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/4/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "RiskProjectChooseViewController.h"

@interface RiskProjectChooseViewController ()

@end

@implementation RiskProjectChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initViewWithData:self.projectArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewWithData:(NSArray*) projectArray
{
    self.projectArray = projectArray;
    if (self.tableView == nil) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.projectArray == nil) return 0;
    return self.projectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RiskProjectCell = @"RiskProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RiskProjectCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: RiskProjectCell];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [(NSDictionary*)[self.projectArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.delegate != nil)
    {
        [self.delegate projectChooseControl:(NSDictionary*)[self.projectArray objectAtIndex:indexPath.row]];
    }
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
