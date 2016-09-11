//
//  WarnDetailViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/4/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "WarnDetailViewController.h"

@interface WarnDetailViewController ()

@end

@implementation WarnDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initViewWithData:self.dataDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewWithData:(NSDictionary*) dataDic
{
    self.dataDic = dataDic;
    if (self.classLb == nil) return;
    self.projectNameLb.text = [dataDic objectForKey:@"name"];
    self.contentLb.text = [dataDic objectForKey:@"content"];
    self.classLb.text = [NSString stringWithFormat:@"%i级", [(NSNumber*)[dataDic objectForKey:@"level"] intValue]];
    self.addressLb.text = [dataDic objectForKey:@"address"];
    NSDate *sdate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[dataDic objectForKey:@"plan_start_time"] doubleValue] / 1000.0)];
    self.startTimeLb.text = [dtfrm stringFromDate:sdate];
    NSDate *edate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[dataDic objectForKey:@"plan_end_time"] doubleValue] / 1000.0)];
    self.endTimeLb.text = [dtfrm stringFromDate:edate];
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
