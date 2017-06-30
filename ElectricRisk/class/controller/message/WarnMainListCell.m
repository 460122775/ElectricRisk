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
//    self.titleLabel.text = [NSString stringWithFormat:@"%@（%d级）", [self.dataDic objectForKey:@"name"], [(NSNumber*)[self.dataDic objectForKey:@"level"] intValue]];
    self.contentLabel.text = [self.dataDic objectForKey:@"content"];
    
    int code = [(NSNumber*)[self.dataDic objectForKey:@"code"] intValue];
    switch (code)
    {
        case 1: self.titleLabel.text = @"风险发布"; break;
        case 2: self.titleLabel.text = @"风险审批"; break;
        case 3: self.titleLabel.text = @"风险验收"; break;
        default: self.titleLabel.text = [NSString stringWithFormat:@"未知:%i", code]; break;
    }
    
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[self.dataDic objectForKey:@"creat_time"] doubleValue] / 1000.0)];
//    NSDateFormatter *dtfrm = [[NSDateFormatter alloc] init];
//    [dtfrm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    self.timeLabel.text = [dtfrm stringFromDate:date];
    self.timeLabel.text = [self.dataDic objectForKey:@"sattusV"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.backgroundColor = [UIColor whiteColor];
}

@end
