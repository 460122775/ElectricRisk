//
//  RiskClassChooseViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/4/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RiskClassChooseDelegate <NSObject>

-(void)riskClassChooseControl:(int)classValue withStart:(BOOL)isStart;

@end

@interface RiskClassChooseViewController : UIViewController{
    BOOL isStart;
}

@property (strong, nonatomic) NSArray *projectArray;
@property (strong, nonatomic) id<RiskClassChooseDelegate> delegate;

- (IBAction)cancelBtnClick:(id)sender;

- (void)initViewWithStart:(BOOL)_isStart;

- (IBAction)classBtnClick:(id)sender;


@end
