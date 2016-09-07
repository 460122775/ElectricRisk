//
//  WarnModifyViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/5/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "WarnModifyViewController.h"

@interface WarnModifyViewController ()

@end

@implementation WarnModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"yyyy-MM-dd"];
    self.reasonTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.reasonTextView.layer.borderWidth = 1;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
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
    [self initViewWithData:self.warnDataDic];
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

- (void)initViewWithData:(NSDictionary*)warnDataDic
{
    self.warnDataDic = warnDataDic;
    if (self.reasonTextView == nil) return;
    [self initViewByWarnData];
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
        [[JTToast toastWithText:@"内容修改成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.delegate != nil) [self.delegate warnModifySuccess];
            [self goBackBtnClick:nil];
        });
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestData
{
    if (self.warnDataDic == nil) return;
    if (HUD == nil)
    {
        HUD = [[MBProgressHUD alloc]init];
    }
    [self.view addSubview:HUD];
    HUD.dimBackground =YES;
    HUD.labelText = @"正在加载数据...";
    [HUD removeFromSuperViewOnHide];
    [HUD showByCustomView:YES];
    
    NSDictionary *dict = @{@"c_time":[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000],
                           @"uid":[NSString stringWithFormat:@"%i", [SystemConfig instance].currentUserId],
                           @"id":[self.warnDataDic objectForKey:@"id"],
                           @"plan_start_time":[NSString stringWithFormat:@"%li", startTimeValue],
                           @"plan_end_time":[NSString stringWithFormat:@"%li", endTimeValue],
                           @"reason":self.reasonTextView.text,
                           @"id":self.valueKTextField.text};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_WARN_MODIFY) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [[JTToast toastWithText:@"内容修改成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.delegate != nil) [self.delegate warnModifySuccess];
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

-(void)initViewByWarnData
{
    if(self.reasonTextView == nil) return;
    
    self.valueKTextField.text = [self.warnDataDic objectForKey:@"k_value"];
    startTimeValue = [(NSNumber*)[self.warnDataDic objectForKey:@"plan_start_time"] longValue];
    NSDate *sTimeDate = [NSDate dateWithTimeIntervalSince1970:( startTimeValue/ 1000.0)];
    [self.startTimeBtn setTitle:[dtfrm stringFromDate:sTimeDate] forState:UIControlStateNormal];
    
    endTimeValue = [(NSNumber*)[self.warnDataDic objectForKey:@"plan_end_time"] longValue];
    NSDate *eTimeDate = [NSDate dateWithTimeIntervalSince1970:(endTimeValue / 1000.0)];
    [self.endTimeBtn setTitle:[dtfrm stringFromDate:eTimeDate] forState:UIControlStateNormal];
}

- (IBAction)goBackBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startTimeBtnClick:(id)sender
{
    NSDate *sTimeDate = [NSDate dateWithTimeIntervalSince1970:( startTimeValue/ 1000.0)];
    MSNPickerView *_pickerView = [[MSNPickerView alloc]initDatePickWithDate:sTimeDate datePickerMode: UIDatePickerModeDate isHaveNavControler:NO];
    _pickerView.delegate = self;
    _pickerView.tag = Tag_StartTime;
    [_pickerView show];
}

- (IBAction)endTimeBtnClick:(id)sender
{
    NSDate *sTimeDate = [NSDate dateWithTimeIntervalSince1970:( startTimeValue/ 1000.0)];
    MSNPickerView *_pickerView = [[MSNPickerView alloc]initDatePickWithDate:sTimeDate datePickerMode: UIDatePickerModeDate isHaveNavControler:NO];
    _pickerView.delegate = self;
    _pickerView.tag = Tag_EndTime;
    [_pickerView show];
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(MSNPickerView *)pickView resultString:(NSString *)resultString{
    NSDate *inputDate = [dtfrm dateFromString:resultString];
    switch (pickView.tag)
    {
        case Tag_StartTime:
            startTimeValue = [inputDate timeIntervalSince1970] * 1000 * 1000;
            [self.startTimeBtn setTitle:[dtfrm stringFromDate:inputDate] forState:UIControlStateNormal];
            break;
        case Tag_EndTime:
            endTimeValue = [inputDate timeIntervalSince1970] * 1000 * 1000;
            [self.endTimeBtn setTitle:[dtfrm stringFromDate:inputDate] forState:UIControlStateNormal];
            break;
    }
}

- (IBAction)submitBtnClick:(id)sender
{
    if (self.valueKTextField.text == nil || self.valueKTextField.text.length == 0)
    {
        [[JTToast toastWithText:@"请输入K值" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }else if (self.reasonTextView.text == nil || self.reasonTextView.text.length == 0){
        [[JTToast toastWithText:@"请输入修改原因" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }else if (startTimeValue >= endTimeValue){
        [[JTToast toastWithText:@"开始时间应早于结束时间" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请确认"
                                                                    message:@"确定要保存修改吗？"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             if (OFFLINE)
                             {
                                 [self testData];
                             }else{
                                 [self requestData];
                             }
                         }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    currentKeyboardHeight = kbSize.height;
    self.submitBtnBottomPadding.constant = currentKeyboardHeight;
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    self.submitBtnBottomPadding.constant = 10;
}

@end
