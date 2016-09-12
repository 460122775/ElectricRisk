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
    NSData *objectData = [@"{\"level3\":2,\"level4\":1,\"state\":1,\"type3\":[{\"total\":1,\"type\":\"\"},{\"total\":1,\"type\":\"高大模板支撑\"}],\"type4\":[{\"total\":1,\"type\":\"高大模板支撑\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
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
                             @"uid":[NSString stringWithFormat:@"%i", [SystemConfig instance].currentUserId]};
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
    NSMutableArray *typeTitleArr = [[NSMutableArray alloc] init];
//    NSMutableArray *typeTitleArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dataDic in type3Arr)
    {
        
    }
    
    [self loadBarChartUsingArray:self.type3ChartView];
    
    [self loadBarChartUsingArray:self.type4ChartView];
}

- (void)loadBarChartUsingArray:(BarChartView*)barChart
{
    //Generate properly formatted data to give to the bar chart
    NSArray *array = [barChart createChartDataWithTitles:[NSArray arrayWithObjects:@"Title 1", @"Title 2", @"Title 3", @"Title 4", nil]
                                                  values:[NSArray arrayWithObjects:@"4.7", @"8.3", @"17", @"5.4", nil]
                                                  colors:[NSArray arrayWithObjects:@"87E317", @"17A9E3", @"E32F17", @"FFE53D", nil]
                                             labelColors:[NSArray arrayWithObjects:@"000000", @"000000", @"000000", @"000000", nil]];
    
    //Set the Shape of the Bars (Rounded or Squared) - Rounded is default
    [barChart setupBarViewShape:BarShapeRounded];
    
    //Set the Style of the Bars (Glossy, Matte, or Flat) - Glossy is default
    [barChart setupBarViewStyle:BarStyleGlossy];
    
    //Set the Drop Shadow of the Bars (Light, Heavy, or None) - Light is default
    [barChart setupBarViewShadow:BarShadowLight];
    
    //Generate the bar chart using the formatted data
    [barChart setDataWithArray:array
                      showAxis:DisplayBothAxes
                     withColor:[UIColor darkGrayColor]
       shouldPlotVerticalLines:YES];
}

- (IBAction)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
