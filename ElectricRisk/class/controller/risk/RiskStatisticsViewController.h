//
//  RiskStatisticsViewController.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/12/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarChartView.h"
#import "MBProgressHUD+MBProgressHUDView.h"
#import "CommonVC.h"

@interface RiskStatisticsViewController : CommonVC{
    MBProgressHUD *HUD;
    NSMutableDictionary *dataDic;
    
    int level3Count;
    int level4Count;
    NSArray *type3Arr;
    NSArray *type4Arr;
}

@property (strong, nonatomic) IBOutlet UILabel *type3Label;
@property (strong, nonatomic) IBOutlet BarChartView *type3ChartView;

@property (strong, nonatomic) IBOutlet UILabel *type4Label;
@property (strong, nonatomic) IBOutlet BarChartView *type4ChartView;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

- (IBAction)backBtnClick:(id)sender;

@end
