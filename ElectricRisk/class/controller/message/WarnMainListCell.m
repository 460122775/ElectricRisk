//
//  WarnMainListCell
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "WarnMainListCell.h"

@implementation WarnMainListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewByData];
}

-(void)setViewByData
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@（%d级）", [self.dataDic objectForKey:@"name"], [(NSNumber*)[self.dataDic objectForKey:@"level"] intValue]];
    self.contentLabel.text = [self.dataDic objectForKey:@"content"];
    
    int state = [(NSNumber*)[self.dataDic objectForKey:@"state"] intValue];
    switch (state)
    {
        case Rish_PUBLISHSTATE_PUBLISH: self.addressLabel.text = @"可发布"; break;
        case Rish_PUBLISHSTATE_REVOKE: self.addressLabel.text = @"可撤回"; break;
        default: self.addressLabel.text = [NSString stringWithFormat:@"未知状态:%i", state]; break;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[self.dataDic objectForKey:@"creat_time"] doubleValue] / 1000.0)];
    NSDateFormatter *dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [dtfrm stringFromDate:date];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.backgroundColor = [UIColor whiteColor];
}

@end
