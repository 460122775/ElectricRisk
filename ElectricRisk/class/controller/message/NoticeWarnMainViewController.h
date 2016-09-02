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

@interface NoticeWarnMainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    BOOL isNoticeList;
    MBProgressHUD *HUD;
    
    NSArray* noticeDataArray;
    NSArray* warnDataArray;
}

@property (strong, nonatomic) IBOutlet UIButton *noticeBtn;
@property (strong, nonatomic) IBOutlet UIButton *warnBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *underLineLeading;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)noticeBtnClick:(id)sender;

- (IBAction)warnBtnClick:(id)sender;

- (IBAction)searchBtnClick:(id)sender;

@end
