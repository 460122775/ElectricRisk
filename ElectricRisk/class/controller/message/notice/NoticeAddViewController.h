//
//  NoticeAddViewController.h
//  ElectricRisk
//
//  Created by yasin zhang on 16/9/5.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+MBProgressHUDView.h"

@protocol NoticeAddDelegate <NSObject>

-(void)noticeAddSuccessControl;

@end

@interface NoticeAddViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>{
    MBProgressHUD *HUD;
    BOOL isOnlySave;
    int currentKeyboardHeight;
}

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) id<NoticeAddDelegate> delegate;

- (IBAction)goBackBtnClick:(id)sender;
- (IBAction)submitBtnClick:(id)sender;

@end
