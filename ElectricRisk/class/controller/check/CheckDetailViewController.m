//
//  CheckDetailViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/9/5.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "CheckDetailViewController.h"

@interface CheckDetailViewController ()

@end

@implementation CheckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // Do any additional setup after loading the view.
    self.agreeContentTextView.layer.borderWidth = 1;
    self.agreeContentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.spContentView.delegate = self;
    self.yzContentView.delegate = self;
    self.agreeContentTextView.delegate = self;
    
    [self initViewWithData:self.checkDataDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)goBackBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)agreeSubmitBtnClick:(id)sender
{
    if([self.agreeContentTextView isFirstResponder])
    {
        [self.agreeContentTextView resignFirstResponder];
    }
    if (OFFLINE)
    {
        [self testCommitData];
    }else{
        [self requestCommitData];
    }
}

- (IBAction)agreeSwitchChanged:(id)sender
{
    switch (currentLCValue)
    {
        case 0: [self.agreeSubmitBtn setTitle:(self.agreeSwitch.isOn) ? @"提交到业主项目部": @"驳回施工项目部" forState:UIControlStateNormal]; break;
        case 1: [self.agreeSubmitBtn setTitle:(self.agreeSwitch.isOn) ? @"归档": @"驳回监理项目部" forState:UIControlStateNormal]; break;
        default: break;
    }
    if (self.agreeSwitch.isOn)
    {
        [self.agreeSubmitBtn setBackgroundColor:Color_me];
    }else{
        [self.agreeSubmitBtn setBackgroundColor:Color_fourGrade];
    }
}

- (void)initViewWithData:(NSDictionary*)checkDataDic
{
    self.checkDataDic = checkDataDic;
    if (self.projectNameLabel == nil) return;
    if (OFFLINE)
    {
        [self testData];
    }else{
        [self requestData];
    }
}

-(void)testData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"data\": {        \"bslc\": 2,        \"bsxx\": {            \"code\": \"dlg\",            \"content\": \"报审内容\",            \"create_time\": 1471449600000,            \"name\": \"dlg-sg-1\",            \"project_name\": \"第六个\"        },        \"sp_state\": 0,        \"spxx\": {            \"jl_content\": \"Hello world.\",            \"jl_name\": \"dlg-jl-1\",            \"jl_time\": 1471449600000,            \"jl_yj\": 2,            \"yz_content\": \"\",            \"yz_name\": \"dlg-yz-1\",            \"yz_time\": 1471449600000,            \"yz_yj\": 2        }    },    \"state\": 1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        self.checkDetailDataDic = [result objectForKey:@"data"];
        if (self.checkDetailDataDic == nil)
        {
            [[JTToast toastWithText:@"未获取到该审核的内容数据" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initViewByDetailData];
        });
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestData
{
    if (self.checkDataDic == nil) return;
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
                           @"uid":[SystemConfig instance].currentUserId,
                           @"id":[self.checkDataDic objectForKey:@"id"],
                           @"type":@TYPE_CHECK};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_REPORTDETAIL) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            self.checkDetailDataDic = [result objectForKey:@"data"];
            if (self.checkDetailDataDic == nil)
            {
                [[JTToast toastWithText:@"未获取到该审核的内容数据" configuration:[JTToastConfiguration defaultConfiguration]]show];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initViewByDetailData];
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

-(void)testCommitData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\": 1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        [[JTToast toastWithText:@"提交成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        self.agreeContentTextView.text = @"";
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initViewWithData:self.checkDataDic];
        });
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestCommitData
{
    if (self.checkDataDic == nil) return;
    if (HUD == nil)
    {
        HUD = [[MBProgressHUD alloc]init];
    }
    [self.view addSubview:HUD];
    HUD.dimBackground =YES;
    HUD.labelText = @"正在加载数据...";
    [HUD removeFromSuperViewOnHide];
    [HUD showByCustomView:YES];
    
    NSDictionary *dict = @{@"state":(self.agreeSwitch.isOn) ? @"2" : @"1",
                           @"uid":[SystemConfig instance].currentUserId,
                           @"id":[self.checkDataDic objectForKey:@"id"],
                           @"flag":@"sp",
                           @"reason":(self.agreeContentTextView.text == nil) ? @"" : self.agreeContentTextView.text};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_REPORTOPERATE) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [[JTToast toastWithText:@"提交成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
            self.agreeContentTextView.text = @"";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initViewWithData:self.checkDataDic];
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


-(void)initViewByDetailData
{
    if (self.checkDetailDataDic == nil) return;
    NSDictionary *bsDic = [self.checkDetailDataDic objectForKey:@"bsxx"];
    if (bsDic != nil)
    {
        self.projectNameLabel.text = [bsDic objectForKey:@"project_name"];
        self.projectCdLabel.text = [bsDic objectForKey:@"code"];
        self.bsCompanyNameLabel.text = [bsDic objectForKey:@"name"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[bsDic objectForKey:@"create_time"] doubleValue] / 1000.0)];
        self.bsTimeLabel.text = [dtfrm stringFromDate:date];
    }
    
    currentLCValue = [(NSNumber*)[self.checkDetailDataDic  objectForKey:@"bslc"] doubleValue];
    NSDictionary *spDic = [self.checkDetailDataDic objectForKey:@"spxx"];
    
    int right = [SystemConfig instance].currentUserRole;
    bool isShowAgreeView = NO;
    if (spDic != nil)
    {
        if (currentLCValue > 0)
        {
            self.spContentView.text = [NSString stringWithFormat:@"%@\n%@",
                                       ([(NSNumber*)[spDic objectForKey:@"jl_yj"] intValue] == CHECKSTATE_AGREE) ? @"同意" : @"不同意",
                                       [spDic objectForKey:@"jl_content"]];
            self.spContentViewHeight.constant = self.spContentView.contentSize.height;
            self.spCompanyNameLabel.text = [spDic objectForKey:@"jl_name"];
            NSDate *spDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[spDic objectForKey:@"jl_time"] doubleValue] / 1000.0)];
            self.spTimeLabel.text = [dtfrm stringFromDate:spDate];
            
            self.process_spImgView.image = [UIImage imageNamed:@"31"];
            self.agreeViewTopPadding.constant = self.spContainerView.frame.origin.y + self.spContainerView.frame.size.height;
            isShowAgreeView = NO;
        }else{
            self.process_spImgView.image = [UIImage imageNamed:@"30"];
            if(right == ROLE_A || right == ROLE_5)
            {
                self.agreeViewTopPadding.constant = 30;
                isShowAgreeView = YES;
            }else{
                self.agreeViewTopPadding.constant = -30;
            }
        }
        
        if (currentLCValue > 1)
        {
            self.yzContentView.text = [NSString stringWithFormat:@"%@\n%@",
                                       ([(NSNumber*)[spDic objectForKey:@"yz_yj"] intValue] == CHECKSTATE_AGREE) ? @"同意" : @"不同意",
                                       [spDic objectForKey:@"yz_content"]];
            self.yzCompanyNameLabel.text = [spDic objectForKey:@"yz_name"];
            NSDate *yzDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[spDic objectForKey:@"yz_time"] doubleValue] / 1000.0)];
            self.yzTimeLabel.text = [dtfrm stringFromDate:yzDate];
            
            self.process_yzImgView.image = [UIImage imageNamed:@"41"];
            self.agreeViewTopPadding.constant = self.yzContainerView.frame.origin.y + self.yzContainerView.frame.size.height;
            isShowAgreeView = NO;
        }else{
            self.process_yzImgView.image = [UIImage imageNamed:@"40"];
            if(right == ROLE_A || right == ROLE_4)
            {
                self.agreeViewTopPadding.constant = self.agreeViewTopPadding.constant + 30;
                isShowAgreeView = YES;
            }
        }
        
        if (currentLCValue >= 2)
        {
            self.process_overImgView.image = [UIImage imageNamed:@"61"];
        }else{
            self.process_overImgView.image = [UIImage imageNamed:@"60"];
        }
        [self agreeSwitchChanged:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.agreeEnableView setHidden:isShowAgreeView];
        });
        if (isShowAgreeView)
        {
            agreeViewHeight = self.agreeViewTopPadding.constant + self.agreeView.frame.size.height;
            self.checkContainerHeight.constant = agreeViewHeight;
        }else{
            agreeViewHeight = 0;
            self.checkContainerHeight.constant = self.agreeViewTopPadding.constant + 30;
        }
    }
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

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    currentKeyboardHeight = kbSize.height;
    self.checkContainerHeight.constant = agreeViewHeight + currentKeyboardHeight;
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    self.checkContainerHeight.constant = agreeViewHeight;
}

@end
