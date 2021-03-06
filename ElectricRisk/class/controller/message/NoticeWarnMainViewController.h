//
//  NoticeWarnMainViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/2/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMainListCell.h"
#import "WarnMainListCell.h"
#import "NoticeDetailViewController.h"
#import "NoticeAddViewController.h"
#import "WarnModifyViewController.h"
#import "WarnDetailViewController.h"
#import "MJRefresh.h"
#import "CommonVC.h"

@interface NoticeWarnMainViewController : CommonVC<UITableViewDelegate, UITableViewDataSource, NoticeAddDelegate, WarnModifyDelegate, MJRefreshBaseViewDelegate>{
    BOOL isNoticeList;
    MBProgressHUD *HUD;
    int currentPage;
    
    NSMutableArray* noticeDataArray;
    NSArray* warnDataArray;
    
    NSDictionary* currentSelectedNotice;
    NSDictionary* currentSelectedWarn;
}

@property (strong, nonatomic) MJRefreshHeaderView *header;
@property (strong, nonatomic) MJRefreshFooterView *footer;

@property (strong, nonatomic) IBOutlet UIButton *noticeBtn;
@property (strong, nonatomic) IBOutlet UIButton *warnBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *underLineLeading;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UIButton *myNoticeBtn;

- (IBAction)noticeBtnClick:(id)sender;

- (IBAction)warnBtnClick:(id)sender;

- (IBAction)myNoticeBtnClick:(id)sender;

- (IBAction)writeBtnClick:(id)sender;

@end
