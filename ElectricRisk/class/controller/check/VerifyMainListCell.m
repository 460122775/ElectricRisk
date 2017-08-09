//
//  VerifyMainListCell
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "VerifyMainListCell.h"

@implementation VerifyMainListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewByData];
}

-(void)setViewByData
{
    
    NSString *nickName = [self.dataDic objectForKey:@"nickname"];
    if (nickName != nil && nickName.length > 0)
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)", [self.dataDic objectForKey:@"name"], nickName];
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)", [self.dataDic objectForKey:@"name"], [self.dataDic objectForKey:@"user_name"]];
    }
    self.contentLabel.text = [self.dataDic objectForKey:@"content"];
    self.addressLabel.text = [self.dataDic objectForKey:@"state_name"];
//    int checkState = [(NSNumber*)[self.dataDic objectForKey:@"state"] intValue];
//    switch (checkState)
//    {
//        case Check_State_None: self.addressLabel.text = @"待审核"; break;
//        case Check_State_Wait: self.addressLabel.text = @"待审核"; break;
//        case Check_State_No: self.addressLabel.text = @"被驳回"; break;
//        case Check_State_Yes: self.addressLabel.text = @"报审中"; break;
//        case Check_State_Publish4:
//        case Check_State_Publish5:
//        case Check_State_Publish7:
//        case Check_State_Publish8: self.addressLabel.text = @"已审核"; break;
//        default: self.addressLabel.text = [NSString stringWithFormat:@"未知状态:%i", checkState]; break;
//    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[self.dataDic objectForKey:@"c_time"] doubleValue] / 1000.0)];
    NSDateFormatter *dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"yyyy-MM-dd"];
    self.timeLabel.text = [dtfrm stringFromDate:date];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.backgroundColor = [UIColor whiteColor];
}

@end
