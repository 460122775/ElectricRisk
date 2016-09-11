//
//  RiskStatisticsViewController.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/12/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskStatisticsViewController : UIViewController{
    MBProgressHUD *HUD;
    NSMutableDictionary *dataDic;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

- (IBAction)backBtnClick:(id)sender;

@end
