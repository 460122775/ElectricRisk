//
//  RiskMainViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "RiskMainViewController.h"

@interface RiskMainViewController ()

@end

@implementation RiskMainViewController

static NSString *RiskMainListCellId = @"RiskMainListCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    headerNameArray = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RiskMainListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:RiskMainListCellId];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (OFFLINE)
    {
        [self testData];
    }else{
        [self requestData];
    }
    selectedDataDic = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"data\":[{\"content\":[{\"address\":\"卡升级卢萨卡的减肥还是啦快点发货\",\"content\":\"施工准备\",\"id\":47,\"is_active\":1,\"schedule\":0,\"time\":1469980800000,\"title\":\"测试项目测试项目\"}],\"grade\":1},{\"content\":[{\"address\":\"dfgd\",\"content\":\"施工准备\",\"id\":76,\"is_active\":0,\"schedule\":0,\"time\":1470844800000,\"title\":\"第六个\"}],\"grade\":2},{\"content\":[{\"address\":\"dfgd\",\"content\":\"架设架空线路\",\"id\":89,\"is_active\":0,\"schedule\":0,\"time\":1471449600000,\"title\":\"第六个\"}],\"grade\":4},{\"content\":[{\"address\":\"dfgd\",\"content\":\"配电箱及开关箱安装\",\"id\":88,\"is_active\":1,\"schedule\":0,\"time\":1471449600000,\"title\":\"第六个\"}],\"grade\":5}],\"projects\":[{\"id\":17,\"name\":\"天祥广场\"},{\"id\":18,\"name\":\"新希望中心\"},{\"id\":19,\"name\":\"test111\"}],\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        projectArray = (NSArray*)[result objectForKey:@"projects"];
        totalDataArray = (NSArray*)[result objectForKey:@"data"];
        if (totalDataArray == nil || totalDataArray.count == 0)
        {
            [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }else{
            dataDic = [[NSMutableDictionary alloc] init];
            [headerNameArray removeAllObjects];
            NSMutableArray* dataArrTemp = nil;
            for (NSDictionary* tempDic in totalDataArray)
            {
                int grade = [(NSNumber*)[tempDic objectForKey:@"grade"] intValue];
                dataArrTemp = [dataDic objectForKey:[NSString stringWithFormat:@"%i", grade]];
                if (dataArrTemp == nil)
                {
                    dataArrTemp = [tempDic objectForKey:@"content"];
                    [dataDic setObject:dataArrTemp forKey:[NSString stringWithFormat:@"%i", grade]];
                    [headerNameArray addObject:[NSString stringWithFormat:@"%i", grade]];
                }
            }
        }
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
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
                           @"area":@"",
                           @"projectid":@"",
                           @"levelStart":@"1",
                           @"levelEnd":@"9"};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_LIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            totalDataArray = (NSArray*)[result objectForKey:@"data"];
            if (totalDataArray == nil || totalDataArray.count == 0)
            {
                [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
            }else{
                dataDic = [[NSMutableDictionary alloc] init];
                [headerNameArray removeAllObjects];
                NSMutableArray* dataArrTemp = nil;
                for (NSDictionary* tempDic in totalDataArray)
                {
                    int grade = [(NSNumber*)[tempDic objectForKey:@"grade"] intValue];
                    dataArrTemp = [dataDic objectForKey:[NSString stringWithFormat:@"%i", grade]];
                    if (dataArrTemp == nil)
                    {
                        dataArrTemp = [tempDic objectForKey:@"content"];
                        [dataDic setObject:dataArrTemp forKey:[NSString stringWithFormat:@"%i", grade]];
                        [headerNameArray addObject:[NSString stringWithFormat:@"%i", grade]];
                    }
                }
            }
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

- (IBAction)searchBtnClick:(id)sender
{
    RiskSearchViewController *riskSearchViewController = [[RiskSearchViewController alloc] initWithNibName:@"RiskSearchViewController" bundle:nil];
    riskSearchViewController.modalPresentationStyle = UIModalPresentationCustom;
    riskSearchViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:riskSearchViewController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (headerNameArray == nil) return 0;
    return headerNameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataDic == nil || headerNameArray == nil) return 0;
    NSString *key = [headerNameArray objectAtIndex:section];
    if ([dataDic objectForKey:key] == nil) return 0;
    NSArray *rowArr = (NSArray*)[dataDic objectForKey:key];
    return rowArr.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 200, 17)];
    titleLabel.text = [NSString stringWithFormat:@"%@级风险", [headerNameArray objectAtIndex:section]];
    titleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel];
    if([[headerNameArray objectAtIndex:section] isEqualToString:@"1"])
    {
        [headerView setBackgroundColor:Color_oneGrade];
    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"2"]){
        [headerView setBackgroundColor:Color_twoGrade];
    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"3"]){
        [headerView setBackgroundColor:Color_threeGrade];
    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"4"]){
        [headerView setBackgroundColor:Color_fourGrade];
    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"5"]){
        [headerView setBackgroundColor:Color_fiveGrade];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RiskMainListCell *cell= [tableView dequeueReusableCellWithIdentifier:RiskMainListCellId];
    NSString *key = [headerNameArray objectAtIndex:indexPath.section];
    NSArray *rowArr = (NSArray*)[dataDic objectForKey:key];
    cell.dataDic = [rowArr objectAtIndex:indexPath.row];
    [cell setViewByData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = [headerNameArray objectAtIndex:indexPath.section];
    NSArray *rowArr = (NSArray*)[dataDic objectForKey:key];
    selectedDataDic = [rowArr objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"RiskToDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RiskToDetail"])
    {
        RiskDetailViewController *riskDetailViewController = [segue destinationViewController];
        [riskDetailViewController initViewWithData:selectedDataDic];
    }
}

@end
