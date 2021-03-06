//
//  RiskDetailViewController.h
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskExecutiveTimeListViewController.h"
#import "RiskAddViewController.h"
#import "MBProgressHUD+MBProgressHUDView.h"
#import "CommonVC.h"

@interface RiskDetailViewController :CommonVC<UIWebViewDelegate, RiskExecutiveTimeChooseDelegate, RiskAddDelegate>{
    NSDateFormatter *dtfrm;
    MBProgressHUD *HUD;
    float currentProcess;
}

@property (strong, nonatomic) NSDictionary *riskDataDic;
@property (strong, nonatomic) NSDictionary *riskDetailDataDic;
@property (strong, nonatomic) NSArray *riskExecutiveTimeArray;
@property (strong, nonatomic) NSDictionary *riskExecutiveDataDic;
@property (strong, nonatomic) NSString *repairInfoJsonString;

@property (strong, nonatomic) IBOutlet UIButton *writeBtn;
@property (strong, nonatomic) IBOutlet UIButton *stopBtn;
@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *dateBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sgPersonInfoContainerHeightCons;
@property (strong, nonatomic) IBOutlet UIWebView *sgpersonInfoWebView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sgPersonInfoWebViewHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *jlPersonInfoContainerHeightCons;
@property (strong, nonatomic) IBOutlet UIWebView *jlPersonInfoWebView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *jlPersonInfoWebViewHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *yzPersonInfoContainerHeightCons;
@property (strong, nonatomic) IBOutlet UIWebView *yzPersonInfoWebView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *yzPersonInfoWebViewHeight;

@property (strong, nonatomic) IBOutlet UIWebView *executiveInfoWebView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *executiveInfoWebViewHeight;
@property (strong, nonatomic) IBOutlet UIWebView *repairInfoWebView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *repairInfoWebViewHeight;
@property (strong, nonatomic) IBOutlet UIWebView *processInfoWebView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *processInfoWebViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *sgProcessLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *sgProcessView;


- (IBAction)backBtnClick:(id)sender;

- (IBAction)writeBtnClick:(id)sender;

- (IBAction)stopBtnClick:(id)sender;

- (IBAction)dateBtnClick:(id)sender;

- (void)initViewWithData:(NSDictionary*)dataDic;

@end
