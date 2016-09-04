//
//  RiskExecutiveTimeListViewController.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/4/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RiskExecutiveTimeChooseDelegate <NSObject>

-(void)timeChooseControl:(double)timeValue;

@end

@interface RiskExecutiveTimeListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSDateFormatter *dtfrm;
}

@property (strong, nonatomic) NSArray *timeArray;
@property (strong, nonatomic) id<RiskExecutiveTimeChooseDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *timeTableView;

- (IBAction)cancelBtnClick:(id)sender;

- (void)initViewWithData:(NSArray*) timeArray;

@end
