//
//  RiskAddViewController
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskWrongListViewController.h"

@protocol RiskAddDelegate <NSObject>

-(void)riskExecutiveInfoAddSuccess;

@end

@interface RiskAddViewController : UIViewController<UIWebViewDelegate, RiskWrongListChooseDelegate>{
    MBProgressHUD *HUD;
    NSDictionary *currentSelectWrongDic;
    NSDateFormatter *dtfrm;
}

@property (strong, nonatomic) NSDictionary *riskDataDic;
@property (strong, nonatomic) NSDictionary *riskDetailDataDic;
@property (strong, nonatomic) NSArray *wrongDataArray;
@property (assign, nonatomic) id<RiskAddDelegate> delegate;


@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentDateLabel;



- (IBAction)backBtnClick:(id)sender;

- (IBAction)finishBtnClick:(id)sender;

- (IBAction)dateBtnClick:(id)sender;

- (void)initViewWithRisk:(NSDictionary*)riskDataDic andDetail:(NSDictionary*) riskDetailDic;

@end
