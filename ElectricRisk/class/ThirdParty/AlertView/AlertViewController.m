//
//  BTXAlertViewController.m
//  Botianxia
//
//  Created by CNEONLINE on 16/5/6.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import "AlertViewController.h"
#define MIN_CONTENT_HEIGHT 84
#define MAX_CONTENT_HEIGHT (ScreenWidth -  (50 + 5 + 5 +  5 + 5 + 40))

@interface AlertViewController()
{
    NSString *promptionTitle;
    NSString *content;
    NSString *cancelBtnTitle;
    NSString *okBtnTitle;
    BOOL isOKBtnHidden;
    BOOL isCancelBtnHidden;
}

@end

@implementation AlertViewController
@synthesize mainView, contentBgView, contentTextView, cancelBtn, okBtn, titleLabel;

-(id)init
{
    self = [super init];
    if(self)
    {
        isCancelBtnHidden = NO;
        isOKBtnHidden = NO;
        isAutoSize = NO;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Drawing code
    // 设置按钮的边框样式。
    self.mainView.layer.cornerRadius = 8;
    self.contentBgView.layer.cornerRadius = 0;
    self.cancelBtn.layer.cornerRadius = 0;
    self.okBtn.layer.cornerRadius = 0;
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setOkBtnTitle:okBtnTitle andCancelBtnTitle:cancelBtnTitle];
}

-(void)initViewByTheme
{
    self.contentBgView.backgroundColor = [UIColor whiteColor];
    self.contentTextView.textColor = [UIColor darkGrayColor];
    self.mainView.backgroundColor = Color_THEME;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleLabel.text = promptionTitle;
    self.contentTextView.text = content;
    if(isAutoSize) [self setContentSize];
    [self initViewByTheme];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)showAlert:(NSString*)title content:(NSString*)contentStr autoSize:(BOOL)_isAutoSize
{
    self.titleLabel.text = title;
    self.contentTextView.text = contentStr;
    //isAutoSize = _isAutoSize;
    isAutoSize = YES;
    if(isAutoSize) [self setContentSize];
    promptionTitle = title;
    content = contentStr;
}

- (CGSize)setContentSize
{
    CGRect frame = [content boundingRectWithSize:CGSizeMake(self.contentTextView.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil];
    CGSize size = CGSizeMake(frame.size.width, frame.size.height * 1.5 + 1);
    if (size.height < MIN_CONTENT_HEIGHT) size.height = MIN_CONTENT_HEIGHT;
    if(size.height > MAX_CONTENT_HEIGHT) size.height = MAX_CONTENT_HEIGHT;
    self.containerHeightCons.constant = 50 + 5 + 5 + size.height + 5 + 5 + 40;
    NSLog(@"SIZE=(%f, %f)", size.width, size.height);
    return size;
}

- (void)setOkBtnTitle:(NSString*)_okBtnTitle andCancelBtnTitle:(NSString*)_cancelBtnTitle
{
    if (_okBtnTitle != nil) okBtnTitle = _okBtnTitle;
    if (okBtnTitle == nil || okBtnTitle.length == 0) okBtnTitle = @"确定";
    self.okBtnCons.constant = (isCancelBtnHidden) ? self.containerWidthCons.constant * 0.5 : 1;
    [self.okBtn setTitle:okBtnTitle forState:UIControlStateNormal];
    [self.okBtn setHidden:isOKBtnHidden];
    
    if (_cancelBtnTitle != nil) cancelBtnTitle = _cancelBtnTitle;
    if (cancelBtnTitle == nil || cancelBtnTitle.length == 0) cancelBtnTitle = @"取消";
    self.cancelBtnCons.constant = (isOKBtnHidden) ? self.containerWidthCons.constant * 0.5: 0;
    [self.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
    [self.cancelBtn setHidden:isCancelBtnHidden];
}

- (void)setViewByOKBtnTitle:(NSString*)okBtnTitleString andCancelBtnTitle:(NSString*)cancelBtnTitleString
{
    isCancelBtnHidden = NO;
    isOKBtnHidden = NO;
    [self setOkBtnTitle:okBtnTitleString andCancelBtnTitle:cancelBtnTitleString];
}

- (void)setViewByOKBtn:(NSString*)okBtnTitleString
{
    isCancelBtnHidden = YES;
    isOKBtnHidden = NO;
    [self setOkBtnTitle:okBtnTitleString andCancelBtnTitle:@""];
}

- (void)setViewByCancleBtn:(NSString*)cancelBtnTitleString
{
    isCancelBtnHidden = NO;
    isOKBtnHidden = YES;
    [self setOkBtnTitle:@"" andCancelBtnTitle:cancelBtnTitleString];
}

- (IBAction)cancelBtnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.leftBlock != nil) self.leftBlock();
}

- (IBAction)okBtnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.rightBlock != nil) self.rightBlock();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(AlertViewController*)showAlert:(NSString *)title content:(NSString *)content onController:(UIViewController *)controller
                    withRightBtn:(NSString*)rightTitle rightClick:(IteratorBlock) rightClickBlock
                    withLeftBtn:(NSString*)leftTitle    leftClick:(IteratorBlock) leftClickBlock
{
    
    AlertViewController *alertViewController = [[AlertViewController alloc] initWithNibName:@"AlertViewController" bundle:nil];
    alertViewController.modalPresentationStyle = UIModalPresentationCustom;
    alertViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    alertViewController.rightBlock = rightClickBlock;
    alertViewController.leftBlock = leftClickBlock;
    
    if (leftTitle == nil)
    {
        [alertViewController setViewByOKBtn:rightTitle];
    }else if(rightTitle == nil){
        [alertViewController setViewByCancleBtn:leftTitle];
    }else{
        [alertViewController setViewByOKBtnTitle:rightTitle andCancelBtnTitle:leftTitle];
    }
    
    [alertViewController showAlert:title content:content autoSize:YES];
    
    [controller presentViewController:alertViewController animated:YES completion:^{}];
    
    return alertViewController;
}
@end
