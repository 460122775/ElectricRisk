//
//  WarnModifyViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/5/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WarnModifyDelegate <NSObject>

-(void)warnModifySuccess;

@end

@interface WarnModifyViewController : UIViewController{
    MBProgressHUD *HUD;
    int currentKeyboardHeight;
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
