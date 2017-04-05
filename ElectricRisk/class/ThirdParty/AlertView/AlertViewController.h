//
//  BTXAlertViewController.h
//  Botianxia
//
//  Created by CNEONLINE on 16/5/6.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ IteratorBlock)();

@interface AlertViewController : UIViewController{
    BOOL isAutoSize;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *contentBgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnCons;
@property (strong, nonatomic) IBOutlet UIButton *okBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *okBtnCons;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerWidthCons;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerHeightCons;

@property (nonatomic, copy) IteratorBlock rightBlock;
@property (nonatomic, copy) IteratorBlock leftBlock;
@property (strong, nonatomic) UIViewController *controller;

- (IBAction)cancelBtnClick:(UIButton *)sender;
- (IBAction)okBtnClick:(UIButton *)sender;

- (void)setViewByCancleBtn:(NSString*)cancelBtnTitleString;
- (void)setViewByOKBtn:(NSString*)okBtnTitleString;
- (void)setViewByOKBtnTitle:(NSString*)okBtnTitleString andCancelBtnTitle:(NSString*)cancelBtnTitleString;
- (void)showAlert:(NSString*)title content:(NSString*)contentStr autoSize:(BOOL)isAutoSize;

+(AlertViewController*)showAlert:(NSString *)title content:(NSString *)content onController:(UIViewController *)controller
                    withRightBtn:(NSString*)rightTitle rightClick:(IteratorBlock) _rightClickBlock
                     withLeftBtn:(NSString*)leftTitle    leftClick:(IteratorBlock) _leftClickBlock;

@end
