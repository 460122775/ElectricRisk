//
//  ModifyPwdViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/9/2.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "ModifyPwdViewController.h"

@interface ModifyPwdViewController ()

@end

@implementation ModifyPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.oldPwdTextField.delegate = self;
    self.pwdNewTextField1.delegate = self;
    self.pwdNewTextField2.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackBtnClick:(id)sender
{
    self.oldPwdTextField.text = @"";
    self.pwdNewTextField1.text = @"";
    self.pwdNewTextField2.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBtnClick:(id)sender
{
    if (self.oldPwdTextField.text == nil || self.oldPwdTextField.text.length < 8)
    {
        [[JTToast toastWithText:@"原始密码长度有误" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }else if (self.pwdNewTextField1.text == nil || self.pwdNewTextField1.text.length < 8 || self.pwdNewTextField1.text.length > 20){
        [[JTToast toastWithText:@"新密码的长度应为8～20位之间" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }else if (self.pwdNewTextField2.text == nil || self.pwdNewTextField2.text.length < 8
        || ![self.pwdNewTextField1.text isEqualToString:self.pwdNewTextField2.text])
    {
        [[JTToast toastWithText:@"两次输入的新密码不一致" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }else{
        NSString *pattern =@"^(?!\d+$)(?![a-zA-Z]+$)(?![@#$%^&]+$)[\da-zA-Z@#$%^&]+$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        if ([regex matchesInString:self.pwdNewTextField1.text options:0 range:NSMakeRange(0, self.pwdNewTextField1.text.length)])
        {
            [[JTToast toastWithText:@"密码必须包含字母、数字、特殊符号." configuration:[JTToastConfiguration defaultConfiguration]]show];
            return;
        }
    }
    if (OFFLINE)
    {
        [self testData];
    }else{
        [self requestUpdatePwd];
    }
}

-(void)testData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        [[JTToast toastWithText:@"密码修改成功，请重新登录" configuration:[JTToastConfiguration defaultConfiguration]]show];
        [self goBackBtnClick:nil];
        if(self.delegate != nil) [self.delegate modifyPwdSuccess];
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestUpdatePwd
{
    //设置登录参数
    NSDictionary *dict = @{@"c_time":[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000],
                           @"uid":[SystemConfig instance].currentUserId,
                           @"old_pasword":self.oldPwdTextField.text,
                           @"new_password":self.pwdNewTextField1.text};
    //设置请求
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_PWD_UPDATE) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [[JTToast toastWithText:@"密码修改成功，请重新登录" configuration:[JTToastConfiguration defaultConfiguration]]show];
            [self goBackBtnClick:nil];
            if(self.delegate != nil) [self.delegate modifyPwdSuccess];
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
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
    return (textField == self.oldPwdTextField && newLength <= 20)
    || (textField == self.pwdNewTextField1 && newLength <= 20)
    || (textField == self.pwdNewTextField2 && newLength <= 20);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.oldPwdTextField && textField.text.length >= 6)
        || (textField == self.pwdNewTextField1 && textField.text.length >= 6)
        || (textField == self.pwdNewTextField2 && textField.text.length >= 6))
    {
        [textField resignFirstResponder];
        return YES;
    }else{
        return NO;
    }
}

@end
