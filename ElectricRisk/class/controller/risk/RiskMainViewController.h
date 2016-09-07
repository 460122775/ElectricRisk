//
//  RiskMainViewController.h
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskSearchViewController.h"
#import "RiskDetailViewController.h"
#import "RiskMainListCell.h"

@interface RiskMainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RishSearchDelegate>{
    MBProgressHUD *HUD;
    NSArray *totalDataArray;
    NSMutableArray *headerNameArray;
    NSMutableDictionary *dataDic;
    NSArray* projectArray;
    
    NSDictionary* selectedDataDic;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
