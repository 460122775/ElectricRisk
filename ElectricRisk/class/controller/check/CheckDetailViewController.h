//
//  CheckDetailViewController.h
//  ElectricRisk
//
//  Created by yasin zhang on 16/9/5.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+MBProgressHUDView.h"

@interface CheckDetailViewController : UIViewController<UITextViewDelegate>{
    MBProgressHUD *HUD;
    NSDateFormatter *dtfrm;
    int currentLCValue;
    int currentKeyboardHeight;
    int agreeViewHeight;
}

@property (strong, nonatomic) NSDictionary *checkDataDic;
@property (strong, nonatomic) NSDictionary *checkDetailDataDic;

@property (strong, nonatomic) IBOutlet UIImageView *process_startImgView;
@property (strong, nonatomic) IBOutlet UIImageView *process_applyImgView;
@property (strong, nonatomic) IBOutlet UIImageView *process_spImgView;
@property (strong, nonatomic) IBOutlet UIImageView *process_yzImgView;
@property (strong, nonatomic) IBOutlet UIImageView *process_jgImgView;
@property (strong, nonatomic) IBOutlet UIImageView *process_overImgView;


@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *projectCdLabel;
@property (strong, nonatomic) IBOutlet UILabel *bsCompanyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *bsTimeLabel;

@property (strong, nonatomic) IBOutlet UIView *spContainerView;
@property (strong, nonatomic) IBOutlet UITextView *spContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spContentViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *spCompanyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *spTimeLabel;

@property (strong, nonatomic) IBOutlet UIView *yzContainerView;
@property (strong, nonatomic) IBOutlet UITextView *yzContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *yzContentViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *yzCompanyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *yzTimeLabel;

@property (strong, nonatomic) IBOutlet UIView *agreeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *agreeViewTopPadding;
@property (strong, nonatomic) IBOutlet UISwitch *agreeSwitch;
@property (strong, nonatomic) IBOutlet UITextView *agreeContentTextView;
@property (strong, nonatomic) IBOutlet UIButton *agreeSubmitBtn;
@property (strong, nonatomic) IBOutlet UIView *agreeEnableView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *checkContainerHeight;

- (IBAction)goBackBtnClick:(id)sender;

- (IBAction)agreeSubmitBtnClick:(id)sender;

- (IBAction)agreeSwitchChanged:(id)sender;

- (void)initViewWithData:(NSDictionary*)checkDataDic;

@end
