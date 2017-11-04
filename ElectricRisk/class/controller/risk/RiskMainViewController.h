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
#import "MJRefresh.h"
#import "CommonVC.h"

@interface RiskMainViewController : CommonVC<UITableViewDelegate, UITableViewDataSource, RishSearchDelegate, MJRefreshBaseViewDelegate>{
    MBProgressHUD *HUD;
    NSMutableArray *totalDataArray;
    NSMutableArray *headerNameArray;
    NSMutableDictionary *dataDic;
    NSArray* projectArray;
    
    NSDictionary* selectedDataDic;
    
    RiskSearchViewController *riskSearchViewController;
}

@property (strong, nonatomic) MJRefreshHeaderView *header;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)statisticsBtnClick:(id)sender;

@end
