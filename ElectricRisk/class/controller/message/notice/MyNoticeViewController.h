//
//  MyNoticeViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/5/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMainListCell.h"
#import "NoticeDetailViewController.h"

@interface MyNoticeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    MBProgressHUD *HUD;
    NSDictionary* currentSelectedNotice;
}

@property (strong, nonatomic) NSArray *noticeArray;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)goBackBtnClick:(id)sender;

@end
