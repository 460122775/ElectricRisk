//
//  WarnDetailViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/4/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarnDetailViewController : UIViewController{
    NSDateFormatter *dtfrm;
}

@property (strong, nonatomic) NSDictionary *dataDic;

@property (strong, nonatomic) IBOutlet UILabel *projectNameLb;
@property (strong, nonatomic) IBOutlet UILabel *contentLb;
@property (strong, nonatomic) IBOutlet UILabel *classLb;
@property (strong, nonatomic) IBOutlet UILabel *addressLb;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLb;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLb;


- (IBAction)cancelBtnClick:(id)sender;

- (void)initViewWithData:(NSDictionary*) dataDic;

@end
