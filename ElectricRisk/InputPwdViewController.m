//
//  InpuPwdViewController.m
//  ElectricRisk
//
//  Created by 魏翔 on 2017/11/5.
//  Copyright © 2017年 com.yasin.electric. All rights reserved.
//

#import "InputPwdViewController.h"

@interface InputPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation InputPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView
{
    self.userNameTF.text = [SystemConfig instance].currentUserName;
    self.userNameTF.userInteractionEnabled = NO;
    
    
    self.pwdTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.pwdTF.layer.borderWidth = 1;
    self.pwdTF.layer.cornerRadius = 20;
    UIImageView *pwdLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, self.pwdTF.frame.size.height)];
    [pwdLeftImg setImage:[UIImage imageNamed:@"login_input_mima.png"]];
    [pwdLeftImg setContentMode:UIViewContentModeCenter];
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(pwdLeftImg.frame.size.width - 1, 0, 1.0, pwdLeftImg.frame.size.height);
    [rightBorder setBackgroundColor:(__bridge CGColorRef _Nullable)([UIColor lightGrayColor])];
    [pwdLeftImg.layer addSublayer:rightBorder];
    self.pwdTF.leftView = pwdLeftImg;
    self.pwdTF.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTF.delegate = self;
    
    self.userNameTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userNameTF.layer.borderWidth = 1;
    self.userNameTF.layer.cornerRadius = 20;
    UIImageView *pwdRightImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, self.userNameTF.frame.size.height)];
    [pwdRightImg setImage:[UIImage imageNamed:@"login_input_tubiao.png"]];
    [pwdRightImg setContentMode:UIViewContentModeCenter];
    self.userNameTF.leftView = pwdRightImg;
    self.userNameTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.loginBtn.layer.cornerRadius = 20;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

// TextFieldDelegate.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (textField == self.userNameTF && newLength <= 30) || (textField == self.pwdTF && newLength <= 30);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.pwdTF && textField.text.length >= 8)
    {
        [self.pwdTF resignFirstResponder];
    }
    return NO;
}

// Keyboard visiable.
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGSize kbSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.mainScrollView.contentInset = contentInsets;
    self.mainScrollView.scrollIndicatorInsets = contentInsets;
    [self.mainScrollView scrollRectToVisible:self.pwdTF.frame animated: YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mainScrollView.contentInset = contentInsets;
    self.mainScrollView.scrollIndicatorInsets = contentInsets;
}

- (IBAction)didClickCommit:(id)sender
{
    [self.pwdTF resignFirstResponder];
    NSString *inputPwdStr = self.pwdTF.text;
    if([inputPwdStr isEqualToString: @""])
    {
        [[JTToast toastWithText: @"请输入登录密码" configuration: [JTToastConfiguration defaultConfiguration]] show];
    }else {
        if (![[SystemConfig instance].currentUserPwd isEqualToString: inputPwdStr])
        {
            [[JTToast toastWithText: @"登录密码不正确，请重新输入" configuration: [JTToastConfiguration defaultConfiguration]] show];
            self.pwdTF.text = @"";
        } else {
            [self dismissViewControllerAnimated: YES completion: nil];
        }
    }
}

@end
