//
//  LoginViewController.m
//  ElectricRisk
//
//  Created by Yachen Dai on 8/26/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pwdTF.delegate = self;
    self.nameTF.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loginBtnClick:nil];
}

-(void)testData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"data\":{\"baidu_token\":\"3856325673642991365\",\"createTimeCaption\":\"\",\"id_card\":\"\",\"organ_id\":\"1\",\"user_email\":\"\",\"user_id\":\"1\",\"user_mobile\":\"\",\"user_name\":\"admin\",\"user_nickname\":\"admin\",\"user_password\":\"E10ADC3949BA59ABBE56E057F20F883E\",\"user_status\":\"0\",\"user_telephone\":\"\",\"user_type\":\"1\"},\"msg\":\"登录成功\",\"role\":1,\"roles\":[{\"ROLE_ID\":\"1\",\"role_id\":\"1\"}],\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        NSDictionary* userData = (NSDictionary*)[result objectForKey:@"data"];
        if (userData == nil) return;
        [[JTToast toastWithText:@"登录成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        // Save data.
        [SystemConfig instance].currentUserRole = [(NSNumber*)[result objectForKey:@"role"]
                                                   intValue];
        [SystemConfig instance].currentUserName = self.nameTF.text;
        [SystemConfig instance].currentUserPwd = self.pwdTF.text;
        [SystemConfig instance].currentUserId = [(NSNumber*)[userData objectForKey:@"user_id"]
                                                 intValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[SystemConfig instance].currentUserRole] forKey:@"currentUserRole"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[SystemConfig instance].currentUserId] forKey:@"currentUserId"];
        [[NSUserDefaults standardUserDefaults] setObject:[SystemConfig instance].currentUserName forKey:@"currentUserName"];
        [[NSUserDefaults standardUserDefaults] setObject:[SystemConfig instance].currentUserPwd forKey:@"currentUserPwd"];
        [self performSegueWithIdentifier:@"LoginToHome" sender:self];
        self.nameTF.text = @"";
        self.pwdTF.text = @"";
    // Pwd wrong.
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        self.pwdTF.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnClick:(id)sender
{
    // Auto fill.
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"] != nil)
    {
        self.nameTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserPwd"] != nil)
    {
        self.pwdTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserPwd"];
    }
    DLog(@"%@,%@", self.nameTF.text, self.pwdTF.text)
    DLog(@"%@,%@",  [LoginViewController encrypt:self.nameTF.text],
                    [LoginViewController encrypt:self.pwdTF.text])
    
    if ((self.nameTF.text == nil || [self.nameTF.text isEqualToString:@""] ||
        self.pwdTF.text == nil || [self.pwdTF.text isEqualToString:@""]))
    {
        if (sender != nil) [[JTToast toastWithText:@"用户名和密码不能为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }else{
        if (OFFLINE)
        {
            [self testData];
        }else{
            if (HUD == nil)
            {
                HUD = [[MBProgressHUD alloc]init];
            }
            [self.view addSubview:HUD];
            HUD.dimBackground =YES;
            HUD.labelText = @"登录中...";
            [HUD removeFromSuperViewOnHide];
            [HUD showByCustomView:YES];
            [self login];
        }
    }
}

-(void)login
{
    //设置登录参数
    NSDictionary *dict = @{@"username":self.nameTF.text,
                           @"password":self.pwdTF.text,
                           @"channelId":self.pwdTF.text};
    //设置请求
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_LOGIN) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        // Pwd right.
        if (state == State_Success)
        {
            NSDictionary* userData = (NSDictionary*)[result objectForKey:@"data"];
            if (userData == nil) return;
            [[JTToast toastWithText:@"登录成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
            // Save data.
            [SystemConfig instance].currentUserRole = [(NSNumber*)[result objectForKey:@"role"]
                                                       intValue];
            [SystemConfig instance].currentUserName = self.nameTF.text;
            [SystemConfig instance].currentUserPwd = self.pwdTF.text;
            [SystemConfig instance].currentUserId = [(NSNumber*)[userData objectForKey:@"user_id"]
                                                     intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[SystemConfig instance].currentUserRole] forKey:@"currentUserRole"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[SystemConfig instance].currentUserId] forKey:@"currentUserId"];
            [[NSUserDefaults standardUserDefaults] setObject:[SystemConfig instance].currentUserName forKey:@"currentUserName"];
            [[NSUserDefaults standardUserDefaults] setObject:[SystemConfig instance].currentUserPwd forKey:@"currentUserPwd"];
            self.nameTF.text = @"";
            self.pwdTF.text = @"";
            [self performSegueWithIdentifier:@"LoginToHome" sender:self];
        // Pwd wrong.
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
            self.pwdTF.text = @"";
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
    return (textField == self.nameTF && newLength <= 20) || (textField == self.pwdTF && newLength <= 20);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return (textField == self.nameTF && textField.text.length >= 5)
    || (textField == self.pwdTF && textField.text.length >= 6);
}

+ (NSString*)encrypt:(NSString*)plainText {
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [CodingKey UTF8String];
    const void *vinitVec = (const void *) [CodingOffset UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return result;
}

@end
