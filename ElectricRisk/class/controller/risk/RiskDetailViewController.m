//
//  RiskDetailViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "RiskDetailViewController.h"

@interface RiskDetailViewController ()

@end

@implementation RiskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sgpersonInfoWebView.delegate = self;
    self.jlPersonInfoWebView.delegate = self;
    self.yzPersonInfoWebView.delegate = self;
    self.executiveInfoWebView.delegate = self;
    self.repairInfoWebView.delegate = self;
    self.processInfoWebView.delegate = self;
    
    dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"yyyy-MM-dd"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.writeBtn setHidden:![self getRight:self.writeBtn]];
    [self.stopBtn setHidden:![self getRight:self.stopBtn]];
    [self initViewWithData:self.riskDataDic];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)getRight:(UIView*)view
{
    if (view == self.writeBtn)
    {
        switch ([SystemConfig instance].currentUserRole)
        {
            case ROLE_4:
            case ROLE_5:
            case ROLE_6:
            case ROLE_8:
            case ROLE_A: return YES; break;
            default: return NO; break;
        }
    }else if (view == self.stopBtn){
        switch ([SystemConfig instance].currentUserRole)
        {
            case ROLE_5:
            case ROLE_A: return YES; break;
            default: return NO; break;
        }
    }
    return NO;
}

- (void)initViewWithData:(NSDictionary*)dataDic
{
    if(self.riskDataDic != dataDic) currentProcess = [(NSNumber*)[dataDic objectForKey:@"schedule"] floatValue];
    self.riskDataDic = dataDic;
    if (self.addressLabel == nil) return;
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
    NSData *objectData = [@"{\"data\":{\"ADDRESS\":\"dfgd\",\"NAME\":\"第六个\",\"PLAN_END_TIME\":1471190400000,\"REAL_START_TIME\":1470844800000,\"address\":\"dfgd\",\"day_liat\":[{\"CREAT_TIME\":1470844800000,\"creat_time\":1470844800000},{\"CREAT_TIME\":1470931200000,\"creat_time\":1470931200000},{\"CREAT_TIME\":1471190400000,\"creat_time\":1471190400000},{\"CREAT_TIME\":1471276800000,\"creat_time\":1471276800000},{\"CREAT_TIME\":1471363200000,\"creat_time\":1471363200000}],\"name\":\"第六个\",\"plan_end_time\":1471190400000,\"real_end_time\":0,\"plan_start_time\":1470844800000},\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        self.riskDetailDataDic = (NSDictionary*)[result objectForKey:@"data"];
        if (self.riskDetailDataDic == nil)
        {
            [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }else{
            [self initViewByDetailData];
        }
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestData
{
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
                           @"ProjectRiskId":[self.riskDataDic objectForKey:@"id"]};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_DETAIL) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            self.riskDetailDataDic = (NSDictionary*)[result objectForKey:@"data"];
            if (self.riskDetailDataDic == nil)
            {
                [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
            }else{
                [self initViewByDetailData];
            }
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

-(void)testExecutiveData
{
    NSError *jsonError;
    NSData *objectData = [@"{    \"lllegal_1\": \"<p>AAAAAAAAAAAAAAAAAAAAAAA</p>\",    \"riskfill\": {        \"creatTime\": 1470931200000,        \"id\": 34,        \"jlOnWork\": \"<p>项目总监：按个</p>\",        \"progress\": \"<p>还不错</p>\",        \"progressValue\": \"24\",        \"projectRiskId\": 74,        \"sgOnWork\": \"<p>施工项目经理：早</p>\",        \"userId\": \"a2a6adfc78f043cbb50150f9921b34e0\",        \"working\": \"<p>施工方案一：</p></p>\",        \"yzOnWork\": \"<p>项目经理：张三</p><p>安全员：历史</p>\"    },    \"state\": 1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        self.repairInfoJsonString = (NSString*)[result objectForKey:@"lllegal_1"];
        self.riskExecutiveDataDic = (NSDictionary*)[result objectForKey:@"riskfill"];
        if (self.repairInfoJsonString == nil || self.riskExecutiveDataDic == nil)
        {
            [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }else{
            [self initViewByExecutiveData];
        }
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestExecutiveData:(double)time
{
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
                           @"ProjectRiskId":[self.riskDataDic objectForKey:@"id"],
                           @"now_day":@(time)};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_DAYINFO) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            self.repairInfoJsonString = (NSString*)[result objectForKey:@"lllegal_1"];
            self.riskExecutiveDataDic = (NSDictionary*)[result objectForKey:@"riskfill"];
            if (self.repairInfoJsonString == nil || self.riskExecutiveDataDic == nil)
            {
                [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
            }else{
                [self initViewByExecutiveData];
            }
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

-(void)testStopData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\": 1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        if (self.stopBtn.tag == 0)
        {
            [[JTToast toastWithText:@"当前的施工操作已经停止" configuration:[JTToastConfiguration defaultConfiguration]]show];
            self.stopBtn.tag = 1;
            [self.stopBtn setBackgroundImage:[UIImage imageNamed:@"recovery.png"] forState:UIControlStateNormal];
            [self.writeBtn setHidden:YES];
        }else{
            [[JTToast toastWithText:@"当前的施工操作已经恢复" configuration:[JTToastConfiguration defaultConfiguration]]show];
            self.stopBtn.tag = 0;
            [self.stopBtn setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
            if ([self getRight:self.writeBtn]) [self.writeBtn setHidden:NO];
        }
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestStopOperate:(int)state
{
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
                           @"ProjectRiskId":[self.riskDataDic objectForKey:@"id"],
                           @"state":@(state)};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_UPDATESTATE) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            if (self.stopBtn.tag == 0)
            {
                [[JTToast toastWithText:@"当前的施工操作已经停止" configuration:[JTToastConfiguration defaultConfiguration]]show];
                self.stopBtn.tag = 1;
                [self.stopBtn setBackgroundImage:[UIImage imageNamed:@"recovery.png"] forState:UIControlStateNormal];
                [self.writeBtn setHidden:YES];
            }else{
                [[JTToast toastWithText:@"当前的施工操作已经恢复" configuration:[JTToastConfiguration defaultConfiguration]]show];
                self.stopBtn.tag = 0;
                [self.stopBtn setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
                if ([self getRight:self.writeBtn]) [self.writeBtn setHidden:NO];
            }
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
    if(self.riskDetailDataDic == nil) return;
    self.projectNameLabel.text = [self.riskDetailDataDic objectForKey:@"NAME"];
    self.addressLabel.text = [self.riskDetailDataDic objectForKey:@"ADDRESS"];
    
    NSDate *startTimeDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[self.riskDetailDataDic objectForKey:@"plan_start_time"] doubleValue] / 1000.0)];
    self.startTimeLabel.text = [dtfrm stringFromDate:startTimeDate];
    NSDate *endTimeDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[self.riskDetailDataDic objectForKey:@"plan_end_time"] doubleValue] / 1000.0)];
    self.endTimeLabel.text = [dtfrm stringFromDate:endTimeDate];
    // Set stop button`s state.
    int isActive = [(NSNumber*)[self.riskDataDic objectForKey:@"is_active"] intValue];
    if (isActive == Active_State_Stop)
    {
        self.stopBtn.tag = 1;
        [self.stopBtn setBackgroundImage:[UIImage imageNamed:@"recovery.png"] forState:UIControlStateNormal];
        [self.writeBtn setHidden:YES];
    }else{
        self.stopBtn.tag = 0;
        [self.stopBtn setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        if ([self getRight:self.writeBtn]) [self.writeBtn setHidden:NO];
    }
    self.riskExecutiveTimeArray = [self.riskDetailDataDic objectForKey:@"day_liat"];
    if (self.riskExecutiveTimeArray == nil || self.riskExecutiveTimeArray.count == 0)
    {
        [[JTToast toastWithText:@"未查询到现场执行信息到数据" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }else{
        NSDate *executiveTimeDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[(NSDictionary*)[self.riskExecutiveTimeArray objectAtIndex:0] objectForKey:@"creat_time"] doubleValue] / 1000.0)];
        [self.dateBtn setTitle:[[[dtfrm stringFromDate:executiveTimeDate] componentsSeparatedByString:@" "] objectAtIndex:0] forState:UIControlStateNormal];
        [self timeChooseControl:[(NSNumber*)[(NSDictionary*)[self.riskExecutiveTimeArray lastObject] objectForKey:@"creat_time"] doubleValue]];
    }
    self.sgProcessLabel.text = [NSString stringWithFormat:@"%.0f%%", currentProcess];
    [self.sgProcessView setProgress: currentProcess / 100.0];
}

-(void)initViewByExecutiveData
{
    if (self.repairInfoJsonString != nil)
    {
        [self.repairInfoWebView loadHTMLString:self.repairInfoJsonString baseURL:[NSURL URLWithString:URL_SERVER]];
    }
    if (self.riskExecutiveDataDic != nil)
    {
        NSString *htmlString = @"";
        if([self.riskExecutiveDataDic objectForKey:@"yzOnWork"] != nil) htmlString = [htmlString stringByAppendingString:[self.riskExecutiveDataDic objectForKey:@"yzOnWork"]];
        if (htmlString == nil || htmlString.length < 2)
        {
//            self.yzPersonInfoContainerHeightCons.constant = 0;
            [self.yzPersonInfoWebView loadHTMLString:@"暂无情况。" baseURL:nil];
        }else{
            [self.yzPersonInfoWebView loadHTMLString:htmlString baseURL:nil];
        }
        htmlString = @"";
        if([self.riskExecutiveDataDic objectForKey:@"sgOnWork"] != nil) htmlString = [htmlString stringByAppendingString:[self.riskExecutiveDataDic objectForKey:@"sgOnWork"]];
        if (htmlString == nil || htmlString.length < 2)
        {
//            self.sgPersonInfoContainerHeightCons.constant = 0;
            [self.sgpersonInfoWebView loadHTMLString:@"暂无情况。" baseURL:nil];
        }else{
            [self.sgpersonInfoWebView loadHTMLString:htmlString baseURL:nil];
        }
        htmlString = @"";
        if([self.riskExecutiveDataDic objectForKey:@"jlOnWork"] != nil) htmlString = [htmlString stringByAppendingString:[self.riskExecutiveDataDic objectForKey:@"jlOnWork"]];
        if (htmlString == nil || htmlString.length < 2)
        {
//            self.jlPersonInfoContainerHeightCons.constant = 0;
            [self.jlPersonInfoWebView loadHTMLString:@"暂无情况。" baseURL:nil];
        }else{
            [self.jlPersonInfoWebView loadHTMLString:htmlString baseURL:nil];
        }
        [self.executiveInfoWebView loadHTMLString:(NSString *)[self.riskExecutiveDataDic objectForKey:@"working"] baseURL:nil];
        [self.processInfoWebView loadHTMLString:(NSString *)[self.riskExecutiveDataDic objectForKey:@"progress"] baseURL:nil];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    float scale = ScreenHeight / 667;
    if(webView == self.yzPersonInfoWebView)
    {
        self.yzPersonInfoWebViewHeight.constant = self.yzPersonInfoWebView.scrollView.contentSize.height;
        self.yzPersonInfoContainerHeightCons.constant = 30 * scale + self.yzPersonInfoWebViewHeight.constant;
    }else if(webView == self.jlPersonInfoWebView){
        self.jlPersonInfoWebViewHeight.constant = self.jlPersonInfoWebView.scrollView.contentSize.height;
        self.jlPersonInfoContainerHeightCons.constant = 30 * scale + self.jlPersonInfoWebViewHeight.constant;
    }else if(webView == self.sgpersonInfoWebView){
        self.sgPersonInfoWebViewHeight.constant = self.sgpersonInfoWebView.scrollView.contentSize.height;
        self.sgPersonInfoContainerHeightCons.constant = 30 * scale + self.sgPersonInfoWebViewHeight.constant;
    }else if(webView == self.executiveInfoWebView){
        self.executiveInfoWebViewHeight.constant = self.executiveInfoWebView.scrollView.contentSize.height;
    }else if(webView == self.repairInfoWebView){
        self.repairInfoWebViewHeight.constant = self.repairInfoWebView.scrollView.contentSize.height;
    }else if(webView == self.processInfoWebView){
        self.processInfoWebViewHeight.constant = self.processInfoWebView.scrollView.contentSize.height;
    }
    [self updateViewConstraints];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"ERROR>>>>>%@", error.description)
    if (error.code == 101)
    {
        [[JTToast toastWithText:@"不可以在APP内部打开此链接" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }
    if(webView == self.yzPersonInfoWebView)
    {
        [[JTToast toastWithText:[NSString stringWithFormat:@"业主人员到岗情况加载失败(%ld)，请重试", (long)error.code]
                  configuration:[JTToastConfiguration defaultConfiguration]]show];
    }else if(webView == self.jlPersonInfoWebView){
        [[JTToast toastWithText:[NSString stringWithFormat:@"监理人员到岗情况加载失败(%ld)，请重试", (long)error.code]
                  configuration:[JTToastConfiguration defaultConfiguration]]show];
    }else if(webView == self.sgpersonInfoWebView){
        [[JTToast toastWithText:[NSString stringWithFormat:@"施工人员到岗情况加载失败(%ld)，请重试", (long)error.code]
                  configuration:[JTToastConfiguration defaultConfiguration]]show];
    }else if(webView == self.executiveInfoWebView){
        [[JTToast toastWithText:[NSString stringWithFormat:@"施工现场执行情况加载失败(%ld)，请重试", (long)error.code]
                  configuration:[JTToastConfiguration defaultConfiguration]]show];
    }else if(webView == self.repairInfoWebView){
        [[JTToast toastWithText:[NSString stringWithFormat:@"违章整改情况加载失败(%ld)，请重试", (long)error.code]
                  configuration:[JTToastConfiguration defaultConfiguration]]show];
    }else if(webView == self.processInfoWebView){
        [[JTToast toastWithText:[NSString stringWithFormat:@"施工进度信息加载失败(%ld)，请重试", (long)error.code]
                  configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

- (IBAction)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)writeBtnClick:(id)sender
{
    if([(NSNumber*)[self.riskDataDic objectForKey:@"schedule"] intValue] == 100)
    {
        [[JTToast toastWithText:@"进度达到100%，无法进行填报" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }
    [self performSegueWithIdentifier:@"ToAddRiskExecutiveInfo" sender:self];
}

- (IBAction)stopBtnClick:(id)sender
{
    UIAlertController * alert = nil;
    if (self.stopBtn.tag == 0)
    {
        alert = [UIAlertController alertControllerWithTitle:@"停止施工" message:@"确定要停止当前的风险施工吗？" preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:@"恢复施工" message:@"确定要恢复当前的风险施工吗？" preferredStyle:UIAlertControllerStyleAlert];
    }
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             if (OFFLINE)
                             {
                                 [self testStopData];
                             }else{
                                 [self requestStopOperate:(int)(self.stopBtn.tag)];
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

- (IBAction)dateBtnClick:(id)sender
{
    RiskExecutiveTimeListViewController *riskExecutiveTimeListViewController = [[RiskExecutiveTimeListViewController alloc] initWithNibName:@"RiskExecutiveTimeListViewController" bundle:nil];
    riskExecutiveTimeListViewController.modalPresentationStyle = UIModalPresentationCustom;
    riskExecutiveTimeListViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    riskExecutiveTimeListViewController.delegate = self;
    [riskExecutiveTimeListViewController initViewWithData:self.riskExecutiveTimeArray];
    [self presentViewController:riskExecutiveTimeListViewController animated:YES completion:nil];
}

-(void)timeChooseControl:(double)timeValue
{
    NSDate *executiveTimeDate = [NSDate dateWithTimeIntervalSince1970:(timeValue / 1000.0)];
    [self.dateBtn setTitle:[[[dtfrm stringFromDate:executiveTimeDate] componentsSeparatedByString:@" "] objectAtIndex:0] forState:UIControlStateNormal];
    if (OFFLINE)
    {
        [self testExecutiveData];
    }else{
        [self requestExecutiveData:timeValue];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ToAddRiskExecutiveInfo"])
    {
        RiskAddViewController *riskAddViewController = [segue destinationViewController];
        riskAddViewController.delegate = self;
        [riskAddViewController initViewWithRisk:self.riskDataDic andDetail:self.riskDetailDataDic andProcess:currentProcess];
    }
}

-(void)riskExecutiveInfoAddSuccessWithProcess:(float)process
{
    [self initViewWithData:self.riskDataDic];
    currentProcess = process;
}

@end
