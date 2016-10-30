//
//  RiskAddViewController
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskWrongListViewController.h"
#import "MBProgressHUD+MBProgressHUDView.h"

#define HEIGHT_SCROLLVIEW 60
#define ImgPadding 6

@protocol RiskAddDelegate <NSObject>

-(void)riskExecutiveInfoAddSuccess;

@end

@interface RiskAddViewController : UIViewController<UIWebViewDelegate, RiskWrongListChooseDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>{
    MBProgressHUD *HUD;
    int currentKeyboardHeight;
    NSDictionary *currentSelectWrongDic;
    NSDateFormatter *dtfrm;
    
    UIImagePickerController *imagePickerController;
    NSMutableArray *currentImgArray;
    NSLayoutConstraint *currentScrollViewHeight;
    UIScrollView *currentScrollView;
    UIImage *currentImage;
}

@property (strong, nonatomic) NSDictionary *riskDataDic;
@property (strong, nonatomic) NSDictionary *riskDetailDataDic;
@property (strong, nonatomic) NSArray *wrongDataArray;
@property (assign, nonatomic) id<RiskAddDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentDateLabel;

@property (strong, nonatomic) IBOutlet UIView *ryContainerView;
@property (strong, nonatomic) IBOutlet UIButton *ryImgBtn;
@property (strong, nonatomic) IBOutlet UITextView *ryContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ryContentViewHeight;
@property (strong, nonatomic) IBOutlet UIScrollView *ryImgScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ryScrollViewHeight;
@property (strong, nonatomic) NSMutableArray *ryImgArray;

@property (strong, nonatomic) IBOutlet UIView *xcContainerView;
@property (strong, nonatomic) IBOutlet UIButton *xcImgBtn;
@property (strong, nonatomic) IBOutlet UITextView *xcContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *xcContentViewHeight;
@property (strong, nonatomic) IBOutlet UIScrollView *xcImgScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *xcImgScrollViewHeight;
@property (strong, nonatomic) NSMutableArray *xcImgArray;

@property (strong, nonatomic) IBOutlet UIView *zgContainerView;
@property (strong, nonatomic) IBOutlet UIButton *zgImgBtn;
@property (strong, nonatomic) IBOutlet UISwitch *zgSwitch;
@property (strong, nonatomic) IBOutlet UILabel *zgWzLabel;
@property (strong, nonatomic) IBOutlet UIButton *zgWzBtn;
@property (strong, nonatomic) IBOutlet UITextView *zgContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *zgContentViewHeight;
@property (strong, nonatomic) IBOutlet UIScrollView *zgImgScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *zgImgScrollViewHeight;
@property (strong, nonatomic) NSMutableArray *zgImgArray;

@property (strong, nonatomic) IBOutlet UIView *sgContainerView;
@property (strong, nonatomic) IBOutlet UIButton *sgImgBtn;
@property (strong, nonatomic) IBOutlet UITextView *sgContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sgContentViewHeight;
@property (strong, nonatomic) IBOutlet UIScrollView *sgImgScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sgImgScrollViewHeight;
@property (strong, nonatomic) IBOutlet UITextField *sgProcessInput;
@property (strong, nonatomic) NSMutableArray *sgImgArray;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *paddingBottom;

- (IBAction)zgWzBtnClick:(id)sender;
- (IBAction)zgSwitchChanged:(id)sender;
- (IBAction)imgBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)finishBtnClick:(id)sender;

- (void)initViewWithRisk:(NSDictionary*)riskDataDic andDetail:(NSDictionary*) riskDetailDic;

@end
