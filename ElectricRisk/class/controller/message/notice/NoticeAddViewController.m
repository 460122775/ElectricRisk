//
//  NoticeAddViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/9/5.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "NoticeAddViewController.h"

@interface NoticeAddViewController ()

@end

@implementation NoticeAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentTextView.layer.borderWidth = 1;
    self.contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.titleTextField.delegate = self;
    self.contentTextView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitBtnClick:(id)sender
{
    if (self.titleTextField.text == nil || self.titleTextField.text.length == 0)
    {
        [[JTToast toastWithText:@"您还没有填写标题" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }
    
    if (self.contentTextView.text == nil || self.contentTextView.text.length == 0)
    {
        [[JTToast toastWithText:@"您还没有填写内容" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请确认" message:@"要发布该通知的内容吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
         if (OFFLINE)
         {
             [self testDataForSave:NO];
         }else{
             [self requestDataForSave:NO];
         }
     }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"仅保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
         if (OFFLINE)
         {
             [self testDataForSave:YES];
         }else{
             [self requestDataForSave:YES];
         }
     }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)testDataForSave:(BOOL)onlySave
{
    isOnlySave = onlySave;
    NSError *jsonError;
    NSData *objectData = [@"{\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        [[JTToast toastWithText:(isOnlySave)?@"保存成功":@"保存并发布成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate != nil) [self.delegate noticeAddSuccessControl];
            [self goBackBtnClick:nil];
        });
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestDataForSave:(BOOL)onlySave
{
    isOnlySave = onlySave;
    if (HUD == nil)
    {
        HUD = [[MBProgressHUD alloc]init];
    }
    [self.view addSubview:HUD];
    HUD.dimBackground =YES;
    HUD.labelText = @"正在上传数据...";
    [HUD removeFromSuperViewOnHide];
    [HUD showByCustomView:YES];
    
    NSDictionary *dict = @{@"c_time":[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000],
                           @"uid":[NSString stringWithFormat:@"%i", [SystemConfig instance].currentUserId],
                           @"title":self.titleTextField.text,
                           @"content":self.contentTextView.text,
                           @"flag":(onlySave)?@2:@1};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_NOTICE_ADD) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [[JTToast toastWithText:(isOnlySave)?@"保存成功":@"保存并发布成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate != nil) [self.delegate noticeAddSuccessControl];
                [self goBackBtnClick:nil];
            });
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.titleTextField isFirstResponder])
    {
        [self.titleTextField resignFirstResponder];
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    currentKeyboardHeight = kbSize.height;
    self.contentTextView.contentSize = CGSizeMake(self.contentTextView.contentSize.width, self.contentTextView.contentSize.height + currentKeyboardHeight);
    self.contentTextView.contentOffset = CGPointMake(self.contentTextView.contentOffset.x, self.contentTextView.contentOffset.y + currentKeyboardHeight);
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    self.contentTextView.text = self.contentTextView.text;
}

@end
