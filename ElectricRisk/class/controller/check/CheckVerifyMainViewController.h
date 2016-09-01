//
//  CheckVerifyMainViewController.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/2/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckMainListCell.h"
#import "VerifyMainListCell.h"

@interface CheckVerifyMainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    BOOL isCheckList;
    MBProgressHUD *HUD;
    
    NSMutableArray* checkDataArray;
    NSMutableArray* verifyDataArray;
}

@property (strong, nonatomic) IBOutlet UIButton *checkBtn;
@property (strong, nonatomic) IBOutlet UIButton *verifyBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *underLineLeading;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)checkBtnClick:(id)sender;

- (IBAction)verifyBtnClick:(id)sender;

- (IBAction)searchBtnClick:(id)sender;

@end
