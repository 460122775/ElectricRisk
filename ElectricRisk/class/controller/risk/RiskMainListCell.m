//
//  RiskMainListCell.m
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "RiskMainListCell.h"

@implementation RiskMainListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewByData];
}

-(void)setViewByData
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@（%i％）", [self.dataDic objectForKey:@"title"], [(NSNumber*)[self.dataDic objectForKey:@"schedule"] intValue]];
    self.contentLabel.text = [self.dataDic objectForKey:@"content"];
    self.addressLabel.text = [self.dataDic objectForKey:@"address"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[self.dataDic objectForKey:@"time"] doubleValue] / 1000.0)];
    NSDateFormatter *dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"yyyy-MM-dd"];
    self.timeLabel.text = [dtfrm stringFromDate:date];
    int isActive = [(NSNumber*)[self.dataDic objectForKey:@"is_active"] intValue];
    if (isActive == Active_State_Normal)
    {
        self.stateLogoImg.image = [UIImage imageNamed:@"pass.png"];
    }else{
        self.stateLogoImg.image = [UIImage imageNamed:@"nopass.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.backgroundColor = [UIColor clearColor];
}

@end
