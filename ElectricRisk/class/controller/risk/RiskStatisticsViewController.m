//
//  RiskStatisticsViewController.m
//  ElectricRisk
//
//  Created by Yachen Dai on 9/12/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "RiskStatisticsViewController.h"

@interface RiskStatisticsViewController ()

@end

@implementation RiskStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (OFFLINE)
    {
        [self testData];
    }else{
        [self requestData:nil];
    }
}

-(void)testData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"level3\":2,\"level4\":2,\"state\":1,\"type3\":[{\"total\":2,\"type\":\"Test3\"},{\"total\":4,\"type\":\"高大模板支撑\"}],\"type4\":[{\"total\":1,\"type\":\"高大模板支撑\"}, {\"total\":3,\"type\":\"高大模板支撑2\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        level3Count = [(NSNumber*)[result objectForKey:@"level3"] intValue];
        level4Count = [(NSNumber*)[result objectForKey:@"level4"] intValue];
        type3Arr = [result objectForKey:@"type3"];
        type4Arr = [result objectForKey:@"type4"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initStatistic];
        });
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestData:(NSDictionary*)dict
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
    
    if(dict == nil) dict = @{@"c_time":[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000],
                             @"uid":[SystemConfig instance].currentUserId};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_LIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            level3Count = [(NSNumber*)[result objectForKey:@"level3"] intValue];
            level4Count = [(NSNumber*)[result objectForKey:@"level4"] intValue];
            type3Arr = [result objectForKey:@"type3"];
            type4Arr = [result objectForKey:@"type4"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initStatistic];
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


-(void)initStatistic
{
    self.type3Label.text = [NSString stringWithFormat:@"重要3级风险(%i)", level3Count];
    NSArray *fgColorArr = [[NSArray alloc] initWithObjects:@"FF3366",@"CC0099",@"0066CC",@"3C3C3C",@"600000",@"9F0050",@"750075",@"ADADAD",@"FF2D2D",@"FF79BC",@"FF77FF",@"DDDDFF",@"C4E1FF",@"D9FFFF",@"D7FFEE", nil];
    NSArray *bgColorArr = [[NSArray alloc] initWithObjects:@"000000",@"000000",@"000000",@"000000",@"000000",@"000000",@"000000",@"000000",@"000000",@"000000",@"000000",@"000000",@"000000",@"000000",@"000000", nil];
    
    NSMutableArray *type3TitleArr = [[NSMutableArray alloc] init];
    NSMutableArray *type3ValueArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dataDicTemp in type3Arr)
    {
        [type3TitleArr addObject:[dataDicTemp objectForKey:@"type"]];
        [type3ValueArr addObject:[NSString stringWithFormat:@"%i", [(NSNumber*)[dataDicTemp objectForKey:@"total"] intValue]]];
    }
    NSArray *type3Array = [self.type3ChartView createChartDataWithTitles:type3TitleArr
                                 values:type3ValueArr
                                 colors:[fgColorArr subarrayWithRange:NSMakeRange(0, type3Arr.count)]
                            labelColors:[bgColorArr subarrayWithRange:NSMakeRange(0, type3Arr.count)]];
    [self.type3ChartView setupBarViewShape:BarShapeRounded];
    [self.type3ChartView setupBarViewStyle:BarStyleGlossy];
    [self.type3ChartView setupBarViewShadow:BarShadowLight];
    [self.type3ChartView setDataWithArray:type3Array showAxis:DisplayBothAxes withColor:[UIColor darkGrayColor] shouldPlotVerticalLines:YES];
    
    self.type4Label.text = [NSString stringWithFormat:@"4级风险(%i)", level4Count];
    NSMutableArray *type4TitleArr = [[NSMutableArray alloc] init];
    NSMutableArray *type4ValueArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dataDicTemp in type4Arr)
    {
        [type4TitleArr addObject:[dataDicTemp objectForKey:@"type"]];
        [type4ValueArr addObject:[NSString stringWithFormat:@"%i", [(NSNumber*)[dataDicTemp objectForKey:@"total"] intValue]]];
    }
    NSArray *type4Array = [self.type4ChartView createChartDataWithTitles:type4TitleArr
                                                                  values:type4ValueArr
                                                                  colors:[fgColorArr subarrayWithRange:NSMakeRange(0, type4Arr.count)]
                                                             labelColors:[bgColorArr subarrayWithRange:NSMakeRange(0, type4Arr.count)]];
    [self.type4ChartView setupBarViewShape:BarShapeRounded];
    [self.type4ChartView setupBarViewStyle:BarStyleGlossy];
    [self.type4ChartView setupBarViewShadow:BarShadowLight];
    [self.type4ChartView setDataWithArray:type4Array showAxis:DisplayBothAxes withColor:[UIColor darkGrayColor] shouldPlotVerticalLines:YES];
}

- (IBAction)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
