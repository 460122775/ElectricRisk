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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnClick:(id)sender
{
    DLog(@"%@,%@", self.nameTF.text, self.pwdTF.text)
    DLog(@"%@,%@",  [LoginViewController encrypt:self.nameTF.text],
                    [LoginViewController encrypt:self.pwdTF.text])
    [self performSegueWithIdentifier:@"LoginToHome" sender:self];
    
    if ([self.nameTF.text isEqualToString:@""]||[self.pwdTF.text isEqualToString:@""])
    {
        
        [[JTToast toastWithText:@"用户名和密码不能为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
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

-(void)login
{
//    [SystemConfig instance].currentUserName
    //设置登录参数
    NSDictionary *dict = @{@"username":self.nameTF.text,
                           @"password":self.pwdTF.text};
    //设置请求
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_LOGIN) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        
        [[JTToast toastWithText:@"登录成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        
    } failed:^(id responseData) {
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
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
