//
//  RiskDetailViewController.h
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *riskDataDic;
    
@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *dateBtn;

- (IBAction)backBtnClick:(id)sender;

- (IBAction)writeBtnClick:(id)sender;

- (IBAction)stopBtnClick:(id)sender;

- (IBAction)dateBtnClick:(id)sender;

- (void)initViewWithData:(NSDictionary*)dataDic;

@end
