//
//  NoticeDetailViewController.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/5/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+MBProgressHUDView.h"

@interface NoticeDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIWebViewDelegate>{
    MBProgressHUD *HUD;
    int currentKeyboardHeight;
}

@property (strong, nonatomic) NSDictionary *noticeDataDic;
@property (assign, nonatomic) BOOL canReply;
@property (strong, nonatomic) NSArray* commentArray;

@property (strong, nonatomic) IBOutlet UILabel *noticeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentWebViewHeight;
@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong, nonatomic) IBOutlet UITextField *commentInput;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;

@property (strong, nonatomic) IBOutlet UIView *commentView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentBottomPadding;

- (IBAction)commentBtnClick:(id)sender;
- (IBAction)goBackBtnClick:(id)sender;

- (void)initViewWithData:(NSDictionary*)noticeDataDic withReply:(BOOL)canReplay;

@end
