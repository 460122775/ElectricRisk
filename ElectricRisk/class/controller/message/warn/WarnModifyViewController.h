//
//  WarnModifyViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/5/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSNPickerView.h"

#define Tag_StartTime 0
#define Tag_EndTime 1

@protocol WarnModifyDelegate <NSObject>

-(void)warnModifySuccess;

@end

@interface WarnModifyViewController : UIViewController<MSPickerViewDelegate>{
    MBProgressHUD *HUD;
    int currentKeyboardHeight;
    NSDateFormatter *dtfrm;
    long startTimeValue;
    long endTimeValue;
}

@property (assign, nonatomic) id<WarnModifyDelegate> delegate;
@property (strong, nonatomic) NSDictionary *warnDataDic;

@property (strong, nonatomic) IBOutlet UITextField *valueKTextField;
@property (strong, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (strong, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (strong, nonatomic) IBOutlet UITextView *reasonTextView;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *submitBtnBottomPadding;

- (IBAction)goBackBtnClick:(id)sender;
- (IBAction)startTimeBtnClick:(id)sender;
- (IBAction)endTimeBtnClick:(id)sender;
- (IBAction)submitBtnClick:(id)sender;

- (void)initViewWithData:(NSDictionary*)dataDic;

@end
