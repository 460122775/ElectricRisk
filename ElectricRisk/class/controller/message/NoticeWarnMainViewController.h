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

@interface NoticeWarnMainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NoticeAddDelegate>{
    BOOL isNoticeList;
    MBProgressHUD *HUD;
    
    NSArray* noticeDataArray;
    NSArray* warnDataArray;
    
    NSDictionary* currentSelectedNotice;
    NSDictionary* currentSelectedWarn;
}

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
