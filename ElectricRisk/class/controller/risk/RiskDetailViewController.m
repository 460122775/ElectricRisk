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
    self.personInfoWebView.delegate = self;
    self.executiveInfoWebView.delegate = self;
    self.repairInfoWebView.delegate = self;
    self.processInfoWebView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewWithData:(NSDictionary*)dataDic
{
    self.riskDataDic = dataDic;
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
    NSData *objectData = [@"{    \"lllegal_1\": \"<p>\t\t\t\t\t\t\t\r\n\t</p><table><tbody><tr><td width=\\\"99\\\" valign=\\\"top\\\">序号</td><td width=\\\"99\\\" valign=\\\"top\\\">违章情况</td><td width=\\\"99\\\" valign=\\\"top\\\">违章图片</td><td width=\\\"99\\\" valign=\\\"top\\\">整改情况</td><td width=\\\"99\\\" valign=\\\"top\\\">整改图片</td></tr><tr><td width=\\\"99\\\" valign=\\\"top\\\">1</td><td width=\\\"99\\\" valign=\\\"top\\\">现场吸烟</td><td width=\\\"99\\\" valign=\\\"top\\\"><img src=\\\"/jj/project/getImg.do?id=f63dd2a1a24249429b102d766f2615d8\\\" title=\\\"/project/getImg.do?id=f63dd2a1a24249429b102d766f2615d8\\\" alt=\\\"zhang.gif\\\"/></td><td width=\\\"99\\\" valign=\\\"top\\\">已完成整改</td><td width=\\\"99\\\" valign=\\\"top\\\"><img src=\\\"/jj/project/getImg.do?id=e4c34ad94ed84d0fa57657fa50064734\\\" title=\\\"/project/getImg.do?id=e4c34ad94ed84d0fa57657fa50064734\\\" alt=\\\"0ZXQPS%251M@OEJB{Q]}Q_A.jpg\\\" width=\\\"236\\\" height=\\\"214\\\"/></td></tr></tbody></table><p>\r\n\r\n\r\n\t\t\t\t\t</p>\",    \"riskfill\": {        \"creatTime\": 1470931200000,        \"id\": 34,        \"jlOnWork\": \"<p>项目总监：按个</p>\",        \"progress\": \"<p>还不错<img src=\\\"/jj/project/getImg.do?id=987a746d31a54cf2ae312eb5b35361d0\\\" title=\\\"/project/getImg.do?id=987a746d31a54cf2ae312eb5b35361d0\\\" alt=\\\"无标题2.png\\\"/></p>\",        \"progressValue\": \"24\",        \"projectRiskId\": 74,        \"sgOnWork\": \"<p>施工项目经理：早</p>\",        \"userId\": \"a2a6adfc78f043cbb50150f9921b34e0\",        \"working\": \"<p>施工方案一：</p><p><img src=\\\"/jj/project/getImg.do?id=3fb6332e20d94301987f877876f80535\\\" title=\\\"/project/getImg.do?id=3fb6332e20d94301987f877876f80535\\\"/></p><p><img src=\\\"/jj/project/getImg.do?id=6a52274a984f4358ac0e28f194404bcf\\\" title=\\\"/project/getImg.do?id=6a52274a984f4358ac0e28f194404bcf\\\"/></p><p><br/></p>\",        \"yzOnWork\": \"<p>项目经理：张三</p><p>安全员：历史</p>\"    },    \"state\": 1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        self.repairInfoJsonString = (NSString*)[result objectForKey:@"lllegal_1"];
        self.riskDetailDataDic = (NSDictionary*)[result objectForKey:@"riskfill"];
        if (self.repairInfoJsonString == nil || self.riskDetailDataDic == nil)
        {
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"未获取到数据，或数据为空"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }else{
            [self initViewByData];
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
                           @"uid":[NSString stringWithFormat:@"%i", [SystemConfig instance].currentUserId],
                           @"ProjectRiskId":@"",
                           @"now_day":@""};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_LIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            self.repairInfoJsonString = (NSString*)[result objectForKey:@"lllegal_1"];
            self.riskDetailDataDic = (NSDictionary*)[result objectForKey:@"riskfill"];
            if (self.repairInfoJsonString == nil || self.riskDetailDataDic == nil)
            {
                [[JTToast toastWithText:(NSString*)[result objectForKey:@"未获取到数据，或数据为空"] configuration:[JTToastConfiguration defaultConfiguration]]show];
            }else{
                [self initViewByData];
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

-(void)initViewByData
{
    if (self.repairInfoJsonString != nil)
    {
        [self.repairInfoWebView loadHTMLString:self.repairInfoJsonString baseURL:[NSURL URLWithString:URL_SERVER]];
    }
    if (self.riskDetailDataDic != nil)
    {
        self.projectNameLabel.text = [self.riskDataDic objectForKey:@"NAME"];
        self.addressLabel.text = [self.riskDataDic objectForKey:@"ADDRESS"];
        self.startTimeLabel.text = [self.riskDataDic objectForKey:@"NAME"];
        self.endTimeLabel.text = [self.riskDataDic objectForKey:@"NAME"];
        
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[self.dataDic objectForKey:@"time"] doubleValue] / 1000.0)];
        NSDateFormatter *dtfrm = [[NSDateFormatter alloc] init];
        [dtfrm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.timeLabel.text = [dtfrm stringFromDate:date];
        
        [self.repairInfoWebView loadHTMLString:self.repairInfoJsonString baseURL:[NSURL URLWithString:URL_SERVER]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(webView == self.personInfoWebView)
    {
        self.personInfoWebViewHeight.constant = self.personInfoWebView.scrollView.contentSize.height;
    }else if(webView == self.executiveInfoWebView){
        self.executiveInfoWebViewHeight.constant = self.executiveInfoWebView.scrollView.contentSize.height;
    }else if(webView == self.repairInfoWebView){
        self.repairInfoWebViewHeight.constant = self.repairInfoWebView.scrollView.contentSize.height;
    }else if(webView == self.processInfoWebView){
        self.processInfoWebViewHeight.constant = self.processInfoWebView.scrollView.contentSize.height;
    }
    [self updateViewConstraints];
}

- (IBAction)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)writeBtnClick:(id)sender
{
    
}

- (IBAction)stopBtnClick:(id)sender
{
    
}

- (IBAction)dateBtnClick:(id)sender
{
    
}

@end
