//
//  NoticeMainListCell
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "NoticeMainListCell.h"

@implementation NoticeMainListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewByData];
}

-(void)setViewByData
{
    self.titleLabel.text =  [self.dataDic objectForKey:@"title"];
    self.contentLabel.text = [self.dataDic objectForKey:@"hanzi"];
    self.addressLabel.text = [self.dataDic objectForKey:@"name"];
    int state = [(NSNumber*)[self.dataDic objectForKey:@"state"] intValue];
    switch (state)
    {
        case Notice_State_Not: self.stateView.backgroundColor = [UIColor redColor];break;
        case Notice_State_Read: self.stateView.backgroundColor = [UIColor darkGrayColor]; break;
        case Notice_State_Reply: self.stateView.backgroundColor = [UIColor lightGrayColor]; break;
        default: self.stateView.backgroundColor = [UIColor darkGrayColor]; break;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[self.dataDic objectForKey:@"publish_date"] doubleValue] / 1000.0)];
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
