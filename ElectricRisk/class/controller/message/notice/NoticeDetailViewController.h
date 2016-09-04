//
//  NoticeDetailViewController.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/5/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSDictionary *noticeDataDic;
@property (strong, nonatomic) NSArray* commentArray;

@property (strong, nonatomic) IBOutlet UILabel *noticeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewHeight;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong, nonatomic) IBOutlet UITextField *commentInput;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;

- (IBAction)commentBtnClick:(id)sender;
- (IBAction)goBackBtnClick:(id)sender;

- (void)initViewWithData:(NSDictionary*)dataDic;

@end
