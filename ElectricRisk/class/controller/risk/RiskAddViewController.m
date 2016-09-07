//
//  RiskDetailViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "RiskAddViewController.h"

@interface RiskAddViewController ()

@end

@implementation RiskAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initViewWithRisk:self.riskDataDic andDetail:self.riskDetailDataDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewWithRisk:(NSDictionary*)riskDataDic andDetail:(NSDictionary*) riskDetailDic
{
    self.riskDataDic = riskDataDic;
    self.riskDetailDataDic = riskDetailDic;
    if (self.addressLabel == nil) return;
    if (OFFLINE)
    {
        [self testGetWrongData];
    }else{
        [self requestGetWrongData];
    }
    [self initViewByDetailData];
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
        [[JTToast toastWithText:@"提交成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate != nil) [self.delegate riskExecutiveInfoAddSuccess];
        });
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
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

-(void)testImgUploadData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"original\": \"无标题4.png\",    \"size\": 21339,    \"state\": \"SUCCESS\",    \"title\": \"/project/getImg.do?id=e1566f6b614f4c8b91aacb173496ea43\",    \"type\": \"4.png\",    \"url\": \"/project/getImg.do?id=e1566f6b614f4c8b91aacb173496ea43\",    \"id\": \"e1566f6b614f4c8b91aacb173496ea43\"}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    NSString *state = [result objectForKey:@"state"];
    if ([state isEqualToString:@"SUCCESS"])
    {
        NSString *imgId = [result objectForKey:@"id"];
        [[JTToast toastWithText:@"图片上传成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestImgUploadData
{
    if (HUD == nil)
    {
        HUD = [[MBProgressHUD alloc]init];
    }
    [self.view addSubview:HUD];
    HUD.dimBackground =YES;
    HUD.labelText = @"正在上传图片...";
    [HUD removeFromSuperViewOnHide];
    [HUD showByCustomView:YES];
    
    NSDictionary *dict = @{@"upfile":[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000]};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_UPLOADIMG) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        NSString *state = [result objectForKey:@"state"];
        if ([state isEqualToString:@"SUCCESS"])
        {
            NSString *imgId = [result objectForKey:@"id"];
            [[JTToast toastWithText:@"图片上传成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

-(void)testGetWrongData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\": 1,\"data\": [{\"id\": \"73056ba2fdce4d528f53081365790813\",\"content\": \"nnn\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        self.wrongDataArray = [result objectForKey:@"data"];
        currentSelectWrongDic = nil;
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestGetWrongData
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
                           @"id":[self.riskDataDic objectForKey:@"id"]};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_DAYINFO) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            self.wrongDataArray = [result objectForKey:@"data"];
            currentSelectWrongDic = nil;
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
    NSDate *nowTimeDate = [[NSDate alloc] init];
    self.currentDateLabel.text = [dtfrm stringFromDate:nowTimeDate];
}

- (IBAction)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishBtnClick:(id)sender
{
    
}

- (IBAction)dateBtnClick:(id)sender
{
    RiskWrongListViewController *riskWrongListViewController = [[RiskWrongListViewController alloc] initWithNibName:@"RiskWrongListViewController" bundle:nil];
    riskWrongListViewController.modalPresentationStyle = UIModalPresentationCustom;
    riskWrongListViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    riskWrongListViewController.delegate = self;
    [riskWrongListViewController initViewWithData:self.wrongDataArray];
    [self presentViewController:riskWrongListViewController animated:YES completion:nil];
}

-(void)wrongListChooseControl:(NSDictionary*)wrongDic
{
    currentSelectWrongDic = wrongDic;
}

@end
