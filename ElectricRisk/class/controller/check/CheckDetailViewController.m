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
    [self initViewWithData:self.checkDataDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    NSData *objectData = [@" \"data\": {        \"bslc\": 3,        \"bsxx\": {            \"code\": \"dlg\",            \"content\": \"报审内容\",            \"create_time\": 1471449600000,            \"name\": \"dlg-sg-1\",            \"project_name\": \"第六个\"        },        \"sp_state\": 0,        \"spxx\": {            \"jl_content\": \"Hello world.\",            \"jl_name\": \"dlg-jl-1\",            \"jl_time\": 1471449600000,            \"jl_yj\": 2,            \"yz_content\": \"\",            \"yz_name\": \"dlg-yz-1\",            \"yz_time\": 1471449600000,            \"yz_yj\": 2        }    },    \"state\": 1}" dataUsingEncoding:NSUTF8StringEncoding];
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
                           @"uid":[NSString stringWithFormat:@"%i", [SystemConfig instance].currentUserId],
                           @"id":[self.checkDataDic objectForKey:@"id"],
                           @"type":@TYPE_CHECK};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_NOTICE_COMMENT_LIST) parameter:dict header:nil content:nil success:^(id responseData) {
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
    
    int lcValue = [(NSNumber*)[bsDic objectForKey:@"bslc"] doubleValue];
    NSDictionary *spDic = [self.checkDetailDataDic objectForKey:@"spxx"];
    
    
    if (spDic != nil)
    {
        if (lcValue > 1)
        {
            self.spContentView.text = [spDic objectForKey:@"jl_yj"];
            self.spContentViewHeight.constant = self.spContentView.contentSize.height;
            self.spCompanyNameLabel.text = [spDic objectForKey:@"jl_name"];
            NSDate *spDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[spDic objectForKey:@"jl_time"] doubleValue] / 1000.0)];
            self.spTimeLabel.text = [dtfrm stringFromDate:spDate];
            
        }else{
            
        }
        
        if (lcValue > 2)
        {
            self.yzContentView.text = [spDic objectForKey:@"yz_yj"];
            self.yzCompanyNameLabel.text = [spDic objectForKey:@"yz_name"];
            NSDate *yzDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[spDic objectForKey:@"yz_time"] doubleValue] / 1000.0)];
            self.yzTimeLabel.text = [dtfrm stringFromDate:yzDate];
        }
        
        if (lcValue > 3)
        {
            self.jgContentView.text = [spDic objectForKey:@"jg_yj"];
            self.jgCompanyNameLabel.text = [spDic objectForKey:@"jg_name"];
            NSDate *jgDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[spDic objectForKey:@"jg_time"] doubleValue] / 1000.0)];
            self.jgTimeLabel.text = [dtfrm stringFromDate:jgDate];
        }
        
        if (lcValue == 3)
        {
            
        }
    }
}

@end
